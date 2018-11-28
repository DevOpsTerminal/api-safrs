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

set PYURL=https://www.python.org/ftp/python/2.7.13/python-2.7.13.amd64.msi
set PYDOWN=python-2.7.13.amd64.msi
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

echo Installing virtualenv 15.1.0...
call %PYEXE% -m pip install virtualenv==15.1.0
echo     installation complete. & echo ~-~-~-~-~-~-~

set ENV=%DEST%\ENV
echo Creating virtualenv in %ENV%
set VENV=%PYPATH%\Scripts\virtualenv.exe
call %VENV% %ENV%
echo     virtualenv created.

set ENV=%DEST%\ENV
set ACTIVATE=%ENV%\Scripts\activate
call %ACTIVATE%
echo     and activated. & echo ~-~-~-~-~-~-~


set SHURL=http://legiongis.com/local/Shapely-1.5.17-cp27-cp27m-win_amd64.whl
set SHDOWN=Shapely-1.5.17-cp27-cp27m-win_amd64.whl
echo Installing Shapely into ENV...
if not exist %TEMPDIR%\%SHDOWN% (
    curl %SHURL% -o %TEMPDIR%\%SHDOWN% -k
)
pip install %TEMPDIR%\%SHDOWN%
echo     shapely installed. & echo ~-~-~-~-~-~-~

echo Pip installing Arches into ENV
pip install arches==4.0b3 --no-binary :all:
echo     arches installed. & echo ~-~-~-~-~-~-~

echo Arches has now been installed in your new virtual environment.
echo You can continue to create a new Arches project, or exit with ctrl+C

echo Enter the name of your new project (lowercase, no spaces, no hyphens)
set /p PROJ=">> "
cd %DEST%
python %ENV%\Scripts\arches-project create %PROJ%
echo     project created. & echo ~-~-~-~-~-~-~

echo Running bower
cd %DEST%\%PROJ%\%PROJ%
call bower install
cd %DEST%
echo     bower components installed. & echo ~-~-~-~-~-~-~

cd %DEST%
echo Creating settings_local.py file...
echo   you can change these settings later in %PROJ%\%PROJ%\settings_local.py
echo Paste in your MapBox API key
set /p MAPBOX=">> "
echo Enter full path to your GDAL library. It will be something like:
echo C:/Program Files/GDAL/gdal201.dll
echo Use forward slashes, do not use quotation marks.
set /p GDAL=">> "
(
  echo GDAL_LIBRARY_PATH = "%GDAL%"
  echo MAPBOX_API_KEY = "%MAPBOX%"
) > %PROJ%\%PROJ%\settings_local.py

rem Patch for v4.0b3
findstr "settings_local" %PROJ%\%PROJ%\settings.py && (
  echo     local settings already imported
) || (
    (
    echo try:
    echo     from settings_local import *
    echo except ImportError:
    echo     pass
  ) >> %PROJ%\%PROJ%\settings.py
)
echo     settings_local.py file created. & echo ~-~-~-~-~-~-~
echo you can now add more variables to settings_local.py before continuing & echo ~-~-~-~-~-~-~
pause

:ES
cd %PROJ%
if not exist %DEST%\elasticsearch-5.2.1 (
    echo Installing ElasticSearch into %DEST%
    python manage.py es install -d %DEST%
    echo     ElasticSearch installed.
)
start %DEST%\elasticsearch-5.2.1\bin\elasticsearch.bat

echo Initial Arches database setup
python manage.py packages -o setup_db
python manage.py packages -o import_graphs
echo     db setup complete. & echo ~-~-~-~-~-~-~

echo Press any key to run Arches and open a browser. Use ctrl+C to exit.
pause >nul
start chrome localhost:8000
python manage.py runserver
