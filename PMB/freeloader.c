#include <pmb8876_reg.h>
#include <pmb8876_uart.h>
#include <cfi_flash.h>

unsigned char cjkt_magic[] __attribute__ ((section (".rom_vectors"))) =
{ 
    0x00, 0x20, 0x00, 0x00, 0xFF, 0xDF, 0xFF, 0xFF, 
    0x20, 0x10, 0x02, 0xA0, 0x43, 0x4A, 0x4B, 0x54
};

int freeloader_main() __attribute__ ((section (".text")));

int
freeloader_main()
{
    int i;

    /* 
     * I don't know if the watchdog is disabled at this point
     * or not, but why take chances
     */
    //    disablewdt();

    //    uart_set_speed(0, USART_115200);

    while(1) {
	uart_poll_tx_byte(1, 'F');
	for(i = 0; i < 1000000; i++);
    }
}
