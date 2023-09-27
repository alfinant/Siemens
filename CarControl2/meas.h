#ifndef MEAS_H
#define MEAS_H

extern int meas_init();
extern void meas_deinit();
extern void meas_get_volt_m2(void(*callback)(int data));

#endif
