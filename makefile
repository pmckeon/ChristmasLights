# program executable file name.
PROG = ChristmasLights
# compiler
CC = sdcc
# linker
LD = sdcc
# delete command
RM = del /f
# Compiler flags go here.
CFLAGS = -MMD -c -mz80 -DTARGET_GG --peep-file peep-rules.txt
# Linker flags go here.
LDFLAGS = -mz80 --no-std-crt0 --data-loc 0xC000 -Wl-b_BANK2=0x8000 -Wl-b_BANK3=0x8000 -Wl-b_BANK4=0x8000
CRT0 = crt0_sms.rel
SMSLIB = SMSlib_GG.lib
OBJS = $(PROG).rel IOlib.rel PSGlib.rel bank2.rel bank3.rel bank4.rel
DEPS = $(OBJS:.rel=.d)

$(PROG).gg: $(PROG).ihx
	ihx2sms $< $@

$(PROG).ihx: $(OBJS)
	-$(LD) -o $@ $(LDFLAGS) $(CRT0) ChristmasLights.rel IOlib.rel PSGlib.rel $(SMSLIB) bank2.rel bank3.rel bank4.rel

%.rel: ChristmasLights.c IOLib.c PSGLib.c bank2.c bank3.c bank4.c
	$(CC) $(CFLAGS) ChristmasLights.c
	$(CC) $(CFLAGS) IOLib.c
	$(CC) $(CFLAGS) PSGLib.c
	$(CC) $(CFLAGS) --constseg BANK2 bank2.c
	$(CC) $(CFLAGS) --constseg BANK3 bank3.c
	$(CC) $(CFLAGS) --constseg BANK4 bank4.c

.PHONY: clean
clean:
	-$(RM) *.gg *.ihx *.asm $(OBJS) $(DEPS)

-include $(DEPS)