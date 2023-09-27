#ifndef GPIO_NSG_H_
#define GPIO_NSG_H_

/* 0x700-лог 1(+), 0x500-лог 0(-)  */
#define  GPIO_USART0_RXD    *(volatile int*)  0xF430004C //порт=2, nano  pin=4
#define  GPIO_USART0_TXD    *(volatile int*)  0xF4300050 //порт=2, nano  pin=3, с подт€жкой
#define  GPIO_USB_DMINUS    *(volatile int*)  0xF4300054 //порт=6, nano  pin=2
#define  GPIO_USB_DPLUS     *(volatile int*)  0xF4300058 //порт=6, nano  pin=1, с подт€жкой 
#define  GPIO_USB_VDDP_USB  *(volatile int*)  0xF43000F4 
#define  GPIO_RF_STR1       *(volatile int*)  0xF4300104 //порт=0xD, идет на dialog(PM_RINGIN),используетс€ дл€ генерации звуков 

#endif /* GPIO_NSG_H_ */
