@title Install Arches, Windows 10 64-bit
@echo off

echo ############################
echo INSTALLING ARCHES ON WINDOWS
echo ----------------------------

set DEST=C:\ArchesProjects
set PYPATH=C:\Python27Arches

if not exist %DEST% mkdir %DEST%
set TEMPDIR=%DEST%\temp
if not exist %TEMPDIR% mkdir %TEMPDIR%
cd %TEMPDIR%

rem GET START TIME
for /F "tokens=1-4 delims=:.," %%a in ("%time%") do (
   set /A "start=(((%%a*60)+1%%b %% 100)*60+1%%c %% 100)*100+1%%d %% 100"
)

set PYURL=https://www.python.org/ftp/python/3.7.1/python-3.7.1-amd64.exe
set PYDOWN=python-3.7.1-amd64.exe
if not exist %TEMPDIR%\%PYDOWN% (
    echo Downloading Python 2.7.13...
    curl %PYURL% -o %PYDOWN% -k
    echo     download complete. & echo ~-~-~-~-~-~-~
)

if not exist %PYPATH% (
    echo Creating Python installation in %PYPATH%...
    %WINDIR%\System32\msiexec /qn /i %PYDOWN% TARGETDIR=%PYPATH%
    echo     installation complete. & echo ~-~-~-~-~-~-~
) else (
    echo Python already installed.
    echo (remove C:\Python27Arches to force reinstallation) & echo ~-~-~-~-~-~-~
)
set PYEXE=%PYPATH%\python.exe

echo Getting pip...
SET PIPURL=https://bootstrap.pypa.io/get-pip.py
SET PIPDOWN=get-pip.py
curl %PIPURL% -o %PIPDOWN% -k
call %PYEXE% %PIPDOWN%
echo     pip installed. & echo ~-~-~-~-~-~-~
