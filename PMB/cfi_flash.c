#include <cfi_flash.h>
#include <arm9_utils.h>

unsigned int
cfi_flash_lock_block(volatile flash_addr_t *block)
{
    volatile unsigned int *flash;
    unsigned int stat;
    int timeout = 5000000;

    flash = (unsigned int *)(FLASH_BASE_MASK & (unsigned int)block);

    /* Clear error conditions */
    flash[0] = FLASH_CLEAR_STATUS;

    /* Set lock bit */
    block[0] = FLASH_LOCK_SETUP;
    block[0] = FLASH_SET_LOCK_CONFIRM; 

    while(((stat = flash[0]) & FLASH_STATUS_READY) != FLASH_STATUS_READY) {
        if (!--timeout)
	    break;
    }

    /* Put flash back into normal mode */
    flash[0] = FLASH_RESET;

    return stat;
}

unsigned int
flash_query(CFI_QUERY_T *query)
{
    CFI_QUERY_T *cfi;
    volatile unsigned int *flash = (unsigned int *)FLASH_BASE;
    unsigned int i, delay;

    /* This needs to be roughly a 30ms delay */
    delay = (30 * 1000 * 10);

    if(!query) 
	return 0;
    
    flash[0] = FLASH_READ_CFI_QUERY;
    i = sizeof(CFI_QUERY_T);

    for(; delay > 0; delay--);
    
    cfi = (CFI_QUERY_T *)flash;

    query->manuf_code = cfi->manuf_code;
    query->device_code = cfi->device_code;

    query->id[0] = cfi->id[0];
    query->id[1] = cfi->id[1];
    query->id[2] = cfi->id[2];

    query->device_size = cfi->device_size;

    query->device_interface[0] = cfi->device_interface[0];
    query->device_interface[1] = cfi->device_interface[1];

    query->buffer_size[0] = cfi->buffer_size[0];
    query->buffer_size[1] = cfi->buffer_size[1];

    query->is_block_oriented = cfi->is_block_oriented;

    query->num_regions[0] = cfi->num_regions[0];
    query->num_regions[1] = cfi->num_regions[1];

    query->region_size[0] = cfi->region_size[0];
    query->region_size[1] = cfi->region_size[1];

    /* Put the flash back into normal mode */
    flash[0] = FLASH_RESET;

    return 0;
}

unsigned int
flash_unlock_block(volatile flash_addr_t *block, unsigned int block_size, unsigned int blocks)
{
    volatile flash_addr_t *flash_base, stat;
    
    int clear_blocksize = block_size;
    int timeout = 5000000;

    flash_base = (flash_addr_t *)(FLASH_BASE_MASK & (unsigned int)block);

    /* Clear any error conditions */
    flash_base[0] = FLASH_CLEAR_STATUS;

    if((block - flash_base) < FLASH_BLOCK_SIZE / (sizeof(block[0])))
	clear_blocksize = FLASH_ERASE_BLOCK_SIZE;

    while(block_size > 0) {
	
	block[0] = FLASH_LOCK_SETUP;
	block[0] = FLASH_CLEAR_LOCKS_CONFIRM;  // Confirmation
	
	timeout = 5000000;
	
	while(((stat = flash_base[0]) & FLASH_STATUS_READY) != FLASH_STATUS_READY) {
	    if (!--timeout)
		break;
	}
	
	block_size -= clear_blocksize;
	block = (flash_addr_t *)((unsigned int)block + clear_blocksize);
    }

    flash_base[0] = FLASH_RESET;

    return stat;
}
