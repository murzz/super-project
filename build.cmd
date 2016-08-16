@echo off

:: VS2013
::set VCVARS32="C:\Program Files (x86)\Microsoft Visual Studio 12.0\VC\bin\vcvars32.bat"
::set VCVARS64="C:\Program Files (x86)\Microsoft Visual Studio 12.0\VC\bin\amd64\vcvars64.bat"

:: VS2015
set VCVARS32="C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\bin\vcvars32.bat"
set VCVARS64="C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\bin\amd64\vcvars64.bat"

::------------------------------------------------------------------------------
call:call_build %VCVARS32% Win32
call:call_build %VCVARS64% x64

goto:eof

::------------------------------------------------------------------------------
:call_build
setlocal
set VCVARS="%~1"
set ARC=%~2

call %VCVARS%
set SRC_DIR=%CD:\=/%
set BUILD_DIR=%SRC_DIR%/build-%ARC%
set INSTALL_DIR=%BUILD_DIR%/_install
::call:build %SRC_DIR% %BUILD_DIR% %INSTALL_DIR% Release apps -G "Visual Studio 12 2013" -A %ARC% -DWITH_CMAKE=1
call:build %SRC_DIR% %BUILD_DIR% %INSTALL_DIR% Release apps -G "Visual Studio 14 2015" -A %ARC%
::call:build %SRC_DIR% %BUILD_DIR% %INSTALL_DIR% Release qt -G "Visual Studio 14 2015" -A %ARC%
::call:build %SRC_DIR% %BUILD_DIR% %INSTALL_DIR% Release libssh -G "NMake Makefiles"
::call:build %SRC_DIR% %BUILD_DIR% %INSTALL_DIR% Release apps -G "Ninja"
:: -DWITH_CMAKE=1 -DWITH_NINJA=1
::call:build %SRC_DIR% %BUILD_DIR% %INSTALL_DIR% Release libssh

goto:eof

::------------------------------------------------------------------------------
:build
setlocal
set SRC_DIR=%~1
set BUILD_DIR=%~2
set INSTALL_DIR=%~3
set CONFIG=%~4
set TARGET=%~5

:: shift first parameters away
for /F "tokens=5* delims= " %%G in ("%*") do set OTHER_PARAMS=%%H

:: echo cmake params: %other_params%
::if not exist "%BUILD_DIR%/CMakeCache.txt"
cmake -B%BUILD_DIR% ^
-H%SRC_DIR% ^
-DCMAKE_BUILD_TYPE=%CONFIG% ^
-DCMAKE_INSTALL_PREFIX=%INSTALL_DIR% ^
-DCPACK_INSTALLED_DIRECTORIES="%INSTALL_DIR%;." ^
%OTHER_PARAMS% > %BUILD_DIR%-config.log 2>&1
if %ERRORLEVEL% neq 0 exit /B %ERRORLEVEL%

cmake -E time cmake --build %BUILD_DIR% ^
--config %CONFIG% ^
--target %TARGET% > %BUILD_DIR%-build.log 2>&1
if %ERRORLEVEL% neq 0 exit /B %ERRORLEVEL%

goto:eof
