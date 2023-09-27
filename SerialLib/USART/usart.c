#include "..\..\inc\usart.h"

void S0Tx_byte(unsigned char tx)
{
  S0.ICON &= ~ (USART_IC_TX | USART_IC_TBUF);  /* отключаем прерывания при передаче(прерывания не будут выполняться,но флаги запроса на прерывания будут устанавливаться) */
  S0.TBUF = tx & 0xFF;
  while(!(S0.ISTAT & (USART_IC_TX | USART_IC_TBUF))); /* ждем установки флагов запроса на прерывание */
  S0.IFLCLR = (USART_IC_TX | USART_IC_TBUF);   /* сбрасываем флаги запроса на прерывание */
}

void S0_setbaudrate(unsigned int baudrate_data)
{
  S0.BG = ((baudrate_data>>16)&0xFFFF);
  S0.FDV = baudrate_data&0xFFFF;
}
