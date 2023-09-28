rem cmake.bat "filename" "path_to_keil" "compiler_args" "linker_args"
rem -----------------------------------------------------------------
set PATH=%PATH%;%2\bin
set CAINC=%2\inc
rem set CALIB=%PATH%\lib
echo Compiling... >%1.err

ca %1.c %3 >>%1.err
if errorlevel 2 exit 1

echo AREA STARTUPCODE, CODE, AT 0x0 >_startup.s
echo PUBLIC __startup >>_startup.s
echo EXTERN CODE32 (main) >>_startup.s
echo __startup PROC CODE32 >>_startup.s
echo b main >>_startup.s
echo ENDP >>_startup.s
echo END >>_startup.s

aa _startup.s DEBUG NOPRINT >>%1.err
if errorlevel 2 exit 1
la %1.obj,_startup.obj %4 >>%1.err
if errorlevel 2 exit 1
oha %1 >>%1.err
if errorlevel 1 exit 1
exit 0
