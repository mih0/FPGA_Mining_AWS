/*
 * Copyright 2013 Con Kolivas <kernel@kolivas.org>
 * Copyright 2012 Luke Dashjr
 * Copyright 2012 Andrew Smith
 *
 * This program is free software; you can redistribute it and/or modify it
 * under the terms of the GNU General Public License as published by the Free
 * Software Foundation; either version 3 of the License, or (at your option)
 * any later version.  See COPYING for more details.
 */

#include <string.h>
#include <stdio.h>

#ifndef WIN32
#include <errno.h>
#include <termios.h>
#include <unistd.h>
#include <fcntl.h>
#ifndef O_CLOEXEC
#define O_CLOEXEC 0
#endif
#endif

#include "miner.h"
#include "fpgautils.h"

int serial_open(const char *devpath, unsigned long baud, signed short timeout, bool purge)
{
#ifdef WIN32
	HANDLE hSerial = CreateFile(devpath, GENERIC_READ | GENERIC_WRITE, 0, NULL, OPEN_EXISTING, 0, NULL);
	if (unlikely(hSerial == INVALID_HANDLE_VALUE))
	{
		DWORD e = GetLastError();
		switch (e) {
		case ERROR_ACCESS_DENIED:
			applog(LOG_ERR, "Do not have user privileges required to open %s", devpath);
			break;
		case ERROR_SHARING_VIOLATION:
			applog(LOG_ERR, "%s is already in use by another process", devpath);
			break;
		default:
			applog(LOG_DEBUG, "Open %s failed, GetLastError:%d", devpath, (int)e);
			break;
		}
		return -1;
	}

	// thanks to af_newbie for pointers about this
	COMMCONFIG comCfg = {0};
	comCfg.dwSize = sizeof(COMMCONFIG);
	comCfg.wVersion = 1;
	comCfg.dcb.DCBlength = sizeof(DCB);
	comCfg.dcb.BaudRate = baud;
	comCfg.dcb.fBinary = 1;
	comCfg.dcb.fDtrControl = DTR_CONTROL_ENABLE;
	comCfg.dcb.fRtsControl = RTS_CONTROL_ENABLE;
	comCfg.dcb.ByteSize = 8;

	SetCommConfig(hSerial, &comCfg, sizeof(comCfg));

	// Code must specify a valid timeout value (0 means don't timeout)
	const DWORD ctoms = (timeout * 100);
	COMMTIMEOUTS cto = {ctoms, 0, ctoms, 0, ctoms};
	SetCommTimeouts(hSerial, &cto);

	if (purge) {
		PurgeComm(hSerial, PURGE_RXABORT);
		PurgeComm(hSerial, PURGE_TXABORT);
		PurgeComm(hSerial, PURGE_RXCLEAR);
		PurgeComm(hSerial, PURGE_TXCLEAR);
	}

	return _open_osfhandle((intptr_t)hSerial, 0);
#else
	int fdDev = open(devpath, O_RDWR | O_CLOEXEC | O_NOCTTY);

	if (unlikely(fdDev == -1))
	{
		if (errno == EACCES)
			applog(LOG_ERR, "Do not have user privileges required to open %s", devpath);
		else
			applog(LOG_DEBUG, "Open %s failed, errno:%d", devpath, errno);

		return -1;
	}

	struct termios my_termios;

	tcgetattr(fdDev, &my_termios);

	switch (baud) {
	case 0:
		break;
	case 19200:
		cfsetispeed(&my_termios, B19200);
		cfsetospeed(&my_termios, B19200);
		break;
	case 38400:
		cfsetispeed(&my_termios, B38400);
		cfsetospeed(&my_termios, B38400);
		break;
	case 57600:
		cfsetispeed(&my_termios, B57600);
		cfsetospeed(&my_termios, B57600);
		break;
	case 115200:
		cfsetispeed(&my_termios, B115200);
		cfsetospeed(&my_termios, B115200);
		break;
	default:
		applog(LOG_WARNING, "Unrecognized baud rate: %lu", baud);
	}

	my_termios.c_cflag &= ~(CSIZE | PARENB);
	my_termios.c_cflag |= CS8;
	my_termios.c_cflag |= CREAD;
	my_termios.c_cflag |= CLOCAL;

	my_termios.c_iflag &= ~(IGNBRK | BRKINT | PARMRK |
				ISTRIP | INLCR | IGNCR | ICRNL | IXON);
	my_termios.c_oflag &= ~OPOST;
	my_termios.c_lflag &= ~(ECHO | ECHONL | ICANON | ISIG | IEXTEN);

	// Code must specify a valid timeout value (0 means don't timeout)
	my_termios.c_cc[VTIME] = (cc_t)timeout;
	my_termios.c_cc[VMIN] = 0;

	tcsetattr(fdDev, TCSANOW, &my_termios);

	if (purge)
		tcflush(fdDev, TCIOFLUSH);
	return fdDev;
#endif
}

// ssize_t _serial_read(int fd, char *buf, size_t bufsiz, char *eol)
// {
	// ssize_t len, tlen = 0;
	// while (bufsiz) {
		// len = read(fd, buf, eol ? 1 : bufsiz);
		// if (unlikely(len == -1))
			// break;
		// tlen += len;
		// if (eol && *eol == buf[0])
			// break;
		// buf += len;
		// bufsiz -= len;
	// }
	// return tlen;
// }

FILE *open_bitstream(const char *filename)
{
	char fullpath[PATH_MAX];
	strcpy(fullpath, "./bitstreams/");
	strcat(fullpath, filename);
	
	return fopen(fullpath, "rb");
}
