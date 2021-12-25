#include "IOlib.h"

#define IO_STOPPED         0
#define IO_PLAYING         1

unsigned char IOStatus;
unsigned char *IOStart;
unsigned char *IOPointer;
unsigned int IOSize;

void IOPlay(unsigned char *IOData, unsigned int size)
{
    G2G_NMIPort = 0x80;
    G2G_IOPinPort = 0x00;
    IOStart = IOData;
    IOPointer = IOData;
    IOSize = size;
    IOStatus=IO_PLAYING;
}

void IOStop(void)
{
    G2G_NMIPort = 0x80;
    G2G_IOPinPort = 0x00;
    
    unsigned int byte;
    for(int i=7;i>=0;i--)
    {
        byte = 0;
        G2G_IOPinPort = byte;
        byte |= 1;
        G2G_IOPinPort = byte;
        byte &= 0xFE;
        G2G_IOPinPort = byte;
    }
    byte |= 1 << 1;
    G2G_IOPinPort = byte;
    byte = 0;
    G2G_IOPinPort = byte;
    
    IOStatus = IO_STOPPED;
}

// every 3 frames for 50ms timing
void IOFrame(void)
{
    static int count = 0;
    static int frame = 0;

    if(IOStatus == IO_PLAYING)
    {
        if(frame == 0)
        {
            unsigned int byte;
            for(int i=7;i>=0;i--)
            {
                byte = 0;
                byte |= (((*IOPointer)>>i) & 1)<<2;
                IOPointer++;
                byte |= (((*IOPointer)>>i) & 1)<<3;
                IOPointer--;
                G2G_IOPinPort = byte;
                byte |= 1;
                G2G_IOPinPort = byte;
                byte &= 0xFE;
                G2G_IOPinPort = byte;
            }
            byte |= 1 << 1;
            G2G_IOPinPort = byte;
            byte = 0;
            G2G_IOPinPort = byte;
            //G2G_IOPinPort = *IOPointer;
            IOPointer+=2;
            count+=2;
            if(count >= IOSize)
            {
                IOStatus = IO_STOPPED;
                count = 0;
            }
            frame++;
        }
        else
        {
            frame++;
            if(frame >= 3)
                frame = 0;
        }
    }
}