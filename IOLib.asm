;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 4.0.0 #11528 (MINGW64)
;--------------------------------------------------------
	.module IOLib
	.optsdcc -mz80
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _IOSize
	.globl _IOPointer
	.globl _IOStart
	.globl _IOStatus
	.globl _IOPlay
	.globl _IOStop
	.globl _IOFrame
;--------------------------------------------------------
; special function registers
;--------------------------------------------------------
_G2G_IOPinPort	=	0x0001
_G2G_NMIPort	=	0x0002
_G2G_TxPort	=	0x0003
_G2G_RxPort	=	0x0004
_G2G_StatusPort	=	0x0005
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area _DATA
_IOStatus::
	.ds 1
_IOStart::
	.ds 2
_IOPointer::
	.ds 2
_IOSize::
	.ds 2
_IOFrame_count_65536_12:
	.ds 2
_IOFrame_frame_65536_12:
	.ds 2
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area _INITIALIZED
;--------------------------------------------------------
; absolute external ram data
;--------------------------------------------------------
	.area _DABS (ABS)
;--------------------------------------------------------
; global & static initialisations
;--------------------------------------------------------
	.area _HOME
	.area _GSINIT
	.area _GSFINAL
	.area _GSINIT
;IOLib.c:47: static int count = 0;
	ld	hl, #0x0000
	ld	(_IOFrame_count_65536_12), hl
;IOLib.c:48: static int frame = 0;
	ld	l, #0x00
	ld	(_IOFrame_frame_65536_12), hl
;--------------------------------------------------------
; Home
;--------------------------------------------------------
	.area _HOME
	.area _HOME
;--------------------------------------------------------
; code
;--------------------------------------------------------
	.area _CODE
;IOLib.c:11: void IOPlay(unsigned char *IOData, unsigned int size)
;	---------------------------------
; Function IOPlay
; ---------------------------------
_IOPlay::
;IOLib.c:13: G2G_NMIPort = 0x80;
	ld	a, #0x80
	out	(_G2G_NMIPort), a
;IOLib.c:14: G2G_IOPinPort = 0x00;
	ld	a, #0x00
	out	(_G2G_IOPinPort), a
;IOLib.c:15: IOStart = IOData;
	pop	de
	pop	bc
	push	bc
	push	de
	ld	(_IOStart), bc
;IOLib.c:16: IOPointer = IOData;
	ld	(_IOPointer), bc
;IOLib.c:17: IOSize = size;
	ld	iy, #4
	add	iy, sp
	ld	a, 0 (iy)
	ld	(_IOSize+0), a
	ld	a, 1 (iy)
	ld	(_IOSize+1), a
;IOLib.c:18: IOStatus=IO_PLAYING;
	ld	hl,#_IOStatus + 0
	ld	(hl), #0x01
;IOLib.c:19: }
	ret
;IOLib.c:21: void IOStop(void)
;	---------------------------------
; Function IOStop
; ---------------------------------
_IOStop::
;IOLib.c:23: G2G_NMIPort = 0x80;
	ld	a, #0x80
	out	(_G2G_NMIPort), a
;IOLib.c:24: G2G_IOPinPort = 0x00;
	ld	a, #0x00
	out	(_G2G_IOPinPort), a
;IOLib.c:27: for(int i=7;i>=0;i--)
	ld	de, #0x0007
00103$:
	bit	7, d
	jr	NZ,00101$
;IOLib.c:30: G2G_IOPinPort = byte;
	ld	a, #0x00
	out	(_G2G_IOPinPort), a
;IOLib.c:32: G2G_IOPinPort = byte;
	ld	a, #0x01
	out	(_G2G_IOPinPort), a
;IOLib.c:33: byte &= 0xFE;
	ld	bc, #0x0000
;IOLib.c:34: G2G_IOPinPort = byte;
	ld	a, #0x00
	out	(_G2G_IOPinPort), a
;IOLib.c:27: for(int i=7;i>=0;i--)
	dec	de
	jr	00103$
00101$:
;IOLib.c:36: byte |= 1 << 1;
	set	1, c
;IOLib.c:37: G2G_IOPinPort = byte;
	ld	a, c
	out	(_G2G_IOPinPort), a
;IOLib.c:39: G2G_IOPinPort = byte;
	ld	a, #0x00
	out	(_G2G_IOPinPort), a
;IOLib.c:41: IOStatus = IO_STOPPED;
	ld	hl,#_IOStatus + 0
	ld	(hl), #0x00
;IOLib.c:42: }
	ret
;IOLib.c:45: void IOFrame(void)
;	---------------------------------
; Function IOFrame
; ---------------------------------
_IOFrame::
	push	ix
	ld	ix,#0
	add	ix,sp
	push	af
	push	af
;IOLib.c:50: if(IOStatus == IO_PLAYING)
	ld	a,(#_IOStatus + 0)
	dec	a
	jp	NZ,00114$
;IOLib.c:80: frame++;
	ld	bc, (_IOFrame_frame_65536_12)
	inc	bc
;IOLib.c:52: if(frame == 0)
	ld	iy, #_IOFrame_frame_65536_12
	ld	a, 1 (iy)
	or	a, 0 (iy)
	jp	NZ, 00107$
;IOLib.c:55: for(int i=7;i>=0;i--)
	ld	-2 (ix), #0x07
	xor	a, a
	ld	-1 (ix), a
00112$:
	bit	7, -1 (ix)
	jr	NZ,00101$
;IOLib.c:58: byte |= (((*IOPointer)>>i) & 1)<<2;
	ld	hl, (_IOPointer)
	ld	e, (hl)
	ld	a, -2 (ix)
	inc	a
	jr	00150$
00149$:
	srl	e
00150$:
	dec	a
	jr	NZ, 00149$
	ld	a, e
	and	a, #0x01
	ld	l, a
	ld	h, #0x00
	add	hl, hl
	add	hl, hl
	ex	de,hl
;IOLib.c:59: IOPointer++;
	ld	hl, (_IOPointer)
	inc	hl
	ld	(_IOPointer), hl
;IOLib.c:60: byte |= (((*IOPointer)>>i) & 1)<<3;
	ld	hl, (_IOPointer)
	ld	l, (hl)
	ld	a, -2 (ix)
	inc	a
	jr	00152$
00151$:
	srl	l
00152$:
	dec	a
	jr	NZ, 00151$
	ld	a, l
	and	a, #0x01
	ld	l, a
	ld	h, #0x00
	add	hl, hl
	add	hl, hl
	add	hl, hl
	ld	a, e
	or	a, l
	ld	e, a
	ld	a, d
	or	a, h
;IOLib.c:61: IOPointer--;
	ld	hl, (_IOPointer)
	dec	hl
	ld	(_IOPointer), hl
;IOLib.c:62: G2G_IOPinPort = byte;
	ld	a, e
	out	(_G2G_IOPinPort), a
;IOLib.c:63: byte |= 1;
	set	0, e
;IOLib.c:64: G2G_IOPinPort = byte;
	ld	a, e
	out	(_G2G_IOPinPort), a
;IOLib.c:65: byte &= 0xFE;
	ld	a, e
	and	a, #0xfe
	ld	-4 (ix), a
	ld	-3 (ix), #0x00
;IOLib.c:66: G2G_IOPinPort = byte;
	ld	a, -4 (ix)
	out	(_G2G_IOPinPort), a
;IOLib.c:55: for(int i=7;i>=0;i--)
	ld	l, -2 (ix)
	ld	h, -1 (ix)
	dec	hl
	ld	-2 (ix), l
	ld	-1 (ix), h
	jr	00112$
00101$:
;IOLib.c:68: byte |= 1 << 1;
	ld	e, -4 (ix)
	set	1, e
;IOLib.c:69: G2G_IOPinPort = byte;
	ld	a, e
	out	(_G2G_IOPinPort), a
;IOLib.c:71: G2G_IOPinPort = byte;
	ld	a, #0x00
	out	(_G2G_IOPinPort), a
;IOLib.c:73: IOPointer+=2;
	ld	hl, (_IOPointer)
	inc	hl
	inc	hl
	ld	(_IOPointer), hl
;IOLib.c:74: count+=2;
	ld	hl, (_IOFrame_count_65536_12)
	inc	hl
	inc	hl
	ld	(_IOFrame_count_65536_12), hl
;IOLib.c:75: if(count >= IOSize)
	ld	de, (_IOFrame_count_65536_12)
	ld	hl, #_IOSize
	ld	a, e
	sub	a, (hl)
	ld	a, d
	inc	hl
	sbc	a, (hl)
	jr	C,00103$
;IOLib.c:77: IOStatus = IO_STOPPED;
	ld	hl,#_IOStatus + 0
	ld	(hl), #0x00
;IOLib.c:78: count = 0;
	ld	hl, #0x0000
	ld	(_IOFrame_count_65536_12), hl
00103$:
;IOLib.c:80: frame++;
	ld	(_IOFrame_frame_65536_12), bc
	jr	00114$
00107$:
;IOLib.c:84: frame++;
	ld	(_IOFrame_frame_65536_12), bc
;IOLib.c:85: if(frame >= 3)
	ld	iy, #_IOFrame_frame_65536_12
	ld	a, 0 (iy)
	sub	a, #0x03
	ld	a, 1 (iy)
	rla
	ccf
	rra
	sbc	a, #0x80
	jr	C,00114$
;IOLib.c:86: frame = 0;
	ld	hl, #0x0000
	ld	(_IOFrame_frame_65536_12), hl
00114$:
;IOLib.c:89: }
	ld	sp, ix
	pop	ix
	ret
	.area _CODE
	.area _INITIALIZER
	.area _CABS (ABS)
