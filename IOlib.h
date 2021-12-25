// define GG Link stuff
__sfr __at 0x01 G2G_IOPinPort;
__sfr __at 0x02 G2G_NMIPort;
__sfr __at 0x03 G2G_TxPort;
__sfr __at 0x04 G2G_RxPort;
__sfr __at 0x05 G2G_StatusPort;

#define G2G_BYTE_SENT           0x01
#define G2G_BYTE_RECV           0x02
#define G2G_ERROR               0x04
#define G2G_ENABLE_NMI_ON_RECV  0x08
#define G2G_ENABLE_SEND         0x10
#define G2G_ENABLE_RECV         0x20

void IOPlay(unsigned char *IOData, unsigned int size);

void IOStop(void);

void IOFrame(void);