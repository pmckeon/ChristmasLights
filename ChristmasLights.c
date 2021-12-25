#include <stdint.h>
#include <stdbool.h>
#include "SMSlib.h"
#include "PSGlib.h"
#include "IOlib.h"
#include "assets2banks.h"

#define STRING_OFFSET (-32)

void putstring(uint8_t x, uint8_t y, const char* string)
{
    SMS_setNextTileatXY(x, y);
    while (*string)
    {
        SMS_setTile(*string++ + STRING_OFFSET);
    }
}

unsigned int framecount = 0;

struct ListItem
{
    void *song;
    unsigned char songbank;
    unsigned char *event;
    unsigned int eventsize;
    unsigned int eventbank;
};

#define MAX_PLAYLIST_ITEMS 3
struct ListItem PlayList[] = {
            { CarolSpirits_psg, CarolSpirits_psg_bank, CarolSpirits_Events_bin, CarolSpirits_Events_bin_size, CarolSpirits_Events_bin_bank},
            { A_Very_Sega_Master_System_Christmas_psg, A_Very_Sega_Master_System_Christmas_Events_bin_bank, A_Very_Sega_Master_System_Christmas_Events_bin, A_Very_Sega_Master_System_Christmas_Events_bin_size, A_Very_Sega_Master_System_Christmas_Events_bin_bank},
            { A_Very_Sega_Master_System_Christmas_psg, A_Very_Sega_Master_System_Christmas_Events_bin_bank, A_Very_Sega_Master_System_Christmas_Events_bin, A_Very_Sega_Master_System_Christmas_Events_bin_size, A_Very_Sega_Master_System_Christmas_Events_bin_bank}
    };
unsigned int PlayListIndex = 0;

void main(void)
{
    unsigned int keyPress;
    unsigned int fire[6][14];
    bool songidle = 1;

    IOStop();

    //SMS_VRAMmemset(0,0,16384);
    //SMS_autoSetUpTextRenderer();
    SMS_mapROMBank(2);
    GG_loadBGPalette (Yule__palette__bin);
    SMS_loadTiles (fire__tiles__bin, 297, fire__tiles__bin_size);
    SMS_loadTileMapArea (6, 3, Yule__tilemap__bin, 20, 18);
    SMS_mapROMBank(4);
    SMS_loadTiles (Yule__tiles__bin, 0, Yule__tiles__bin_size);
    SMS_displayOn();

    for (;;)
    {
        SMS_waitForVBlank();

        keyPress = SMS_getKeysPressed();
        if (keyPress & GG_KEY_START)
        {
            if(songidle)
            {
                SMS_mapROMBank(PlayList[PlayListIndex].songbank);
                PSGPlayNoRepeat(PlayList[PlayListIndex].song);
                SMS_mapROMBank(PlayList[PlayListIndex].eventbank);
                IOPlay(PlayList[PlayListIndex].event, PlayList[PlayListIndex].eventsize);
                songidle = 0;
            }
            else
            {
                songidle = 1;
                PSGStop();
                IOStop();
            }
        }

        if(PSGGetStatus() == PSG_STOPPED && !songidle)
        {
            PlayListIndex++;
            if(PlayListIndex >= MAX_PLAYLIST_ITEMS)
            {
                PlayListIndex = 0;
                songidle = 1;
                IOStop();
                return;
            }
            else
            {
                SMS_mapROMBank(PlayList[PlayListIndex].songbank);
                PSGPlayNoRepeat(PlayList[PlayListIndex].song);
                SMS_mapROMBank(PlayList[PlayListIndex].eventbank);
                IOPlay(PlayList[PlayListIndex].event, PlayList[PlayListIndex].eventsize);
            }
        }

        for(int y=0;y<6;y++)
        {
            for(int x=0;x<14;x++)
            {
                /*int y1, y2;
                if(x==0)
                    y1 = fire[y][x];
                else
                    y1 = fire[y][x-1];
                fire[y][x];*/
            }
        }
        /*framecount++;
        if(framecount >= 10)
        {
            framecount = 0;

            for(int x=10; x < 22; x++)
            {

            int tile = rand() % (295 - 289 + 1) + 289;

            SMS_setNextTileatXY (x, 14);
            SMS_setTile (tile);
            }
        }*/

        SMS_mapROMBank(PlayList[PlayListIndex].eventbank);
        IOFrame();
        SMS_mapROMBank(PlayList[PlayListIndex].songbank);
        PSGFrame();
    }
}

//SMS_EMBED_SEGA_ROM_HEADER(1, 0);
//SMS_EMBED_SDSC_HEADER_AUTO_DATE(1,0,"thatawesomeguy","Christmas Lights","");
SMS_EMBED_SEGA_ROM_HEADER_16KB(1, 0);
SMS_EMBED_SDSC_HEADER_AUTO_DATE_16KB(1,0,"thatawesomeguy","Christmas Lights","");