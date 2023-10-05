if exist %2\S75_520300.bin %1\elf2vkp.exe %2\aes128.elf %2\aes128_S75v52.vkp %2\S75_520300.bin
if not exist %2\S75_520300.bin %1\elf2vkp.exe %2\aes128.elf %2\aes128.vkp
