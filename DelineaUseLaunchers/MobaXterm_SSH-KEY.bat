@echo off
setlocal enabledelayedexpansion

:: Check if correct number of arguments are passed
if "%~1"=="" (
    echo Error: Base64 string is missing.
    exit /b
)
if "%~2"=="" (
    echo Error: User is missing.
    exit /b
)
if "%~3"=="" (
    echo Error: Host is missing.
    exit /b
)
if "%~4"=="" (
    echo Error: Port is missing.
    exit /b
)

:: Check if id_rsa already exists and delete it if so
if exist "C:\key\id_rsa" (
    echo Deleting existing id_rsa file...
    del "C:\key\id_rsa"
)

:: Create the directory for the key if it doesn't exist
if not exist "C:\key" (
    mkdir "C:\key"
)

:: Write the base64 string to a temporary file
echo %~1 > "C:\key\id_rsa_base64.txt"

:: Decode the base64 string using certutil and write to id_rsa file
certutil -decode "C:\key\id_rsa_base64.txt" "C:\key\id_rsa"

:: Delete the temporary base64 file after decoding
del "C:\key\id_rsa_base64.txt"

:: Search for MobaXterm.exe
set "MobaXtermPath="
for /r "C:\" %%i in (MobaXterm.exe) do (
    set "MobaXtermPath=%%i"
    goto :foundMobaXterm
)

echo MobaXterm not found on your system. Please make sure MobaXterm is installed.
exit /b

:foundMobaXterm
:: Now you have the full path in MobaXtermPath
echo Found MobaXterm at %MobaXtermPath%

:: Launch MobaXterm with SSH using the generated key
start "" "%MobaXtermPath%" -newtab "ssh -i c:/key/id_rsa %~2@%~3 -p %~4"

:: Wait for a few seconds to ensure MobaXterm starts the SSH session
timeout /t 10 /nobreak >nul

:: Ensure that the SSH session is running, then delete the id_rsa file
del "C:\key\id_rsa"

endlocal
