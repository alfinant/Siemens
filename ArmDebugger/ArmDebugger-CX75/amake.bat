rem amake.bat "filename" "path_to_keil" "assembler_args" "linker_args"
rem ------------------------------------------------------------------
set PATH=%PATH%;%2\bin
set CAINC=%2\inc
echo Compiling... >%1.err
aa %1.asm %3 >>%1.err
if errorlevel 2 exit 1
la %1.obj %4 >>%1.err
if errorlevel 1 exit 1
oha %1 >>%1.err
if errorlevel 1 exit 1
exit 0
