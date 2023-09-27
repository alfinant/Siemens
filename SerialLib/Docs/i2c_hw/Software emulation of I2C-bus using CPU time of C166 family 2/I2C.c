/******************************************************************************/
/* The include file name: I2C.DEF					      */
/*									      */	
/* This is an include file for I/O port declaration of SCL and SDA as well    */
/* the direction declaration of those I/O port. The users can modify this     */
/* include file according to the I/O port assignment of thier preference.     */	
/*                                                                            */
/*                                                     			      */
/******************************************************************************/
				


sbit DSCL = DP3^3;
sbit DSDA = DP3^7;
sbit SCL = P3^3; 
sbit SDA = P3^7;



