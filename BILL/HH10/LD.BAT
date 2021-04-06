@echo off
c:
set IMGDIR=g:\bill\wwf
cls
echo.
echo	*********** NHL image loader *************
echo.
echo.
echo		A.............load everything
echo		B.............build everything
echo		C.............build main.lod
echo.
choice /C:ABC	 "	Your choice - "
echo.

if errorlevel 3 goto hh
if errorlevel 2 goto buildall
if errorlevel 1 goto loadall


:hh
loadw main /A /TS /FI /E
goto end

:buildall
del bgndpal.asm
del bgndtbl.asm

loadw hh /TS /FI /E
goto end

:loadall
loadw hh /RI /E

goto end

:end
