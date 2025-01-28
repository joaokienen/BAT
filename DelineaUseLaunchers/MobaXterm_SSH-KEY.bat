@echo off

:: Define MobaXterm path as a variable
set "MobaXtermPath=C:\Program Files (x86)\Mobatek\MobaXterm"
set "MobaXtermExec=MobaXterm.exe"

:: Check if MobaXterm is installed in the default path
if not exist "%MobaXtermPath%\%MobaXtermExec%" (
    echo "%MobaXtermExec%" is not installed on "%MobaXtermPath%\".
    timeout /t 8 /nobreak >nul
    exit /b
)

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
if exist "C:\temp\id_rsa" (del "C:\temp\id_rsa")

:: Create the directory for the key if it doesn't exist
if not exist "C:\temp" (mkdir "C:\temp")

:: Write the base64 string to a temporary file
echo %~1 > "C:\temp\id_rsa_base64.txt"

:: Decode the base64 string using certutil and write to id_rsa file
certutil -decode "C:\temp\id_rsa_base64.txt" "C:\temp\id_rsa" >nul 2>&1

:: Delete the temporary base64 file after decoding
del "C:\temp\id_rsa_base64.txt"

:: Launch MobaXterm with SSH using the generated key
cd "%MobaXtermPath%"
start %MobaXtermExec% -newtab "ssh -i c:/temp/id_rsa %~2@%~3 -p %~4"

:: Wait for a few seconds to ensure MobaXterm starts the SSH session
timeout /t 25 /nobreak >nul

:: Ensure that the SSH session is running, then delete the id_rsa file
del "C:\temp\id_rsa"
