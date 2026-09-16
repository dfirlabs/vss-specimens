@echo off

rem Script to generate VSS redirected storage test files
rem Requires Windows 7 or later

rem Split the output of ver e.g. "Microsoft Windows [Version 10.0.10586]"
rem and keep the last part "10.0.10586]".
for /f "tokens=1,2,3,4" %%a in ('ver') do (
    set version=%%d
)

rem Replace dots by spaces "10 0 10586]".
set version=%version:.= %

rem Split the last part of the ver output "10 0 10586]" and keep the first
rem 2 values formatted with a dot as separator "10.0".
for /f "tokens=1,2,*" %%a in ("%version%") do (
    set version=%%a.%%b
)

rem TODO add check for other supported versions of Windows
rem Also see: https://en.wikipedia.org/wiki/Ver_(command)

if not "%version%" == "10.0" (
    echo Unsupported Windows version: %version%

    exit /b 1
)

for /f "delims=" %%i in ('dir "C:\Program Files (x86)\Windows Kits\10\bin" /b /s ^| findstr /i "\\x64\\vshadow.exe$"') do (
    set "VSHADOW_EXE=%%i"
)

if not exist "%VSHADOW_EXE%" (
    echo "Unable to locate vshadow.exe"
    exit /b 1
)

set specimenspath=specimens-redirected\%version%

if exist "%specimenspath%" (
    echo Specimens directory: %specimenspath% already exists.

    exit /b 1
)

mkdir "%specimenspath%"

rem Create 2 dynamic-size VHD images with a NTFS file system and unit size 512
set unitsize=512
set imagesize=128
set mainimagename=main_vss.vhd
set storageimagename=storage_vss.vhd

echo Creating: %mainimagename% and %storageimagename%

echo create vdisk file=%cd%\%specimenspath%\%mainimagename% maximum=%imagesize% type=expandable > CreateVHD.diskpart
echo select vdisk file=%cd%\%specimenspath%\%mainimagename% >> CreateVHD.diskpart
echo attach vdisk >> CreateVHD.diskpart
echo convert mbr >> CreateVHD.diskpart
echo create partition primary >> CreateVHD.diskpart
echo format fs=ntfs label="MainVolume" unit=%unitsize% quick >> CreateVHD.diskpart
echo assign letter=x >> CreateVHD.diskpart

echo create vdisk file=%cd%\%specimenspath%\%storageimagename% maximum=%imagesize% type=expandable >> CreateVHD.diskpart
echo select vdisk file=%cd%\%specimenspath%\%storageimagename% >> CreateVHD.diskpart
echo attach vdisk >> CreateVHD.diskpart
echo convert mbr >> CreateVHD.diskpart
echo create partition primary >> CreateVHD.diskpart
echo format fs=ntfs label="StorageVolume" unit=%unitsize% quick >> CreateVHD.diskpart
echo assign letter=y >> CreateVHD.diskpart

call :run_diskpart CreateVHD.diskpart

rem Ensure X: and Y: have some time to initialize
choice /t 5 /d y > nul

rem Note that not all versions of vssadmin support these commands
vssadmin delete shadowstorage /for=x: 2>nul
vssadmin add shadowstorage /for=x: /on=y: /maxsize=unbounded

vssadmin list shadowstorage

"%VSHADOW_EXE%" -p x:

call :create_test_file_entries x

"%VSHADOW_EXE%" -p x:

vssadmin list shadows

echo select vdisk file=%cd%\%specimenspath%\%mainimagename% > UnmountVHD.diskpart
echo detach vdisk >> UnmountVHD.diskpart
echo select vdisk file=%cd%\%specimenspath%\%storageimagename% >> UnmountVHD.diskpart
echo detach vdisk >> UnmountVHD.diskpart

call :run_diskpart UnmountVHD.diskpart

exit /b 0

rem Creates test file entries
:create_test_file_entries
SETLOCAL
SET driveletter=%1

rem Create an empty file
type nul >> %driveletter%:\emptyfile

rem Create a directory
mkdir %driveletter%:\testdir1

rem Create a file that can be stored as inline data
echo My file > %driveletter%:\testdir1\testfile1

rem Create a file that cannot be stored as inline data
copy LICENSE %driveletter%:\testdir1\TestFile2

rem Create a file with a long filename
type nul >> "%driveletter%:\My long, very long file name, so very long"

rem Create a hard link to a file
mklink /H %driveletter%:\file_hardlink1 %driveletter%:\testdir1\testfile1

rem Create a symbolic link to a file
mklink %driveletter%:\file_symboliclink1 %driveletter%:\testdir1\testfile1

rem Create a junction (hard link to a directory)
mklink /J %driveletter%:\directory_junction1 %driveletter%:\testdir1

rem Create a symbolic link to a directory
mklink /D %driveletter%:\directory_symboliclink1 %driveletter%:\testdir1

rem Create a file with an alternative data stream (ADS)
type nul >> %driveletter%:\file_ads1
echo My file ADS > %driveletter%:\file_ads1:myads

rem Create a directory with an alternative data stream (ADS)
mkdir %driveletter%:\directory_ads1
echo My directory ADS > %driveletter%:\directory_ads1:myads

rem Create a file with valid data size set
copy LICENSE %driveletter%:\testdir1\file_valid_data_size1
fsutil file setEOF %driveletter%:\testdir1\file_valid_data_size1 30000
fsutil file setValidData %driveletter%:\testdir1\file_valid_data_size1 18652

rem Create a file with short name set
echo My short file > %driveletter%:\testdir1\file_short_name1
fsutil file setShortName %driveletter%:\testdir1\file_short_name1 short1

rem Create a file with a sparse data run
copy LICENSE %driveletter%:\testdir1\file_sparse1
fsutil sparse setflag %driveletter%:\testdir1\file_sparse1
fsutil sparse setRange %driveletter%:\testdir1\file_sparse1 0 18000

rem Create a case-sensitive directory

ENDLOCAL
exit /b 0

rem Runs diskpart with a script
rem Note that diskpart requires Administrator privileges to run
:run_diskpart
SETLOCAL
set diskpartscript=%1

rem Note that diskpart requires Administrator privileges to run
diskpart /s %diskpartscript%

if %errorlevel% neq 0 (
    echo Failed to run: "diskpart /s %diskpartscript%"

    exit /b 1
)

del /q %diskpartscript%

rem Give the system a bit of time to adjust
choice /t 1 /d y > nul

ENDLOCAL
exit /b 0
