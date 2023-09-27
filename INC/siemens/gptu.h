#ifndef GPTU_H_
#define GPTU_H_

#include <stdint.h>
 
#define  __IO    volatile

#define  hw_clk      26000000

typedef struct
{
  __IO uint32_t GPTPISEL;      /* Port Input Select Register */
  __IO uint32_t RESERVED1; 
  __IO uint32_t GPTID;         /* Identification Register */
  __IO uint32_t RESERVED2; 
} GPTU_TypeDef;  

/*!< Peripheral memory map */

#define GPTU0_BASE                     ((uint32_t)0xF4000000)
#define GPTU1_BASE                     ((uint32_t)0xF4100000)

/*!< Peripheral_declaration */  

#define GPTU0                             ((GPTU_TypeDef *) GPTU0_BASE)
#define GPTU1                             ((GPTU_TypeDef *) GPTU1_BASE)

/*******************************************************************************/ 
/*                                                                             */
/*                                 GPTU                                      */
/*                                                                             */
/*******************************************************************************/
 



/*********************** Bit definition for Interrupt Control Registers *****************************/ 

#define  GPTU_IC_IE                        ((uint16_t)0x1000)                     /*!< Interruprt Enable Control Bit*/
#define  GPTU_IC_IR                        ((uint16_t)0x2000)                     /*!< Interrupt Request Flag */
#define  GPTU_IC_GPX                       ((uint16_t)0x4000)                     /*!< Group Priority Extension */


#endif /* GPTU_H_ */
