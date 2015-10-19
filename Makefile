#
# v4l2n - Video4Linux2 API tool for developers.
#
# Copyright (c) 2015 Intel Corporation. All Rights Reserved.
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License version
# 2 as published by the Free Software Foundation.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#

OPT = -Wall -m32 -static -g -I.
PROGS = v4l2n v4l2n-example raw2pnm yuv2yuv pnm2yuv txt2raw pnm2txt

.PHONY: all clean
all: $(PROGS)

v4l2n: v4l2n.c v4l2n.h linux/videodev2.h linux/v4l2-subdev.h linux/v4l2-controls.h linux/v4l2-common.h linux/compiler.h linux/atomisp.h
	gcc -c $(OPT) $@.c -o lib$@.o
	gcc $(OPT) lib$@.o -o $@

v4l2n-example: v4l2n
	gcc $(OPT) $@.c -o $@ libv4l2n.o

raw2pnm: raw2pnm.c
	gcc $(OPT) $@.c -o $@

yuv2yuv: yuv2yuv.c
	gcc $(OPT) $@.c -o $@

pnm2yuv: pnm2yuv.c utillib.o
	gcc $(OPT) utillib.o $@.c -o $@

txt2raw: txt2raw.c utillib.o
	gcc $(OPT) utillib.o $@.c -o $@

pnm2txt: pnm2txt.c utillib.o
	gcc $(OPT) utillib.o $@.c -o $@

utillib.o: utillib.c
	gcc $(OPT) -c $< -o $@

clean:
	rm -f $(PROGS) utillib.o

.PHONY: release
release:
	$(MAKE) clean
	$(MAKE) all
	rm -rfv RELEASE
	mkdir -p RELEASE/v4l2n
	cp README $(PROGS) RELEASE/v4l2n
	cd RELEASE && zip -r -9 -m ../v4l2n-`date +%Y%m%d`.zip v4l2n
