;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 4.0.0 #11528 (MINGW64)
;--------------------------------------------------------
	.module PSGLib
	.optsdcc -mz80
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _PSGSFXSubstringRetAddr
	.globl _PSGSFXSubstringLen
	.globl _PSGSFXLoopFlag
	.globl _PSGSFXSkipFrames
	.globl _PSGSFXLoopPoint
	.globl _PSGSFXPointer
	.globl _PSGSFXStart
	.globl _PSGSFXStatus
	.globl _PSGSFXChan3Volume
	.globl _PSGSFXChan2Volume
	.globl _PSGChannel3SFX
	.globl _PSGChannel2SFX
	.globl _PSGChan3LowTone
	.globl _PSGChan2HighTone
	.globl _PSGChan2LowTone
	.globl _PSGChan3Volume
	.globl _PSGChan2Volume
	.globl _PSGChan1Volume
	.globl _PSGChan0Volume
	.globl _PSGMusicSubstringRetAddr
	.globl _PSGMusicSubstringLen
	.globl _PSGMusicVolumeAttenuation
	.globl _PSGMusicLastLatch
	.globl _PSGLoopFlag
	.globl _PSGMusicSkipFrames
	.globl _PSGMusicLoopPoint
	.globl _PSGMusicPointer
	.globl _PSGMusicStart
	.globl _PSGMusicStatus
	.globl _PSGStop
	.globl _PSGResume
	.globl _PSGPlay
	.globl _PSGCancelLoop
	.globl _PSGPlayNoRepeat
	.globl _PSGGetStatus
	.globl _PSGSilenceChannels
	.globl _PSGRestoreVolumes
	.globl _PSGSetMusicVolumeAttenuation
	.globl _PSGSFXStop
	.globl _PSGSFXPlay
	.globl _PSGSFXCancelLoop
	.globl _PSGSFXGetStatus
	.globl _PSGSFXPlayLoop
	.globl _PSGFrame
	.globl _PSGSFXFrame
;--------------------------------------------------------
; special function registers
;--------------------------------------------------------
_PSGPort	=	0x007f
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area _DATA
_PSGMusicStatus::
	.ds 1
_PSGMusicStart::
	.ds 2
_PSGMusicPointer::
	.ds 2
_PSGMusicLoopPoint::
	.ds 2
_PSGMusicSkipFrames::
	.ds 1
_PSGLoopFlag::
	.ds 1
_PSGMusicLastLatch::
	.ds 1
_PSGMusicVolumeAttenuation::
	.ds 1
_PSGMusicSubstringLen::
	.ds 1
_PSGMusicSubstringRetAddr::
	.ds 2
_PSGChan0Volume::
	.ds 1
_PSGChan1Volume::
	.ds 1
_PSGChan2Volume::
	.ds 1
_PSGChan3Volume::
	.ds 1
_PSGChan2LowTone::
	.ds 1
_PSGChan2HighTone::
	.ds 1
_PSGChan3LowTone::
	.ds 1
_PSGChannel2SFX::
	.ds 1
_PSGChannel3SFX::
	.ds 1
_PSGSFXChan2Volume::
	.ds 1
_PSGSFXChan3Volume::
	.ds 1
_PSGSFXStatus::
	.ds 1
_PSGSFXStart::
	.ds 2
_PSGSFXPointer::
	.ds 2
_PSGSFXLoopPoint::
	.ds 2
_PSGSFXSkipFrames::
	.ds 1
_PSGSFXLoopFlag::
	.ds 1
_PSGSFXSubstringLen::
	.ds 1
_PSGSFXSubstringRetAddr::
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
;--------------------------------------------------------
; Home
;--------------------------------------------------------
	.area _HOME
	.area _HOME
;--------------------------------------------------------
; code
;--------------------------------------------------------
	.area _CODE
;PSGLib.c:70: void PSGStop (void) {
;	---------------------------------
; Function PSGStop
; ---------------------------------
_PSGStop::
;PSGLib.c:74: if (PSGMusicStatus) {
	ld	a,(#_PSGMusicStatus + 0)
	or	a, a
	ret	Z
;PSGLib.c:75: PSGPort=PSGLatch|PSGChannel0|PSGVolumeData|0x0F;   // latch channel 0, volume=0xF (silent)
	ld	a, #0x9f
	out	(_PSGPort), a
;PSGLib.c:76: PSGPort=PSGLatch|PSGChannel1|PSGVolumeData|0x0F;   // latch channel 1, volume=0xF (silent)
	ld	a, #0xbf
	out	(_PSGPort), a
;PSGLib.c:77: if (!PSGChannel2SFX)
	ld	a,(#_PSGChannel2SFX + 0)
	or	a, a
	jr	NZ,00102$
;PSGLib.c:78: PSGPort=PSGLatch|PSGChannel2|PSGVolumeData|0x0F;   // latch channel 2, volume=0xF (silent)
	ld	a, #0xdf
	out	(_PSGPort), a
00102$:
;PSGLib.c:79: if (!PSGChannel3SFX)
	ld	a,(#_PSGChannel3SFX + 0)
	or	a, a
	jr	NZ,00104$
;PSGLib.c:80: PSGPort=PSGLatch|PSGChannel3|PSGVolumeData|0x0F;   // latch channel 3, volume=0xF (silent)
	ld	a, #0xff
	out	(_PSGPort), a
00104$:
;PSGLib.c:81: PSGMusicStatus=PSG_STOPPED;
	ld	hl,#_PSGMusicStatus + 0
	ld	(hl), #0x00
;PSGLib.c:83: }
	ret
;PSGLib.c:85: void PSGResume (void) {
;	---------------------------------
; Function PSGResume
; ---------------------------------
_PSGResume::
;PSGLib.c:89: if (!PSGMusicStatus) {
	ld	a,(#_PSGMusicStatus + 0)
	or	a, a
	ret	NZ
;PSGLib.c:90: PSGPort=PSGLatch|PSGChannel0|PSGVolumeData|PSGChan0Volume;   // restore channel 0 volume
	ld	a,(#_PSGChan0Volume + 0)
	or	a, #0x90
	out	(_PSGPort), a
;PSGLib.c:91: PSGPort=PSGLatch|PSGChannel1|PSGVolumeData|PSGChan1Volume;   // restore channel 1 volume
	ld	a,(#_PSGChan1Volume + 0)
	or	a, #0xb0
	out	(_PSGPort), a
;PSGLib.c:92: if (!PSGChannel2SFX) {
	ld	a,(#_PSGChannel2SFX + 0)
	or	a, a
	jr	NZ,00102$
;PSGLib.c:93: PSGPort=PSGLatch|PSGChannel2|(PSGChan2LowTone&0x0F);       // restore channel 2 frequency
	ld	a,(#_PSGChan2LowTone + 0)
	and	a, #0x0f
	or	a, #0xc0
	out	(_PSGPort), a
;PSGLib.c:94: PSGPort=PSGChan2HighTone&0x3F;
	ld	a,(#_PSGChan2HighTone + 0)
	and	a, #0x3f
	out	(_PSGPort), a
;PSGLib.c:95: PSGPort=PSGLatch|PSGChannel2|PSGVolumeData|PSGChan2Volume; // restore channel 2 volume
	ld	a,(#_PSGChan2Volume + 0)
	or	a, #0xd0
	out	(_PSGPort), a
00102$:
;PSGLib.c:97: if (!PSGChannel3SFX) {
	ld	a,(#_PSGChannel3SFX + 0)
	or	a, a
	jr	NZ,00104$
;PSGLib.c:98: PSGPort=PSGLatch|PSGChannel3|(PSGChan3LowTone&0x0F);       // restore channel 3 frequency
	ld	a,(#_PSGChan3LowTone + 0)
	and	a, #0x0f
	or	a, #0xe0
	out	(_PSGPort), a
;PSGLib.c:99: PSGPort=PSGLatch|PSGChannel3|PSGVolumeData|PSGChan3Volume; // restore channel 3 volume
	ld	a,(#_PSGChan3Volume + 0)
	or	a, #0xf0
	out	(_PSGPort), a
00104$:
;PSGLib.c:101: PSGMusicStatus=PSG_PLAYING;
	ld	hl,#_PSGMusicStatus + 0
	ld	(hl), #0x01
;PSGLib.c:103: }
	ret
;PSGLib.c:105: void PSGPlay (void *song) {
;	---------------------------------
; Function PSGPlay
; ---------------------------------
_PSGPlay::
;PSGLib.c:109: PSGStop();
	call	_PSGStop
;PSGLib.c:110: PSGLoopFlag=1;
	ld	hl,#_PSGLoopFlag + 0
	ld	(hl), #0x01
;PSGLib.c:111: PSGMusicStart=song;           // store the begin point of music
	pop	de
	pop	bc
	push	bc
	push	de
	ld	(_PSGMusicStart), bc
;PSGLib.c:112: PSGMusicPointer=song;         // set music pointer to begin of music
	ld	(_PSGMusicPointer), bc
;PSGLib.c:113: PSGMusicLoopPoint=song;       // looppointer points to begin too
	ld	(_PSGMusicLoopPoint), bc
;PSGLib.c:115: PSGMusicSkipFrames=0;         // reset the skip frames
	ld	hl,#_PSGMusicSkipFrames + 0
	ld	(hl), #0x00
;PSGLib.c:116: PSGMusicSubstringLen=0;       // reset the substring len (for compression)
	ld	hl,#_PSGMusicSubstringLen + 0
	ld	(hl), #0x00
;PSGLib.c:117: PSGMusicLastLatch=PSGLatch|PSGChannel0|PSGVolumeData|0x0F;   // latch channel 0, volume=0xF (silent)
	ld	hl,#_PSGMusicLastLatch + 0
	ld	(hl), #0x9f
;PSGLib.c:118: PSGMusicStatus=PSG_PLAYING;
	ld	hl,#_PSGMusicStatus + 0
	ld	(hl), #0x01
;PSGLib.c:119: }
	ret
;PSGLib.c:121: void PSGCancelLoop (void) {
;	---------------------------------
; Function PSGCancelLoop
; ---------------------------------
_PSGCancelLoop::
;PSGLib.c:125: PSGLoopFlag=0;
	ld	hl,#_PSGLoopFlag + 0
	ld	(hl), #0x00
;PSGLib.c:126: }
	ret
;PSGLib.c:128: void PSGPlayNoRepeat (void *song) {
;	---------------------------------
; Function PSGPlayNoRepeat
; ---------------------------------
_PSGPlayNoRepeat::
;PSGLib.c:132: PSGPlay(song);
	pop	bc
	pop	hl
	push	hl
	push	bc
	push	hl
	call	_PSGPlay
	pop	af
;PSGLib.c:133: PSGLoopFlag=0;
	ld	hl,#_PSGLoopFlag + 0
	ld	(hl), #0x00
;PSGLib.c:134: }
	ret
;PSGLib.c:136: unsigned char PSGGetStatus (void) {
;	---------------------------------
; Function PSGGetStatus
; ---------------------------------
_PSGGetStatus::
;PSGLib.c:140: return(PSGMusicStatus);
	ld	iy, #_PSGMusicStatus
	ld	l, 0 (iy)
;PSGLib.c:141: }
	ret
;PSGLib.c:143: void PSGSilenceChannels (void) {
;	---------------------------------
; Function PSGSilenceChannels
; ---------------------------------
_PSGSilenceChannels::
;PSGLib.c:147: PSGPort=PSGLatch|PSGChannel0|PSGVolumeData|0x0F;
	ld	a, #0x9f
	out	(_PSGPort), a
;PSGLib.c:148: PSGPort=PSGLatch|PSGChannel1|PSGVolumeData|0x0F;
	ld	a, #0xbf
	out	(_PSGPort), a
;PSGLib.c:149: PSGPort=PSGLatch|PSGChannel2|PSGVolumeData|0x0F;
	ld	a, #0xdf
	out	(_PSGPort), a
;PSGLib.c:150: PSGPort=PSGLatch|PSGChannel3|PSGVolumeData|0x0F;
	ld	a, #0xff
	out	(_PSGPort), a
;PSGLib.c:151: }
	ret
;PSGLib.c:153: void PSGRestoreVolumes (void) {
;	---------------------------------
; Function PSGRestoreVolumes
; ---------------------------------
_PSGRestoreVolumes::
	push	ix
	ld	ix,#0
	add	ix,sp
	push	af
;PSGLib.c:158: PSGPort=PSGLatch|PSGChannel0|PSGVolumeData|(((PSGChan0Volume&0x0F)+PSGMusicVolumeAttenuation>15)?15:(PSGChan0Volume&0x0F)+PSGMusicVolumeAttenuation);
	ld	iy, #_PSGMusicVolumeAttenuation
	ld	a, 0 (iy)
	ld	-2 (ix), a
	xor	a, a
	ld	-1 (ix), a
	ld	c, 0 (iy)
;PSGLib.c:157: if (PSGMusicStatus) {
	ld	a,(#_PSGMusicStatus + 0)
	or	a, a
	jr	Z,00102$
;PSGLib.c:158: PSGPort=PSGLatch|PSGChannel0|PSGVolumeData|(((PSGChan0Volume&0x0F)+PSGMusicVolumeAttenuation>15)?15:(PSGChan0Volume&0x0F)+PSGMusicVolumeAttenuation);
	ld	a,(#_PSGChan0Volume + 0)
	and	a, #0x0f
	ld	e, a
	ld	d, #0x00
	pop	hl
	push	hl
	add	hl, de
	ld	a, #0x0f
	cp	a, l
	ld	a, #0x00
	sbc	a, h
	jp	PO, 00168$
	xor	a, #0x80
00168$:
	jp	P, 00115$
	ld	de, #0x000f
	jr	00116$
00115$:
	ld	a,(#_PSGChan0Volume + 0)
	and	a, #0x0f
	add	a, c
	ld	e, a
	rla
	sbc	a, a
00116$:
	ld	a, e
	or	a, #0x90
	out	(_PSGPort), a
;PSGLib.c:159: PSGPort=PSGLatch|PSGChannel1|PSGVolumeData|(((PSGChan1Volume&0x0F)+PSGMusicVolumeAttenuation>15)?15:(PSGChan1Volume&0x0F)+PSGMusicVolumeAttenuation);
	ld	a,(#_PSGChan1Volume + 0)
	and	a, #0x0f
	ld	e, a
	ld	d, #0x00
	pop	hl
	push	hl
	add	hl, de
	ld	a, #0x0f
	cp	a, l
	ld	a, #0x00
	sbc	a, h
	jp	PO, 00169$
	xor	a, #0x80
00169$:
	jp	P, 00117$
	ld	de, #0x000f
	jr	00118$
00117$:
	ld	a,(#_PSGChan1Volume + 0)
	and	a, #0x0f
	add	a, c
	ld	e, a
	rla
	sbc	a, a
00118$:
	ld	a, e
	or	a, #0xb0
	out	(_PSGPort), a
00102$:
;PSGLib.c:161: if (PSGChannel2SFX)
	ld	a,(#_PSGChannel2SFX + 0)
	or	a, a
	jr	Z,00106$
;PSGLib.c:162: PSGPort=PSGLatch|PSGChannel2|PSGVolumeData|PSGSFXChan2Volume;
	ld	a,(#_PSGSFXChan2Volume + 0)
	or	a, #0xd0
	out	(_PSGPort), a
	jr	00107$
00106$:
;PSGLib.c:163: else if (PSGMusicStatus)
	ld	a,(#_PSGMusicStatus + 0)
	or	a, a
	jr	Z,00107$
;PSGLib.c:164: PSGPort=PSGLatch|PSGChannel2|PSGVolumeData|(((PSGChan2Volume&0x0F)+PSGMusicVolumeAttenuation>15)?15:(PSGChan2Volume&0x0F)+PSGMusicVolumeAttenuation);
	ld	a,(#_PSGChan2Volume + 0)
	and	a, #0x0f
	ld	e, a
	ld	d, #0x00
	pop	hl
	push	hl
	add	hl, de
	ld	a, #0x0f
	cp	a, l
	ld	a, #0x00
	sbc	a, h
	jp	PO, 00170$
	xor	a, #0x80
00170$:
	jp	P, 00119$
	ld	de, #0x000f
	jr	00120$
00119$:
	ld	a,(#_PSGChan2Volume + 0)
	and	a, #0x0f
	add	a, c
	ld	e, a
	rla
	sbc	a, a
00120$:
	ld	a, e
	or	a, #0xd0
	out	(_PSGPort), a
00107$:
;PSGLib.c:165: if (PSGChannel3SFX)
	ld	a,(#_PSGChannel3SFX + 0)
	or	a, a
	jr	Z,00111$
;PSGLib.c:166: PSGPort=PSGLatch|PSGChannel3|PSGVolumeData|PSGSFXChan3Volume;
	ld	a,(#_PSGSFXChan3Volume + 0)
	or	a, #0xf0
	out	(_PSGPort), a
	jr	00113$
00111$:
;PSGLib.c:167: else if (PSGMusicStatus)
	ld	a,(#_PSGMusicStatus + 0)
	or	a, a
	jr	Z,00113$
;PSGLib.c:168: PSGPort=PSGLatch|PSGChannel3|PSGVolumeData|(((PSGChan3Volume&0x0F)+PSGMusicVolumeAttenuation>15)?15:(PSGChan3Volume&0x0F)+PSGMusicVolumeAttenuation);
	ld	a,(#_PSGChan3Volume + 0)
	and	a, #0x0f
	ld	l, a
	ld	h, #0x00
	pop	de
	push	de
	add	hl, de
	ld	a, #0x0f
	cp	a, l
	ld	a, #0x00
	sbc	a, h
	jp	PO, 00171$
	xor	a, #0x80
00171$:
	jp	P, 00121$
	ld	bc, #0x000f
	jr	00122$
00121$:
	ld	a,(#_PSGChan3Volume + 0)
	and	a, #0x0f
	add	a, c
	ld	c, a
	rla
	sbc	a, a
00122$:
	ld	a, c
	or	a, #0xf0
	out	(_PSGPort), a
00113$:
;PSGLib.c:169: }
	ld	sp, ix
	pop	ix
	ret
;PSGLib.c:171: void PSGSetMusicVolumeAttenuation (unsigned char attenuation) {
;	---------------------------------
; Function PSGSetMusicVolumeAttenuation
; ---------------------------------
_PSGSetMusicVolumeAttenuation::
	push	ix
	ld	ix,#0
	add	ix,sp
	push	af
;PSGLib.c:175: PSGMusicVolumeAttenuation=attenuation;
	ld	a, 4 (ix)
	ld	(#_PSGMusicVolumeAttenuation + 0),a
;PSGLib.c:176: if (PSGMusicStatus) {
	ld	a,(#_PSGMusicStatus + 0)
	or	a, a
	jp	Z, 00107$
;PSGLib.c:177: PSGPort=PSGLatch|PSGChannel0|PSGVolumeData|(((PSGChan0Volume&0x0F)+PSGMusicVolumeAttenuation>15)?15:(PSGChan0Volume&0x0F)+PSGMusicVolumeAttenuation);
	ld	a,(#_PSGChan0Volume + 0)
	and	a, #0x0f
	ld	c, a
	ld	e, #0x00
	ld	iy, #_PSGMusicVolumeAttenuation
	ld	a, 0 (iy)
	ld	-2 (ix), a
	xor	a, a
	ld	-1 (ix), a
	ld	a, c
	add	a, -2 (ix)
	ld	b, a
	ld	a, e
	adc	a, -1 (ix)
	ld	e, a
	ld	c, 0 (iy)
	ld	a, #0x0f
	cp	a, b
	ld	a, #0x00
	sbc	a, e
	jp	PO, 00152$
	xor	a, #0x80
00152$:
	jp	P, 00109$
	ld	de, #0x000f
	jr	00110$
00109$:
	ld	a,(#_PSGChan0Volume + 0)
	and	a, #0x0f
	add	a, c
	ld	e, a
	rla
	sbc	a, a
00110$:
	ld	a, e
	or	a, #0x90
	out	(_PSGPort), a
;PSGLib.c:178: PSGPort=PSGLatch|PSGChannel1|PSGVolumeData|(((PSGChan1Volume&0x0F)+PSGMusicVolumeAttenuation>15)?15:(PSGChan1Volume&0x0F)+PSGMusicVolumeAttenuation);
	ld	a,(#_PSGChan1Volume + 0)
	and	a, #0x0f
	ld	e, a
	ld	d, #0x00
	pop	hl
	push	hl
	add	hl, de
	ld	a, #0x0f
	cp	a, l
	ld	a, #0x00
	sbc	a, h
	jp	PO, 00153$
	xor	a, #0x80
00153$:
	jp	P, 00111$
	ld	de, #0x000f
	jr	00112$
00111$:
	ld	a,(#_PSGChan1Volume + 0)
	and	a, #0x0f
	add	a, c
	ld	e, a
	rla
	sbc	a, a
00112$:
	ld	a, e
	or	a, #0xb0
	out	(_PSGPort), a
;PSGLib.c:179: if (!PSGChannel2SFX)
	ld	a,(#_PSGChannel2SFX + 0)
	or	a, a
	jr	NZ,00102$
;PSGLib.c:180: PSGPort=PSGLatch|PSGChannel2|PSGVolumeData|(((PSGChan2Volume&0x0F)+PSGMusicVolumeAttenuation>15)?15:(PSGChan2Volume&0x0F)+PSGMusicVolumeAttenuation);
	ld	a,(#_PSGChan2Volume + 0)
	and	a, #0x0f
	ld	l, a
	ld	h, #0x00
	pop	de
	push	de
	add	hl, de
	ld	a, #0x0f
	cp	a, l
	ld	a, #0x00
	sbc	a, h
	jp	PO, 00154$
	xor	a, #0x80
00154$:
	jp	P, 00113$
	ld	de, #0x000f
	jr	00114$
00113$:
	ld	a,(#_PSGChan2Volume + 0)
	and	a, #0x0f
	add	a, c
	ld	e, a
	rla
	sbc	a, a
00114$:
	ld	a, e
	or	a, #0xd0
	out	(_PSGPort), a
00102$:
;PSGLib.c:181: if (!PSGChannel3SFX)
	ld	a,(#_PSGChannel3SFX + 0)
	or	a, a
	jr	NZ,00107$
;PSGLib.c:182: PSGPort=PSGLatch|PSGChannel3|PSGVolumeData|(((PSGChan3Volume&0x0F)+PSGMusicVolumeAttenuation>15)?15:(PSGChan3Volume&0x0F)+PSGMusicVolumeAttenuation);
	ld	a,(#_PSGChan3Volume + 0)
	and	a, #0x0f
	ld	l, a
	ld	h, #0x00
	pop	de
	push	de
	add	hl, de
	ld	a, #0x0f
	cp	a, l
	ld	a, #0x00
	sbc	a, h
	jp	PO, 00155$
	xor	a, #0x80
00155$:
	jp	P, 00115$
	ld	bc, #0x000f
	jr	00116$
00115$:
	ld	a,(#_PSGChan3Volume + 0)
	and	a, #0x0f
	add	a, c
	ld	c, a
	rla
	sbc	a, a
00116$:
	ld	a, c
	or	a, #0xf0
	out	(_PSGPort), a
00107$:
;PSGLib.c:184: }
	ld	sp, ix
	pop	ix
	ret
;PSGLib.c:186: void PSGSFXStop (void) {
;	---------------------------------
; Function PSGSFXStop
; ---------------------------------
_PSGSFXStop::
	push	ix
	ld	ix,#0
	add	ix,sp
	push	af
;PSGLib.c:190: if (PSGSFXStatus) {
	ld	a,(#_PSGSFXStatus + 0)
	or	a, a
	jp	Z, 00113$
;PSGLib.c:195: PSGPort=PSGLatch|PSGChannel2|PSGVolumeData|(((PSGChan2Volume&0x0F)+PSGMusicVolumeAttenuation>15)?15:(PSGChan2Volume&0x0F)+PSGMusicVolumeAttenuation);
	ld	iy, #_PSGMusicVolumeAttenuation
	ld	a, 0 (iy)
	ld	-2 (ix), a
	xor	a, a
	ld	-1 (ix), a
	ld	c, 0 (iy)
;PSGLib.c:191: if (PSGChannel2SFX) {
	ld	a,(#_PSGChannel2SFX + 0)
	or	a, a
	jr	Z,00105$
;PSGLib.c:192: if (PSGMusicStatus) {
	ld	a,(#_PSGMusicStatus + 0)
	or	a, a
	jr	Z,00102$
;PSGLib.c:193: PSGPort=PSGLatch|PSGChannel2|(PSGChan2LowTone&0x0F);
	ld	a,(#_PSGChan2LowTone + 0)
	and	a, #0x0f
	or	a, #0xc0
	out	(_PSGPort), a
;PSGLib.c:194: PSGPort=PSGChan2HighTone&0x3F;
	ld	a,(#_PSGChan2HighTone + 0)
	and	a, #0x3f
	out	(_PSGPort), a
;PSGLib.c:195: PSGPort=PSGLatch|PSGChannel2|PSGVolumeData|(((PSGChan2Volume&0x0F)+PSGMusicVolumeAttenuation>15)?15:(PSGChan2Volume&0x0F)+PSGMusicVolumeAttenuation);
	ld	a,(#_PSGChan2Volume + 0)
	and	a, #0x0f
	ld	e, a
	ld	d, #0x00
	pop	hl
	push	hl
	add	hl, de
	ld	a, #0x0f
	cp	a, l
	ld	a, #0x00
	sbc	a, h
	jp	PO, 00154$
	xor	a, #0x80
00154$:
	jp	P, 00115$
	ld	de, #0x000f
	jr	00116$
00115$:
	ld	a,(#_PSGChan2Volume + 0)
	and	a, #0x0f
	add	a, c
	ld	e, a
	rla
	sbc	a, a
00116$:
	ld	a, e
	or	a, #0xd0
	out	(_PSGPort), a
	jr	00103$
00102$:
;PSGLib.c:197: PSGPort=PSGLatch|PSGChannel2|PSGVolumeData|0x0F;
	ld	a, #0xdf
	out	(_PSGPort), a
00103$:
;PSGLib.c:199: PSGChannel2SFX=PSG_STOPPED;
	ld	hl,#_PSGChannel2SFX + 0
	ld	(hl), #0x00
00105$:
;PSGLib.c:202: if (PSGChannel3SFX) {
	ld	a,(#_PSGChannel3SFX + 0)
	or	a, a
	jr	Z,00110$
;PSGLib.c:203: if (PSGMusicStatus) {
	ld	a,(#_PSGMusicStatus + 0)
	or	a, a
	jr	Z,00107$
;PSGLib.c:204: PSGPort=PSGLatch|PSGChannel3|(PSGChan3LowTone&0x0F);
	ld	a,(#_PSGChan3LowTone + 0)
	and	a, #0x0f
	or	a, #0xe0
	out	(_PSGPort), a
;PSGLib.c:205: PSGPort=PSGLatch|PSGChannel3|PSGVolumeData|(((PSGChan3Volume&0x0F)+PSGMusicVolumeAttenuation>15)?15:(PSGChan3Volume&0x0F)+PSGMusicVolumeAttenuation);
	ld	a,(#_PSGChan3Volume + 0)
	and	a, #0x0f
	ld	l, a
	ld	h, #0x00
	pop	de
	push	de
	add	hl, de
	ld	a, #0x0f
	cp	a, l
	ld	a, #0x00
	sbc	a, h
	jp	PO, 00155$
	xor	a, #0x80
00155$:
	jp	P, 00117$
	ld	bc, #0x000f
	jr	00118$
00117$:
	ld	a,(#_PSGChan3Volume + 0)
	and	a, #0x0f
	add	a, c
	ld	c, a
	rla
	sbc	a, a
00118$:
	ld	a, c
	or	a, #0xf0
	out	(_PSGPort), a
	jr	00108$
00107$:
;PSGLib.c:207: PSGPort=PSGLatch|PSGChannel3|PSGVolumeData|0x0F;
	ld	a, #0xff
	out	(_PSGPort), a
00108$:
;PSGLib.c:209: PSGChannel3SFX=PSG_STOPPED;
	ld	hl,#_PSGChannel3SFX + 0
	ld	(hl), #0x00
00110$:
;PSGLib.c:211: PSGSFXStatus=PSG_STOPPED;
	ld	hl,#_PSGSFXStatus + 0
	ld	(hl), #0x00
00113$:
;PSGLib.c:213: }
	ld	sp, ix
	pop	ix
	ret
;PSGLib.c:215: void PSGSFXPlay (void *sfx, unsigned char channels) {
;	---------------------------------
; Function PSGSFXPlay
; ---------------------------------
_PSGSFXPlay::
;PSGLib.c:220: PSGSFXStop();
	call	_PSGSFXStop
;PSGLib.c:221: PSGSFXLoopFlag=0;
	ld	hl,#_PSGSFXLoopFlag + 0
	ld	(hl), #0x00
;PSGLib.c:222: PSGSFXStart=sfx;              // store begin of SFX
	pop	de
	pop	bc
	push	bc
	push	de
	ld	(_PSGSFXStart), bc
;PSGLib.c:223: PSGSFXPointer=sfx;            // set the pointer to begin of SFX
	ld	(_PSGSFXPointer), bc
;PSGLib.c:224: PSGSFXLoopPoint=sfx;          // looppointer points to begin too
	ld	(_PSGSFXLoopPoint), bc
;PSGLib.c:225: PSGSFXSkipFrames=0;           // reset the skip frames
	ld	hl,#_PSGSFXSkipFrames + 0
	ld	(hl), #0x00
;PSGLib.c:226: PSGSFXSubstringLen=0;         // reset the substring len
	ld	hl,#_PSGSFXSubstringLen + 0
	ld	(hl), #0x00
;PSGLib.c:227: PSGChannel2SFX=(channels&SFX_CHANNEL2)?PSG_PLAYING:PSG_STOPPED;
	ld	hl, #4+0
	add	hl, sp
	ld	c, (hl)
	bit	0, c
	jr	Z,00103$
	ld	de, #0x0001
	jr	00104$
00103$:
	ld	de, #0x0000
00104$:
	ld	hl,#_PSGChannel2SFX + 0
	ld	(hl), e
;PSGLib.c:228: PSGChannel3SFX=(channels&SFX_CHANNEL3)?PSG_PLAYING:PSG_STOPPED;
	bit	1, c
	jr	Z,00105$
	ld	bc, #0x0001
	jr	00106$
00105$:
	ld	bc, #0x0000
00106$:
	ld	hl,#_PSGChannel3SFX + 0
	ld	(hl), c
;PSGLib.c:229: PSGSFXStatus=PSG_PLAYING;
	ld	hl,#_PSGSFXStatus + 0
	ld	(hl), #0x01
;PSGLib.c:230: }
	ret
;PSGLib.c:232: void PSGSFXCancelLoop (void) {
;	---------------------------------
; Function PSGSFXCancelLoop
; ---------------------------------
_PSGSFXCancelLoop::
;PSGLib.c:236: PSGSFXLoopFlag=0;
	ld	hl,#_PSGSFXLoopFlag + 0
	ld	(hl), #0x00
;PSGLib.c:237: }
	ret
;PSGLib.c:239: unsigned char PSGSFXGetStatus (void) {
;	---------------------------------
; Function PSGSFXGetStatus
; ---------------------------------
_PSGSFXGetStatus::
;PSGLib.c:243: return(PSGSFXStatus);
	ld	iy, #_PSGSFXStatus
	ld	l, 0 (iy)
;PSGLib.c:244: }
	ret
;PSGLib.c:246: void PSGSFXPlayLoop (void *sfx, unsigned char channels) {
;	---------------------------------
; Function PSGSFXPlayLoop
; ---------------------------------
_PSGSFXPlayLoop::
;PSGLib.c:251: PSGSFXPlay(sfx, channels);
	ld	iy, #4
	add	iy, sp
	ld	a, 0 (iy)
	push	af
	inc	sp
	dec	iy
	dec	iy
	ld	l, 0 (iy)
	ld	h, 1 (iy)
	push	hl
	call	_PSGSFXPlay
	pop	af
	inc	sp
;PSGLib.c:252: PSGSFXLoopFlag=1;
	ld	hl,#_PSGSFXLoopFlag + 0
	ld	(hl), #0x01
;PSGLib.c:253: }
	ret
;PSGLib.c:255: void PSGFrame (void) {
;	---------------------------------
; Function PSGFrame
; ---------------------------------
_PSGFrame::
;PSGLib.c:450: __endasm;
	ld	a,(_PSGMusicStatus) ; check if we have got to play a tune
	or	a
	ret	z
	ld	a,(_PSGMusicSkipFrames) ; check if we have got to skip frames
	or	a
	jp	nz,_skipFrame
	ld	hl,(_PSGMusicPointer) ; read current address
	_intLoop:
	ld	b,(hl) ; load PSG byte (in B)
	inc	hl ; point to next byte
	ld	a,(_PSGMusicSubstringLen) ; read substring len
	or	a
	jr	z,_continue ; check if it is 0 (we are not in a substring)
	dec	a ; decrease len
	ld	(_PSGMusicSubstringLen),a ; save len
	jr	nz,_continue
	ld	hl,(_PSGMusicSubstringRetAddr) ; substring is over, retrieve return address
	_continue:
	ld	a,b ; copy PSG byte into A
	cp	#0x80 ; is it a latch?
	jr	c,_noLatch ; if < $80 then it is NOT a latch
	ld	(_PSGMusicLastLatch),a ; it is a latch - save it in "LastLatch"
;	we have got the latch PSG byte both in A and in B
;	and we have to check if the value should pass to PSG or not
	bit	4,a ; test if it is a volume
	jr	nz,_latch_Volume ; jump if volume data
	bit	6,a ; test if the latch it is for channels 0-1 or for 2-3
	jp	z,_send2PSG_A ; send data to PSG if it is for channels 0-1
;	we have got the latch (tone, chn 2 or 3) PSG byte both in A and in B
;	and we have to check if the value should be passed to PSG or not
	bit	5,a ; test if tone it is for channel 2 or 3
	jr	z,_ifchn2 ; jump if channel 2
	ld	(_PSGChan3LowTone),a ; save tone LOW data
	ld	a,(_PSGChannel3SFX) ; channel 3 free?
	or	a
	jp	nz,_intLoop
	ld	a,(_PSGChan3LowTone)
	and	#3 ; test if channel 3 is set to use the frequency of channel 2
	cp	#3
	jr	nz,_send2PSG_B ; if channel 3 does not use frequency of channel 2 jump
	ld	a,(_PSGSFXStatus) ; test if an SFX is playing
	or	a
	jr	z,_send2PSG_B ; if no SFX is playing jump
	ld	(_PSGChannel3SFX),a ; otherwise mark channel 3 as occupied
	ld	a,#0x80|#0b01100000|#0b00010000|#0x0F ; and silence channel 3
	out	(#0x7f),a
	jp	_intLoop
	_ifchn2:
	ld	(_PSGChan2LowTone),a ; save tone LOW data
	ld	a,(_PSGChannel2SFX) ; channel 2 free?
	or	a
	jr	z,_send2PSG_B
	jp	_intLoop
	_latch_Volume:
	bit	6,a ; test if the latch it is for channels 0-1 or for 2-3
	jr	nz,_latch_Volume_23 ; volume is for channel 2 or 3
	bit	5,a ; test if volume it is for channel 0 or 1
	jr	z,_chn0 ; jump for channel 0
	ld	(_PSGChan1Volume),a ; save volume data
	jp	_sendVolume2PSG_A
	_chn0:
	ld	(_PSGChan0Volume),a ; save volume data
	jp	_sendVolume2PSG_A
	_latch_Volume_23:
	bit	5,a ; test if volume it is for channel 2 or 3
	jr	z,_chn2 ; jump for channel 2
	ld	(_PSGChan3Volume),a ; save volume data
	ld	a,(_PSGChannel3SFX) ; channel 3 free?
	or	a
	jr	z,_sendVolume2PSG_B
	jp	_intLoop
	_chn2:
	ld	(_PSGChan2Volume),a ; save volume data
	ld	a,(_PSGChannel2SFX) ; channel 2 free?
	or	a
	jr	z,_sendVolume2PSG_B
	jp	_intLoop
	_skipFrame:
	dec	a
	ld	(_PSGMusicSkipFrames),a
	ret
	_noLatch:
	cp	#0x40
	jr	c,_command ; if < $40 then it is a command
;	it is a data
	ld	a,(_PSGMusicLastLatch) ; retrieve last latch
	jp	_output_NoLatch
	_command:
	cp	#0x38
	jr	z,_done ; no additional frames
	jr	c,_otherCommands ; other commands?
	and	#0x07 ; take only the last 3 bits for skip frames
	ld	(_PSGMusicSkipFrames),a ; we got additional frames
	_done:
	ld	(_PSGMusicPointer),hl ; save current address
	ret	; frame done
	_otherCommands:
	cp	#0x08
	jr	nc,_substring
	cp	#0x00
	jr	z,_musicLoop
	cp	#0x01
	jr	z,_setLoopPoint
;	***************************************************************************
;	we should never get here!
;	if we do, it means the PSG file is probably corrupted, so we just RET
;	***************************************************************************
	ret
	_send2PSG_B:
	ld	a,b
	_send2PSG_A:
	out	(#0x7f),a ; output the byte
	jp	_intLoop
	_sendVolume2PSG_B:
	ld	a,b
	_sendVolume2PSG_A:
	ld	c,a ; save the PSG command byte
	and	#0x0F ; keep lower nibble
	ld	b,a ; save value
	ld	a,(_PSGMusicVolumeAttenuation) ; load volume attenuation
	add	a,b ; add value
	cp	#0x0F ; check overflow
	jr	c,_no_overflow ; if it is <=15 then ok
	ld	a,#0x0F ; else, reset to 15
	_no_overflow:
	ld	b,a ; save new attenuated volume value
	ld	a,c ; retrieve PSG command
	and	#0xF0 ; keep upper nibble
	or	b ; set attenuated volume
	out	(#0x7f),a ; output the byte
	jp	_intLoop
	_output_NoLatch:
;	we got the last latch in A and the PSG data in B
;	and we have to check if the value should pass to PSG or not
;	note that non-latch commands can be only contain frequencies (no volumes)
;	for channels 0,1,2 only (no noise)
	bit	6,a ; test if the latch it is for channels 0-1 or for chn 2
	jr	nz,_high_part_Tone ; it is tone data for channel 2
	jp	_send2PSG_B ; otherwise, it is for chn 0 or 1 so we have done!
	_setLoopPoint:
	ld	(_PSGMusicLoopPoint),hl
	jp	_intLoop
	_musicLoop:
	ld	a,(_PSGLoopFlag) ; looping requested?
	or	a
	jp	z,_PSGStop ; No:stop it! (tail call optimization)
	ld	hl,(_PSGMusicLoopPoint)
	jp	_intLoop
	_substring:
	sub	#0x08 -4 ; len is value - $08 + 4
	ld	(_PSGMusicSubstringLen),a ; save len
	ld	c,(hl) ; load substring address (offset)
	inc	hl
	ld	b,(hl)
	inc	hl
	ld	(_PSGMusicSubstringRetAddr),hl ; save return address
	ld	hl,(_PSGMusicStart)
	add	hl,bc ; make substring current
	jp	_intLoop
	_high_part_Tone:
;	we got the last latch in A and the PSG data in B
;	and we have to check if the value should pass to PSG or not
;	PSG data can only be for channel 2, here
	ld	a,b ; move PSG data in A
	ld	(_PSGChan2HighTone),a ; save channel 2 tone HIGH data
	ld	a,(_PSGChannel2SFX) ; channel 2 free?
	or	a
	jr	z,_send2PSG_B
	jp	_intLoop
;PSGLib.c:451: }
	ret
;PSGLib.c:453: void PSGSFXFrame (void) {
;	---------------------------------
; Function PSGSFXFrame
; ---------------------------------
_PSGSFXFrame::
;PSGLib.c:550: __endasm;
	ld	a,(_PSGSFXStatus) ; check if we have got to play SFX
	or	a
	ret	z
	ld	a,(_PSGSFXSkipFrames) ; check if we have got to skip frames
	or	a
	jp	nz,_skipSFXFrame
	ld	hl,(_PSGSFXPointer) ; read current SFX address
	_intSFXLoop:
	ld	b,(hl) ; load a byte in B, temporary
	inc	hl ; point to next byte
	ld	a,(_PSGSFXSubstringLen) ; read substring len
	or	a ; check if it is 0 (we are not in a substring)
	jr	z,_SFXcontinue
	dec	a ; decrease len
	ld	(_PSGSFXSubstringLen),a ; save len
	jr	nz,_SFXcontinue
	ld	hl,(_PSGSFXSubstringRetAddr) ; substring over, retrieve return address
	_SFXcontinue:
	ld	a,b ; restore byte
	cp	#0x40
	jp	c,_SFXcommand ; if less than $40 then it is a command
	bit	4,a ; check if it is a volume byte
	jr	z,_SFXoutbyte ; if not, output it
	bit	5,a ; check if it is volume for channel 2 or channel 3
	jr	nz,_SFXvolumechn3
	ld	(_PSGSFXChan2Volume),a
	jr	_SFXoutbyte
	_SFXvolumechn3:
	ld	(_PSGSFXChan3Volume),a
	_SFXoutbyte:
	out	(#0x7f),a ; output the byte
	jp	_intSFXLoop
	_skipSFXFrame:
	dec	a
	ld	(_PSGSFXSkipFrames),a
	ret
	_SFXcommand:
	cp	#0x38
	jr	z,_SFXdone ; no additional frames
	jr	c,_SFXotherCommands ; other commands?
	and	#0x07 ; take only the last 3 bits for skip frames
	ld	(_PSGSFXSkipFrames),a ; we got additional frames to skip
	_SFXdone:
	ld	(_PSGSFXPointer),hl ; save current address
	ret	; frame done
	_SFXotherCommands:
	cp	#0x08
	jr	nc,_SFXsubstring
	cp	#0x00
	jr	z,_sfxLoop
	cp	#0x01
	jr	z,_SFXsetLoopPoint
;	***************************************************************************
;	we should never get here!
;	if we do, it means the PSG SFX file is probably corrupted, so we just RET
;	***************************************************************************
	ret
	_SFXsetLoopPoint:
	ld	(_PSGSFXLoopPoint),hl
	jp	_intSFXLoop
	_sfxLoop:
	ld	a,(_PSGSFXLoopFlag) ; is it a looping SFX?
	or	a
	jp	z,_PSGSFXStop ; No:stop it! (tail call optimization)
	ld	hl,(_PSGSFXLoopPoint)
	ld	(_PSGSFXPointer),hl
	jp	_intSFXLoop
	_SFXsubstring:
	sub	#0x08 -4 ; len is value - $08 + 4
	ld	(_PSGSFXSubstringLen),a ; save len
	ld	c,(hl) ; load substring address (offset)
	inc	hl
	ld	b,(hl)
	inc	hl
	ld	(_PSGSFXSubstringRetAddr),hl ; save return address
	ld	hl,(_PSGSFXStart)
	add	hl,bc ; make substring current
	jp	_intSFXLoop
;PSGLib.c:551: }
	ret
	.area _CODE
	.area _INITIALIZER
	.area _CABS (ABS)
