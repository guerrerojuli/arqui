#include <stdint.h>

/*  Convierte un valor BCD (0x00-0x99) a binario (0-99) */
uint8_t bcd_to_bin(uint8_t bcd)
{
    uint8_t result = (bcd & 0x0F)           /* unidades */
         + ((bcd >> 4) * 10);     /* decenas * 10  */
    
    return result;
}