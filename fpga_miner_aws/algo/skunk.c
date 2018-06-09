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
#include <sha3/sph_cubehash.h>
#include <sha3/sph_fugue.h>
#include <sha3/sph_gost.h>

/* Move init out of loop, so init once externally,
   and then use one single memcpy with that bigger memory block */
typedef struct {
  sph_skein512_context    skein1;
  sph_cubehash512_context cubehash1;
  sph_fugue512_context    fugue1;
  sph_gost512_context     gost1;
} Xhash_context_holder;

static Xhash_context_holder base_contexts;

static void init_Xhash_contexts()
{
  sph_skein512_init(&base_contexts.skein1);
  sph_cubehash512_init(&base_contexts.cubehash1);
  sph_fugue512_init(&base_contexts.fugue1);
  sph_gost512_init(&base_contexts.gost1);
}

static inline void be32enc_vect(uint32_t *dst, const uint32_t *src, uint32_t len)
{
  uint32_t i;
  for (i = 0; i < len; i++)
    dst[i] = htobe32(src[i]);
}

void skunk_midstate(void *state, const void *input)
{
	uint64_t *s = (uint64_t *)state;
	
	init_Xhash_contexts();
	Xhash_context_holder ctx;
	memcpy(&ctx, &base_contexts, sizeof(base_contexts));

	sph_skein512(&ctx.skein1, input, 80);

	// Copy Midstate
	s[0] = ctx.skein1.h0;
	s[1] = ctx.skein1.h1;
	s[2] = ctx.skein1.h2;
	s[3] = ctx.skein1.h3;
	s[4] = ctx.skein1.h4;
	s[5] = ctx.skein1.h5;
	s[6] = ctx.skein1.h6;
	s[7] = ctx.skein1.h7;
}

void skunk_hash(void *state, const void *input)
{
  init_Xhash_contexts();

  Xhash_context_holder ctx;

  uint32_t hash[16];

  memcpy(&ctx, &base_contexts, sizeof(base_contexts));

  sph_skein512(&ctx.skein1, input, 80);
  sph_skein512_close(&ctx.skein1, hash);

  sph_cubehash512(&ctx.cubehash1, hash, 64);
  sph_cubehash512_close(&ctx.cubehash1, hash);

  sph_fugue512(&ctx.fugue1, hash, 64);
  sph_fugue512_close(&ctx.fugue1, hash);

  sph_gost512(&ctx.gost1, hash, 64);
  sph_gost512_close(&ctx.gost1, hash);

  memcpy(state, hash, 32);
}

int scanhash_skunk(int thr_id, struct work *work, uint32_t max_nonce, uint64_t *hashes_done)
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
		skunk_hash(hash, endiandata);

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
