#if !defined(_ARM9_UTILS_H_)
#define _ARM9_UTILS_H_

#if defined(__cplusplus)
/* 
 * ...I know...and I wouldn't do it either...
 * but hey, who the hell knows what some 
 * of you might try
 */
extern "C" {
#endif	/* defined(__cplusplus) */

/* D cache functions */
void dcache_enable();
void dcache_disable();
unsigned int dcache_enabled();
void dcache_sync_clean();
void dcache_invalidate_all();

/* I cache functions */
void icache_enable();
void icache_disable();
unsigned int icache_enabled();
void icache_invalidate_all();

/* ARM9 misc functions */
void arm9_wait_for_interrupt();
void arm9_doze_mode();
void arm9_stop_mode();
void arm9_halt_mode();
void arm9_set_fastbus_mode();
void arm9_set_sync_mode();
void arm9_set_async_mode();
unsigned int arm9_get_clock_mode();

#if defined(__cplusplus)
}
#endif

#endif	/* !defined(_ARM9_UTILS_H_) */
