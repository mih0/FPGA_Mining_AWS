/*
 * Copyright 2012 Luke Dashjr
 *
 * This program is free software; you can redistribute it and/or modify it
 * under the terms of the GNU General Public License as published by the Free
 * Software Foundation; either version 3 of the License, or (at your option)
 * any later version.  See COPYING for more details.
 */

#ifndef FPGAUTILS_H
#define FPGAUTILS_H

#ifndef PATH_MAX
	#define PATH_MAX 4095
#endif

extern int serial_open(const char *devpath, unsigned long baud, signed short timeout, bool purge);
extern FILE *open_bitstream(const char *filename);

#endif
