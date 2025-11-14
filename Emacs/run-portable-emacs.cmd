@echo off
set USB_DRIVE=%~d0
set HOME=%USB_DRIVE%\Emacs
if not exist "%HOME%\.emacs.d" mkdir "%HOME%\.emacs.d"

for /d %%i in ("%USB_DRIVE%\Emacs\emacs-*") do set EMACS_DIR=%%i

set GIT_ROOT=%USB_DRIVE%\PortableGit
set PATH=%GIT_ROOT%\bin;%GIT_ROOT%\mingw64\bin;%GIT_ROOT%\usr\bin;%EMACS_DIR%\bin;%PATH%

:: Start Emacs GUI only
start "" "%EMACS_DIR%\bin\runemacs.exe"
exit
