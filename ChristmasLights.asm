;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 4.0.0 #11528 (MINGW64)
;--------------------------------------------------------
	.module ChristmasLights
	.optsdcc -mz80
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl ___SMS__SDSC_signature
	.globl ___SMS__SDSC_descr
	.globl ___SMS__SDSC_name
	.globl ___SMS__SDSC_author
	.globl ___SMS__SEGA_signature
	.globl _main
	.globl _putstring
	.globl _IOFrame
	.globl _IOStop
	.globl _IOPlay
	.globl _PSGFrame
	.globl _PSGGetStatus
	.globl _PSGStop
	.globl _PSGPlayNoRepeat
	.globl _SMS_VRAMmemcpy
	.globl _SMS_getKeysPressed
	.globl _GG_loadBGPalette
	.globl _SMS_loadTileMapArea
	.globl _SMS_crt0_RST18
	.globl _SMS_crt0_RST08
	.globl _SMS_waitForVBlank
	.globl _SMS_VDPturnOnFeature
	.globl _PlayListIndex
	.globl _PlayList
	.globl _framecount
	.globl _SMS_SRAM
	.globl _SRAM_bank_to_be_mapped_on_slot2
	.globl _ROM_bank_to_be_mapped_on_slot2
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
_ROM_bank_to_be_mapped_on_slot2	=	0xffff
_SRAM_bank_to_be_mapped_on_slot2	=	0xfffc
_SMS_SRAM	=	0x8000
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area _INITIALIZED
_framecount::
	.ds 2
_PlayList::
	.ds 27
_PlayListIndex::
	.ds 2
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
;ChristmasLights.c:10: void putstring(uint8_t x, uint8_t y, const char* string)
;	---------------------------------
; Function putstring
; ---------------------------------
_putstring::
	push	ix
	ld	ix,#0
	add	ix,sp
;ChristmasLights.c:12: SMS_setNextTileatXY(x, y);
	ld	l, 5 (ix)
	ld	h, #0x00
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	ld	c, 4 (ix)
	ld	b, #0x00
	add	hl, bc
	add	hl, hl
	ld	a, h
	or	a, #0x78
	ld	h, a
	call	_SMS_crt0_RST08
;ChristmasLights.c:13: while (*string)
	ld	c, 6 (ix)
	ld	b, 7 (ix)
00101$:
	ld	a, (bc)
	or	a, a
	jr	Z,00104$
;ChristmasLights.c:15: SMS_setTile(*string++ + STRING_OFFSET);
	inc	bc
	ld	e, a
	ld	d, #0x00
	ld	hl, #0xffe0
	add	hl, de
	call	_SMS_crt0_RST18
	jr	00101$
00104$:
;ChristmasLights.c:17: }
	pop	ix
	ret
;ChristmasLights.c:38: void main(void)
;	---------------------------------
; Function main
; ---------------------------------
_main::
	push	ix
	ld	ix,#0
	add	ix,sp
	ld	hl, #-169
	add	hl, sp
	ld	sp, hl
;ChristmasLights.c:42: bool songidle = 1;
	ld	-1 (ix), #0x01
;ChristmasLights.c:44: IOStop();
	call	_IOStop
;ChristmasLights.c:48: SMS_mapROMBank(2);
	ld	hl,#_ROM_bank_to_be_mapped_on_slot2 + 0
	ld	(hl), #0x02
;ChristmasLights.c:49: GG_loadBGPalette (Yule__palette__bin);
	ld	hl, #_Yule__palette__bin
	call	_GG_loadBGPalette
;ChristmasLights.c:50: SMS_loadTiles (fire__tiles__bin, 297, fire__tiles__bin_size);
	ld	hl, #0x00c0
	push	hl
	ld	hl, #_fire__tiles__bin
	push	hl
	ld	hl, #0x6520
	push	hl
	call	_SMS_VRAMmemcpy
;ChristmasLights.c:51: SMS_loadTileMapArea (6, 3, Yule__tilemap__bin, 20, 18);
	ld	de, #0x1214
	push	de
	ld	hl, #_Yule__tilemap__bin
	push	hl
	ld	de, #0x0306
	push	de
	call	_SMS_loadTileMapArea
	ld	hl, #6
	add	hl, sp
	ld	sp, hl
;ChristmasLights.c:52: SMS_mapROMBank(4);
	ld	hl,#_ROM_bank_to_be_mapped_on_slot2 + 0
	ld	(hl), #0x04
;ChristmasLights.c:53: SMS_loadTiles (Yule__tiles__bin, 0, Yule__tiles__bin_size);
	ld	hl, #0x2520
	push	hl
	ld	hl, #_Yule__tiles__bin
	push	hl
	ld	hl, #0x4000
	push	hl
	call	_SMS_VRAMmemcpy
;ChristmasLights.c:54: SMS_displayOn();
	ld	hl, #0x0140
	call	_SMS_VDPturnOnFeature
00121$:
;ChristmasLights.c:58: SMS_waitForVBlank();
	call	_SMS_waitForVBlank
;ChristmasLights.c:60: keyPress = SMS_getKeysPressed();
	call	_SMS_getKeysPressed
;ChristmasLights.c:61: if (keyPress & GG_KEY_START)
	add	hl, hl
	jr	NC,00105$
;ChristmasLights.c:63: if(songidle)
	bit	0, -1 (ix)
	jr	Z,00102$
;ChristmasLights.c:65: SMS_mapROMBank(PlayList[PlayListIndex].songbank);
	ld	bc, (_PlayListIndex)
	ld	l, c
	ld	h, b
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, bc
	ex	de, hl
	ld	hl, #_PlayList
	add	hl, de
	ex	de, hl
	ld	l, e
	ld	h, d
	inc	hl
	inc	hl
	ld	a, (hl)
	ld	(_ROM_bank_to_be_mapped_on_slot2+0), a
;ChristmasLights.c:66: PSGPlayNoRepeat(PlayList[PlayListIndex].song);
	ex	de,hl
	ld	c, (hl)
	inc	hl
	ld	b, (hl)
	push	bc
	call	_PSGPlayNoRepeat
	pop	af
;ChristmasLights.c:67: SMS_mapROMBank(PlayList[PlayListIndex].eventbank);
	ld	bc, (_PlayListIndex)
	ld	l, c
	ld	h, b
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, bc
	ex	de, hl
	ld	hl, #_PlayList
	add	hl, de
	ex	de, hl
	ld	l, e
	ld	h, d
	ld	bc, #0x0007
	add	hl, bc
	ld	a, (hl)
	ld	(_ROM_bank_to_be_mapped_on_slot2+0), a
;ChristmasLights.c:68: IOPlay(PlayList[PlayListIndex].event, PlayList[PlayListIndex].eventsize);
	ld	l, e
	ld	h, d
	ld	bc, #0x0005
	add	hl, bc
	ld	c, (hl)
	inc	hl
	ld	b, (hl)
	ex	de,hl
	inc	hl
	inc	hl
	inc	hl
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	push	bc
	push	de
	call	_IOPlay
	pop	af
	pop	af
;ChristmasLights.c:69: songidle = 0;
	xor	a, a
	ld	-1 (ix), a
	jr	00105$
00102$:
;ChristmasLights.c:73: songidle = 1;
	ld	-1 (ix), #0x01
;ChristmasLights.c:74: PSGStop();
	call	_PSGStop
;ChristmasLights.c:75: IOStop();
	call	_IOStop
00105$:
;ChristmasLights.c:79: if(PSGGetStatus() == PSG_STOPPED && !songidle)
	call	_PSGGetStatus
	ld	a, l
	or	a, a
	jp	NZ, 00133$
	bit	0, -1 (ix)
	jr	NZ,00133$
;ChristmasLights.c:81: PlayListIndex++;
	ld	hl, (_PlayListIndex)
	inc	hl
	ld	(_PlayListIndex), hl
;ChristmasLights.c:82: if(PlayListIndex >= MAX_PLAYLIST_ITEMS)
	ld	iy, #_PlayListIndex
	ld	a, 0 (iy)
	sub	a, #0x03
	ld	a, 1 (iy)
	sbc	a, #0x00
	jr	C,00107$
;ChristmasLights.c:84: PlayListIndex = 0;
	ld	hl, #0x0000
	ld	(_PlayListIndex), hl
;ChristmasLights.c:86: IOStop();
	call	_IOStop
;ChristmasLights.c:87: return;
	jp	00123$
00107$:
;ChristmasLights.c:91: SMS_mapROMBank(PlayList[PlayListIndex].songbank);
	ld	bc, (_PlayListIndex)
	ld	l, c
	ld	h, b
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, bc
	ex	de, hl
	ld	hl, #_PlayList
	add	hl, de
	ex	de, hl
	ld	l, e
	ld	h, d
	inc	hl
	inc	hl
	ld	a, (hl)
	ld	(_ROM_bank_to_be_mapped_on_slot2+0), a
;ChristmasLights.c:92: PSGPlayNoRepeat(PlayList[PlayListIndex].song);
	ex	de,hl
	ld	c, (hl)
	inc	hl
	ld	b, (hl)
	push	bc
	call	_PSGPlayNoRepeat
	pop	af
;ChristmasLights.c:93: SMS_mapROMBank(PlayList[PlayListIndex].eventbank);
	ld	bc, (_PlayListIndex)
	ld	l, c
	ld	h, b
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, bc
	ex	de, hl
	ld	hl, #_PlayList
	add	hl, de
	ex	de, hl
	ld	l, e
	ld	h, d
	ld	bc, #0x0007
	add	hl, bc
	ld	a, (hl)
	ld	(_ROM_bank_to_be_mapped_on_slot2+0), a
;ChristmasLights.c:94: IOPlay(PlayList[PlayListIndex].event, PlayList[PlayListIndex].eventsize);
	ld	l, e
	ld	h, d
	ld	bc, #0x0005
	add	hl, bc
	ld	c, (hl)
	inc	hl
	ld	b, (hl)
	ex	de,hl
	inc	hl
	inc	hl
	inc	hl
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	push	bc
	push	de
	call	_IOPlay
	pop	af
	pop	af
;ChristmasLights.c:98: for(int y=0;y<6;y++)
00133$:
	ld	bc, #0x0000
00119$:
	ld	a, c
	sub	a, #0x06
	ld	a, b
	rla
	ccf
	rra
	sbc	a, #0x80
	jr	NC,00113$
;ChristmasLights.c:100: for(int x=0;x<14;x++)
	ld	de, #0x0000
00116$:
	ld	a, e
	sub	a, #0x0e
	ld	a, d
	rla
	ccf
	rra
	sbc	a, #0x80
	jr	NC,00120$
	inc	de
	jr	00116$
00120$:
;ChristmasLights.c:98: for(int y=0;y<6;y++)
	inc	bc
	jr	00119$
00113$:
;ChristmasLights.c:125: SMS_mapROMBank(PlayList[PlayListIndex].eventbank);
	ld	bc, (_PlayListIndex)
	ld	l, c
	ld	h, b
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, bc
	ld	de, #_PlayList
	add	hl, de
	ld	de, #0x0007
	add	hl, de
	ld	a, (hl)
	ld	(_ROM_bank_to_be_mapped_on_slot2+0), a
;ChristmasLights.c:126: IOFrame();
	call	_IOFrame
;ChristmasLights.c:127: SMS_mapROMBank(PlayList[PlayListIndex].songbank);
	ld	bc, (_PlayListIndex)
	ld	l, c
	ld	h, b
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, bc
	ld	de, #_PlayList
	add	hl, de
	inc	hl
	inc	hl
	ld	a, (hl)
	ld	(_ROM_bank_to_be_mapped_on_slot2+0), a
;ChristmasLights.c:128: PSGFrame();
	call	_PSGFrame
	jp	00121$
00123$:
;ChristmasLights.c:130: }
	ld	sp, ix
	pop	ix
	ret
	.area _CODE
__str_0:
	.ascii "thatawesomeguy"
	.db 0x00
__str_1:
	.ascii "Christmas Lights"
	.db 0x00
__str_2:
	.db 0x00
	.area _INITIALIZER
__xinit__framecount:
	.dw #0x0000
__xinit__PlayList:
	.dw _CarolSpirits_psg
	.db #0x02	; 2
	.dw _CarolSpirits_Events_bin
	.dw #0x1180
	.dw #0x0004
	.dw _A_Very_Sega_Master_System_Christmas_psg
	.db #0x03	; 3
	.dw _A_Very_Sega_Master_System_Christmas_Events_bin
	.dw #0x133a
	.dw #0x0003
	.dw _A_Very_Sega_Master_System_Christmas_psg
	.db #0x03	; 3
	.dw _A_Very_Sega_Master_System_Christmas_Events_bin
	.dw #0x133a
	.dw #0x0003
__xinit__PlayListIndex:
	.dw #0x0000
	.area _CABS (ABS)
	.org 0x3FF0
___SMS__SEGA_signature:
	.db #0x54	; 84	'T'
	.db #0x4d	; 77	'M'
	.db #0x52	; 82	'R'
	.db #0x20	; 32
	.db #0x53	; 83	'S'
	.db #0x45	; 69	'E'
	.db #0x47	; 71	'G'
	.db #0x41	; 65	'A'
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0x01	; 1
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x7b	; 123
	.org 0x3FD1
___SMS__SDSC_author:
	.ascii "thatawesomeguy"
	.db 0x00
	.org 0x3FC0
___SMS__SDSC_name:
	.ascii "Christmas Lights"
	.db 0x00
	.org 0x3FBF
___SMS__SDSC_descr:
	.db 0x00
	.org 0x3FE0
___SMS__SDSC_signature:
	.db #0x53	; 83	'S'
	.db #0x44	; 68	'D'
	.db #0x53	; 83	'S'
	.db #0x43	; 67	'C'
	.db #0x01	; 1
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0xd1	; 209
	.db #0x3f	; 63
	.db #0xc0	; 192
	.db #0x3f	; 63
	.db #0xbf	; 191
	.db #0x3f	; 63
