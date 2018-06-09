/*-
 * Copyright 2017 tpruvot
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS'' AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE
 * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
 * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
 * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 * SUCH DAMAGE.
 *
 * This file was originally written by Colin Percival as part of the Tarsnap
 * online backup system.
 */

#include "miner.h"

#include <stdlib.h>
#include <stdint.h>
#include <string.h>

#include <sha3/sph_skein.h>
#include <sha3/sph_shabal.h>
#include <sha3/sph_echo.h>
#include <sha3/sph_luffa.h>
#include <sha3/sph_fugue.h>
#include "sha3/sph_gost.h"

static inline void be32enc_vect(uint32_t *dst, const uint32_t *src, uint32_t len)
{
  uint32_t i;
  for (i = 0; i < len; i++)
    dst[i] = htobe32(src[i]);
}

void poly_midstate(void *state, const void *input)
{
	uint64_t *s = (uint64_t *)state;

	sph_skein512_context ctx_skein;

	sph_skein512_init(&ctx_skein);
	sph_skein512(&ctx_skein, input, 80);

	s[0] = ctx_skein.h0;
	s[1] = ctx_skein.h1;
	s[2] = ctx_skein.h2;
	s[3] = ctx_skein.h3;
	s[4] = ctx_skein.h4;
	s[5] = ctx_skein.h5;
	s[6] = ctx_skein.h6;
	s[7] = ctx_skein.h7;
}

void poly_hash(void *state, const void *input)
{
	sph_skein512_context    ctx_skein;
	sph_shabal512_context   ctx_shabal;
	sph_echo512_context     ctx_echo;
	sph_luffa512_context 		ctx_luffa;
	sph_fugue512_context    ctx_fugue;
	sph_gost512_context     ctx_gost;

	uint32_t hashA[16];

	sph_skein512_init(&ctx_skein);
	sph_skein512 (&ctx_skein, input, 80);
	sph_skein512_close (&ctx_skein, hashA);

	sph_shabal512_init(&ctx_shabal);
	sph_shabal512(&ctx_shabal, hashA, 64);
	sph_shabal512_close(&ctx_shabal, hashA);

	sph_echo512_init(&ctx_echo);
	sph_echo512 (&ctx_echo, hashA, 64);
	sph_echo512_close(&ctx_echo, hashA);

	sph_luffa512_init(&ctx_luffa);
	sph_luffa512(&ctx_luffa, hashA, 64);
	sph_luffa512_close(&ctx_luffa, hashA);

	sph_fugue512_init(&ctx_fugue);
	sph_fugue512 (&ctx_fugue, hashA, 64);
	sph_fugue512_close(&ctx_fugue, hashA);

	sph_gost512_init(&ctx_gost);
	sph_gost512 (&ctx_gost, hashA, 64);
	sph_gost512_close(&ctx_gost, hashA);

	memcpy(state, hashA, 32);
}

int scanhash_poly(int thr_id, struct work *work, uint32_t max_nonce, uint64_t *hashes_done)
{
	int k;
	uint32_t _ALIGN(128) hash[8];
	uint32_t _ALIGN(128) endiandata[20];
	uint32_t *pdata = work->data;
	uint32_t *ptarget = work->target;

	const uint32_t Htarg = ptarget[7];
	const uint32_t first_nonce = pdata[19];
	uint32_t nonce = first_nonce;

	if (opt_benchmark)
		ptarget[7] = 0x00ff;

	for (k = 0; k < 19; k++)
		be32enc(&endiandata[k], pdata[k]);

	do {
		be32enc(&endiandata[19], nonce);
		poly_hash(hash, endiandata);

		if (hash[7] <= Htarg && fulltest(hash, ptarget)) {
			work_set_target_ratio(work, hash);
			pdata[19] = nonce;
			*hashes_done = pdata[19] - first_nonce;
			return 1;
		}
		nonce++;

	} while (nonce < max_nonce && !work_restart[thr_id].restart);

	pdata[19] = nonce;
	*hashes_done = pdata[19] - first_nonce + 1;
	return 0;
}
