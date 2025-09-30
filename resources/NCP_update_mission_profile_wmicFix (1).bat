@echo off

set RED=[0;31m
set NC=[0m

REM === Set CubeProgrammer path ===
set "CUBEPROGRAMMER=C:\Program Files\STMicroelectronics\STM32Cube\STM32CubeProgrammer\bin"
set "PATH=%CUBEPROGRAMMER%;%PATH%"
set "current_dir=%~dp0"

REM === Find the STLink Virtual COM Port using PowerShell ===
set "COMADDR="
for /f "usebackq delims=" %%i in (`powershell -Command "Get-WmiObject Win32_SerialPort | Where-Object { $_.Description -like '*STMicroelectronics STLink Virtual COM Port*' } | Select-Object -ExpandProperty DeviceID"`) do set "COMADDR=%%i"

if "%COMADDR%"=="" (
    echo COM PORT not detected
    goto :error
)

REM === Set baud rate and check for errors ===
mode %COMADDR% baud=2000000 parity=N data=8 stop=1 >nul
if %ERRORLEVEL% neq 0 (
    echo COM PORT already used
    goto :error
)


:: Run STM32_Programmer_CLI and capture output
for /f "tokens=3" %%i in ('"STM32_Programmer_CLI.exe -c port=swd mode=ur | findstr/C:"Board""') do set BOARD_ID=%%i

if "%BOARD_ID%" == "" echo Board ID not detected && goto :error

:: Check if the board ID is recognized (NUCLEO-U575ZI-Q, NUCLEO-H7S3L8, NUCLEO-H563ZI or NUCLEO-N657X0-Q)
if not "%BOARD_ID%" == "NUCLEO-H7S3L8" if not "%BOARD_ID%" == "NUCLEO-U575ZI-Q" if not "%BOARD_ID%" == "NUCLEO-H563ZI" if not "%BOARD_ID%" == "NUCLEO-N657X0-Q" (
    echo Board ID %BOARD_ID% not recognized
    goto :error
)

echo Detected %BOARD_ID% board

if "%BOARD_ID%" == "NUCLEO-N657X0-Q" (
    echo "Set the boot mode in development mode (BOOT1 switch position is 2-3, BOOT0 switch position doesn't matter)"
    echo "Press any key to continue..."
    pause >nul
    STM32_Programmer_CLI.exe -c port=swd mode=ur -w %current_dir%..\%BOARD_ID%_Binaries\Bootloader.bin 0x70000000 --extload %CUBEPROGRAMMER%\ExternalLoader\MX25UM51245G_STM32N6570-NUCLEO.stldr
    if %ERRORLEVEL% neq 0 goto :error
    echo "Set the boot mode in boot from external Flash (BOOT0 switch position is 1-2 and BOOT1 switch position is 1-2)"
    echo "Press the reset button then press any key to continue..."
    pause >nul
) else (
    STM32_Programmer_CLI.exe -c port=swd mode=ur -w %current_dir%..\%BOARD_ID%_Binaries\Bootloader.bin 0x08000000 --go
    if %ERRORLEVEL% neq 0 goto :error
)

:: Configure the COM port (adjust settings as needed)
mode %COMADDR% baud=2000000 parity=N data=8 stop=1 >nul

:: Add a small delay to simulate a reset
timeout /t 1 /nobreak >nul

:: Reopen the COM port to reset buffers
mode %COMADDR% baud=2000000 parity=N data=8 stop=1 >nul
echo Buffers for %COMADDR% have been flushed

echo NCP Flashing in progress ...
%current_dir%..\QConn_Flash\QConn_Flash_Cmd.exe --port %COMADDR% --config %current_dir%NCP_Binaries\mission_flash_prog_cfg.ini
if %ERRORLEVEL% neq 0 goto :error

if "%BOARD_ID%" == "NUCLEO-H7S3L8" (
    STM32_Programmer_CLI.exe -c port=swd mode=ur -w %current_dir%..\%BOARD_ID%_Binaries\ST67W6X_CLI_Boot.bin 0x08000000
    if %ERRORLEVEL% neq 0 goto :error
    STM32_Programmer_CLI.exe -c port=swd mode=ur -w %current_dir%..\%BOARD_ID%_Binaries\ST67W6X_CLI_Appli.bin 0x70000000 --extload %CUBEPROGRAMMER%\ExternalLoader\MX25UW25645G_NUCLEO-H7S3L8.stldr
    if %ERRORLEVEL% neq 0 goto :error
) else if "%BOARD_ID%" == "NUCLEO-N657X0-Q" (
    echo "Set the boot mode in development mode (BOOT1 switch position is 2-3, BOOT0 switch position doesn't matter)"
    echo "Press any key to continue..."
    pause >nul
    STM32_Programmer_CLI.exe -c port=swd mode=ur -w %current_dir%..\%BOARD_ID%_Binaries\ST67W6X_CLI_FSBL.bin 0x70000000 --extload %CUBEPROGRAMMER%\ExternalLoader\MX25UM51245G_STM32N6570-NUCLEO.stldr
    if %ERRORLEVEL% neq 0 goto :error
    echo "Set the boot mode in boot from external Flash (BOOT0 switch position is 1-2 and BOOT1 switch position is 1-2)"
    echo "Press the reset button then press any key to continue..."
    pause >nul
) else (
    STM32_Programmer_CLI.exe -c port=swd mode=ur -w %current_dir%..\%BOARD_ID%_Binaries\ST67W6X_CLI.bin 0x08000000 --go
    if %ERRORLEVEL% neq 0 goto :error
)

pause
exit /B

:error
echo %RED%!!!! Error detected !!!!%NC%
pause
