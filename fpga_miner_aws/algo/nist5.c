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

#include <sha3/sph_jh.h>
#include <sha3/sph_keccak.h>
#include <sha3/sph_echo.h>

#include <sha3/sph_blake.h>
#include <sha3/sph_groestl.h>
#include <sha3/sph_skein.h>
#include <sha3/sph_jh.h>
#include <sha3/sph_keccak.h>

static inline void be32enc_vect(uint32_t *dst, const uint32_t *src, uint32_t len)
{
  uint32_t i;
  for (i = 0; i < len; i++)
    dst[i] = htobe32(src[i]);
}

void nist5_midstate(void *state, const void *input)
{
	uint64_t *s = (uint64_t *)state;

	sph_skein512_context    ctx_skein;

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

void nist5_hash(void *state, const void *input)
{
	sph_blake512_context ctx_blake;
	sph_groestl512_context ctx_groestl;
	sph_jh512_context ctx_jh;
	sph_keccak512_context ctx_keccak;
	sph_skein512_context ctx_skein;

	uint8_t hash[64];

	sph_blake512_init(&ctx_blake);
	sph_blake512(&ctx_blake, input, 80);
	sph_blake512_close(&ctx_blake, (void*)hash);

	sph_groestl512_init(&ctx_groestl);
	sph_groestl512(&ctx_groestl, (const void*)hash, 64);
	sph_groestl512_close(&ctx_groestl, (void*)hash);

	sph_jh512_init(&ctx_jh);
	sph_jh512(&ctx_jh, (const void*)hash, 64);
	sph_jh512_close(&ctx_jh, (void*)hash);

	sph_keccak512_init(&ctx_keccak);
	sph_keccak512(&ctx_keccak, (const void*)hash, 64);
	sph_keccak512_close(&ctx_keccak, (void*)hash);

	sph_skein512_init(&ctx_skein);
	sph_skein512(&ctx_skein, (const void*)hash, 64);
	sph_skein512_close(&ctx_skein, (void*)hash);

	memcpy(state, hash, 32);

}

int scanhash_nist5(int thr_id, struct work *work, uint32_t max_nonce, uint64_t *hashes_done)
{
	int i, m;
	uint32_t _ALIGN(128) hash32[8];
	uint32_t _ALIGN(128) endiandata[20];
	uint32_t *pdata = work->data;
	uint32_t *ptarget = work->target;
	const uint32_t first_nonce = pdata[19];
	const uint32_t Htarg = ptarget[7];
	uint32_t n = pdata[19] - 1;

	uint64_t htmax[] = {
		0,
		0xF,
		0xFF,
		0xFFF,
		0xFFFF,
		0x10000000
	};
	uint32_t masks[] = {
		0xFFFFFFFF,
		0xFFFFFFF0,
		0xFFFFFF00,
		0xFFFFF000,
		0xFFFF0000,
		0
	};

	// we need bigendian data...
	for (i=0; i < 19; i++) {
		be32enc(&endiandata[i], pdata[i]);
	}

	for (m=0; m < 6; m++) {
		if (Htarg <= htmax[m]) {
			uint32_t mask = masks[m];
			do {
				pdata[19] = ++n;
				be32enc(&endiandata[19], n);
				nist5_hash(hash32, endiandata);

				if (!(n % 0x1000) && !thr_id) printf(".");
				if (!(hash32[7] & mask)) {
					printf("[%d]",thr_id);
					if (fulltest(hash32, ptarget)) {
						work_set_target_ratio(work, hash32);
						*hashes_done = n - first_nonce + 1;
						return 1;
					}
				}
			} while (n < max_nonce && !work_restart[thr_id].restart);
			// see blake.c if else to understand the loop on htmax => mask
			break;
		}
	}

	*hashes_done = n - first_nonce + 1;
	pdata[19] = n;
	return 0;
}