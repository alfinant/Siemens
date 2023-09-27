#if !defined(_CFI_H_)
#define _CFI_H_

/*
 * CFI flash definitions and query block
 * CFI is universal, but this was done for the Strataflash 
 * hooked upto the PMB8876 in the iPhone
 */

#define FLASH_WORD_SIZE			(unsigned short)

#define FLASH_BASE			0xA0000000
#define FLASH_BASE_MASK			0xB0000000
#define FLASH_BLOCK_SIZE		0x10000
#define FLASH_ERASE_BLOCK_SIZE		0x2000

/* Read operations */
#define FLASH_RESET        		FLASH_WORD_SIZE(0xFF)
#define FLASH_READ_STATUS  		FLASH_WORD_SIZE(0x70)
#define FLASH_READ_ID			FLASH_WORD_SIZE(0x90)
#define FLASH_READ_CFI_QUERY   		FLASH_WORD_SIZE(0x98)
#define FLASH_CLEAR_STATUS 		FLASH_WORD_SIZE(0x50)

/* Program operations */
#define FLASH_PROGRAM      		FLASH_WORD_SIZE(0x40)
#define FLASH_PROGRAM_ALT      		FLASH_WORD_SIZE(0x10)
#define FLASH_EFP_SETUP			FLASH_WORD_SIZE(0x30)
#define FLASH_EFP_CONFIRM		FLASH_WORD_SIZE(0x30)

/* Erase operations */
#define FLASH_BLOCK_ERASE  		FLASH_WORD_SIZE(0x20)
#define FLASH_ERASE_CONFIRM    		FLASH_WORD_SIZE(0xD0)

/* Suspend operations */
#define FLASH_SUSPEND			FLASH_WORD_SIZE(0xB0)
#define FLASH_RESUME			FLASH_WORD_SIZE(0xD0)

/* Block locking operations */
#define FLASH_LOCK_SETUP     		FLASH_WORD_SIZE(0x60)
#define FLASH_SET_LOCK_CONFIRM 		FLASH_WORD_SIZE(0x01)
#define FLASH_CLEAR_LOCKS_CONFIRM	FLASH_WORD_SIZE(0xD0)
#define FLASH_LOCKDOWN  		FLASH_WORD_SIZE(0x2F)

/* Protection operations */
#define FLASH_PROTECTION_SETUP		FLASH_WORD_SIZE(0xC0)

/* Flash configuartion operations */
#define FLASH_CONFIG_SETUP		FLASH_WORD_SIZE(0x60)
#define FLASH_CONFIG_SET_REG		FLASH_WORD_SIZE(0x03)

/* Flash status codes */
#define FLASH_STATUS_READY 		FLASH_WORD_SIZE(0x80)
                                                     
#define FLASH_ERROR_MASK		FLASH_WORD_SIZE(0x7E)
#define FLASH_ERROR_PROGRAM		FLASH_WORD_SIZE(0x10)
#define FLASH_ERROR_ERASE		FLASH_WORD_SIZE(0x20)

typedef struct _CFI_QUERY {
    unsigned char manuf_code;
    unsigned char device_code;
    unsigned char _unused0[14];
    unsigned char id[3];  /* 'QRY' */
    unsigned char _unused1[20];
    unsigned char device_size;
    unsigned char device_interface[2];
    unsigned char buffer_size[2];
    unsigned char is_block_oriented;
    unsigned char num_regions[2];
    unsigned char region_size[2];
} CFI_QUERY_T;

typedef unsigned int flash_addr_t;

#endif	/* !defined(_CFI_H_) */
