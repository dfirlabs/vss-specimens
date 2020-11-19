@echo off

rem Script to generate VSS test files
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

set specimenspath=specimens\%version%

if exist "%specimenspath%" (
	echo Specimens directory: %specimenspath% already exists.

	exit /b 1
)

mkdir "%specimenspath%"

rem Supported diskpart format fs=<FS> options: ntfs, fat, fat32
rem Supported diskpart format unit=<N> options: 512, 1024, 2048, 4096 (default), 8192, 16K, 32K, 64K
rem unit=<N> values added in Windows 10 (1903): 128K, 256K, 512K, 1M, 2M

rem Create a fixed-size VHD image with a NTFS file system and unit size 512 and 2 volume snapshots
set unitsize=512
set imagename=ntfs_%unitsize%_with_2_vss.vhd
set imagesize=128

echo Creating: %imagename%

echo create vdisk file=%cd%\%specimenspath%\%imagename% maximum=%imagesize% type=fixed > CreateVHD.diskpart
echo select vdisk file=%cd%\%specimenspath%\%imagename% >> CreateVHD.diskpart
echo attach vdisk >> CreateVHD.diskpart
echo convert mbr >> CreateVHD.diskpart
echo create partition primary >> CreateVHD.diskpart

echo format fs=ntfs label="TestVolume" unit=%unitsize% quick >> CreateVHD.diskpart

echo assign letter=x >> CreateVHD.diskpart

call :run_diskpart CreateVHD.diskpart

call :create_test_file_entries x

for /l %%i in (1, 1, 2) do (
	"C:\Program Files (x86)\Windows Kits\10\bin\10.0.19041.0\x64\vshadow.exe" -p x:

	echo VSS%%i > x:\vss%%i
)

echo select vdisk file=%cd%\%specimenspath%\%imagename% > UnmountVHD.diskpart
echo detach vdisk >> UnmountVHD.diskpart

call :run_diskpart UnmountVHD.diskpart

rem Create a fixed-size VHD image with a NTFS file system and unit size 1024 and 2 volume snapshots
set unitsize=1024
set imagename=ntfs_%unitsize%_with_2_vss.vhd
set imagesize=128

echo Creating: %imagename%

echo create vdisk file=%cd%\%specimenspath%\%imagename% maximum=%imagesize% type=fixed > CreateVHD.diskpart
echo select vdisk file=%cd%\%specimenspath%\%imagename% >> CreateVHD.diskpart
echo attach vdisk >> CreateVHD.diskpart
echo convert mbr >> CreateVHD.diskpart
echo create partition primary >> CreateVHD.diskpart

echo format fs=ntfs label="TestVolume" unit=%unitsize% quick >> CreateVHD.diskpart

echo assign letter=x >> CreateVHD.diskpart

call :run_diskpart CreateVHD.diskpart

call :create_test_file_entries x

for /l %%i in (1, 1, 2) do (
	"C:\Program Files (x86)\Windows Kits\10\bin\10.0.19041.0\x64\vshadow.exe" -p x:

	echo VSS%%i > x:\vss%%i
)

echo select vdisk file=%cd%\%specimenspath%\%imagename% > UnmountVHD.diskpart
echo detach vdisk >> UnmountVHD.diskpart

call :run_diskpart UnmountVHD.diskpart

rem Create a fixed-size VHD image with a NTFS file system and unit size 2048 and 2 volume snapshots
set unitsize=2048
set imagename=ntfs_%unitsize%_with_2_vss.vhd
set imagesize=128

echo Creating: %imagename%

echo create vdisk file=%cd%\%specimenspath%\%imagename% maximum=%imagesize% type=fixed > CreateVHD.diskpart
echo select vdisk file=%cd%\%specimenspath%\%imagename% >> CreateVHD.diskpart
echo attach vdisk >> CreateVHD.diskpart
echo convert mbr >> CreateVHD.diskpart
echo create partition primary >> CreateVHD.diskpart

echo format fs=ntfs label="TestVolume" unit=%unitsize% quick >> CreateVHD.diskpart

echo assign letter=x >> CreateVHD.diskpart

call :run_diskpart CreateVHD.diskpart

call :create_test_file_entries x

for /l %%i in (1, 1, 2) do (
	"C:\Program Files (x86)\Windows Kits\10\bin\10.0.19041.0\x64\vshadow.exe" -p x:

	echo VSS%%i > x:\vss%%i
)

echo select vdisk file=%cd%\%specimenspath%\%imagename% > UnmountVHD.diskpart
echo detach vdisk >> UnmountVHD.diskpart

call :run_diskpart UnmountVHD.diskpart

rem Create a fixed-size VHD image with a NTFS file system and unit size 4096 and 2 volume snapshots
set unitsize=4096
set imagename=ntfs_%unitsize%_with_2_vss.vhd
set imagesize=128

echo Creating: %imagename%

echo create vdisk file=%cd%\%specimenspath%\%imagename% maximum=%imagesize% type=fixed > CreateVHD.diskpart
echo select vdisk file=%cd%\%specimenspath%\%imagename% >> CreateVHD.diskpart
echo attach vdisk >> CreateVHD.diskpart
echo convert mbr >> CreateVHD.diskpart
echo create partition primary >> CreateVHD.diskpart

echo format fs=ntfs label="TestVolume" unit=%unitsize% quick >> CreateVHD.diskpart

echo assign letter=x >> CreateVHD.diskpart

call :run_diskpart CreateVHD.diskpart

call :create_test_file_entries x

for /l %%i in (1, 1, 2) do (
	"C:\Program Files (x86)\Windows Kits\10\bin\10.0.19041.0\x64\vshadow.exe" -p x:

	echo VSS%%i > x:\vss%%i
)

echo select vdisk file=%cd%\%specimenspath%\%imagename% > UnmountVHD.diskpart
echo detach vdisk >> UnmountVHD.diskpart

call :run_diskpart UnmountVHD.diskpart

rem Create a fixed-size VHD image with a NTFS file system and unit size 8192 and 2 volume snapshots
set unitsize=8192
set imagename=ntfs_%unitsize%_with_2_vss.vhd
set imagesize=128

echo Creating: %imagename%

echo create vdisk file=%cd%\%specimenspath%\%imagename% maximum=%imagesize% type=fixed > CreateVHD.diskpart
echo select vdisk file=%cd%\%specimenspath%\%imagename% >> CreateVHD.diskpart
echo attach vdisk >> CreateVHD.diskpart
echo convert mbr >> CreateVHD.diskpart
echo create partition primary >> CreateVHD.diskpart

echo format fs=ntfs label="TestVolume" unit=%unitsize% quick >> CreateVHD.diskpart

echo assign letter=x >> CreateVHD.diskpart

call :run_diskpart CreateVHD.diskpart

call :create_test_file_entries x

for /l %%i in (1, 1, 2) do (
	"C:\Program Files (x86)\Windows Kits\10\bin\10.0.19041.0\x64\vshadow.exe" -p x:

	echo VSS%%i > x:\vss%%i
)

echo select vdisk file=%cd%\%specimenspath%\%imagename% > UnmountVHD.diskpart
echo detach vdisk >> UnmountVHD.diskpart

call :run_diskpart UnmountVHD.diskpart

rem Create a fixed-size VHD image with a NTFS file system and unit size 16K and 2 volume snapshots
set unitsize=16k
set imagename=ntfs_%unitsize%_with_2_vss.vhd
set imagesize=128

echo Creating: %imagename%

echo create vdisk file=%cd%\%specimenspath%\%imagename% maximum=%imagesize% type=fixed > CreateVHD.diskpart
echo select vdisk file=%cd%\%specimenspath%\%imagename% >> CreateVHD.diskpart
echo attach vdisk >> CreateVHD.diskpart
echo convert mbr >> CreateVHD.diskpart
echo create partition primary >> CreateVHD.diskpart

echo format fs=ntfs label="TestVolume" unit=%unitsize% quick >> CreateVHD.diskpart

echo assign letter=x >> CreateVHD.diskpart

call :run_diskpart CreateVHD.diskpart

call :create_test_file_entries x

for /l %%i in (1, 1, 2) do (
	"C:\Program Files (x86)\Windows Kits\10\bin\10.0.19041.0\x64\vshadow.exe" -p x:

	echo VSS%%i > x:\vss%%i
)

echo select vdisk file=%cd%\%specimenspath%\%imagename% > UnmountVHD.diskpart
echo detach vdisk >> UnmountVHD.diskpart

call :run_diskpart UnmountVHD.diskpart

rem Create a fixed-size VHD image with a NTFS file system and unit size 32K and 2 volume snapshots
set unitsize=32k
set imagename=ntfs_%unitsize%_with_2_vss.vhd
set imagesize=128

echo Creating: %imagename%

echo create vdisk file=%cd%\%specimenspath%\%imagename% maximum=%imagesize% type=fixed > CreateVHD.diskpart
echo select vdisk file=%cd%\%specimenspath%\%imagename% >> CreateVHD.diskpart
echo attach vdisk >> CreateVHD.diskpart
echo convert mbr >> CreateVHD.diskpart
echo create partition primary >> CreateVHD.diskpart

echo format fs=ntfs label="TestVolume" unit=%unitsize% quick >> CreateVHD.diskpart

echo assign letter=x >> CreateVHD.diskpart

call :run_diskpart CreateVHD.diskpart

call :create_test_file_entries x

for /l %%i in (1, 1, 2) do (
	"C:\Program Files (x86)\Windows Kits\10\bin\10.0.19041.0\x64\vshadow.exe" -p x:

	echo VSS%%i > x:\vss%%i
)

echo select vdisk file=%cd%\%specimenspath%\%imagename% > UnmountVHD.diskpart
echo detach vdisk >> UnmountVHD.diskpart

call :run_diskpart UnmountVHD.diskpart

rem Create a fixed-size VHD image with a NTFS file system and unit size 64K and 2 volume snapshots
set unitsize=64k
set imagename=ntfs_%unitsize%_with_2_vss.vhd
set imagesize=128

echo Creating: %imagename%

echo create vdisk file=%cd%\%specimenspath%\%imagename% maximum=%imagesize% type=fixed > CreateVHD.diskpart
echo select vdisk file=%cd%\%specimenspath%\%imagename% >> CreateVHD.diskpart
echo attach vdisk >> CreateVHD.diskpart
echo convert mbr >> CreateVHD.diskpart
echo create partition primary >> CreateVHD.diskpart

echo format fs=ntfs label="TestVolume" unit=%unitsize% quick >> CreateVHD.diskpart

echo assign letter=x >> CreateVHD.diskpart

call :run_diskpart CreateVHD.diskpart

call :create_test_file_entries x

for /l %%i in (1, 1, 2) do (
	"C:\Program Files (x86)\Windows Kits\10\bin\10.0.19041.0\x64\vshadow.exe" -p x:

	echo VSS%%i > x:\vss%%i
)

echo select vdisk file=%cd%\%specimenspath%\%imagename% > UnmountVHD.diskpart
echo detach vdisk >> UnmountVHD.diskpart

call :run_diskpart UnmountVHD.diskpart

rem Create a fixed-size VHD image with a NTFS file system and unit size 128K and 2 volume snapshots
set unitsize=128k
set imagename=ntfs_%unitsize%_with_2_vss.vhd
set imagesize=128

echo Creating: %imagename%

echo create vdisk file=%cd%\%specimenspath%\%imagename% maximum=%imagesize% type=fixed > CreateVHD.diskpart
echo select vdisk file=%cd%\%specimenspath%\%imagename% >> CreateVHD.diskpart
echo attach vdisk >> CreateVHD.diskpart
echo convert mbr >> CreateVHD.diskpart
echo create partition primary align=128 >> CreateVHD.diskpart

echo format fs=ntfs label="TestVolume" unit=%unitsize% quick >> CreateVHD.diskpart

echo assign letter=x >> CreateVHD.diskpart

call :run_diskpart CreateVHD.diskpart

call :create_test_file_entries x

for /l %%i in (1, 1, 2) do (
	"C:\Program Files (x86)\Windows Kits\10\bin\10.0.19041.0\x64\vshadow.exe" -p x:

	echo VSS%%i > x:\vss%%i
)

echo select vdisk file=%cd%\%specimenspath%\%imagename% > UnmountVHD.diskpart
echo detach vdisk >> UnmountVHD.diskpart

call :run_diskpart UnmountVHD.diskpart

rem Create a fixed-size VHD image with a NTFS file system and unit size 256K and 2 volume snapshots
set unitsize=256k
set imagename=ntfs_%unitsize%_with_2_vss.vhd
set imagesize=128

echo Creating: %imagename%

echo create vdisk file=%cd%\%specimenspath%\%imagename% maximum=%imagesize% type=fixed > CreateVHD.diskpart
echo select vdisk file=%cd%\%specimenspath%\%imagename% >> CreateVHD.diskpart
echo attach vdisk >> CreateVHD.diskpart
echo convert mbr >> CreateVHD.diskpart
echo create partition primary align=256 >> CreateVHD.diskpart

echo format fs=ntfs label="TestVolume" unit=%unitsize% quick >> CreateVHD.diskpart

echo assign letter=x >> CreateVHD.diskpart

call :run_diskpart CreateVHD.diskpart

call :create_test_file_entries x

for /l %%i in (1, 1, 2) do (
	"C:\Program Files (x86)\Windows Kits\10\bin\10.0.19041.0\x64\vshadow.exe" -p x:

	echo VSS%%i > x:\vss%%i
)

echo select vdisk file=%cd%\%specimenspath%\%imagename% > UnmountVHD.diskpart
echo detach vdisk >> UnmountVHD.diskpart

call :run_diskpart UnmountVHD.diskpart

rem Create a fixed-size VHD image with a NTFS file system and unit size 512K and 2 volume snapshots
set unitsize=512k
set imagename=ntfs_%unitsize%_with_2_vss.vhd
set imagesize=128

echo Creating: %imagename%

echo create vdisk file=%cd%\%specimenspath%\%imagename% maximum=%imagesize% type=fixed > CreateVHD.diskpart
echo select vdisk file=%cd%\%specimenspath%\%imagename% >> CreateVHD.diskpart
echo attach vdisk >> CreateVHD.diskpart
echo convert mbr >> CreateVHD.diskpart
echo create partition primary align=512 >> CreateVHD.diskpart

echo format fs=ntfs label="TestVolume" unit=%unitsize% quick >> CreateVHD.diskpart

echo assign letter=x >> CreateVHD.diskpart

call :run_diskpart CreateVHD.diskpart

call :create_test_file_entries x

for /l %%i in (1, 1, 2) do (
	"C:\Program Files (x86)\Windows Kits\10\bin\10.0.19041.0\x64\vshadow.exe" -p x:

	echo VSS%%i > x:\vss%%i
)

echo select vdisk file=%cd%\%specimenspath%\%imagename% > UnmountVHD.diskpart
echo detach vdisk >> UnmountVHD.diskpart

call :run_diskpart UnmountVHD.diskpart

rem Create a fixed-size VHD image with a NTFS file system and unit size 1M and 2 volume snapshots
set unitsize=1m
set imagename=ntfs_%unitsize%_with_2_vss.vhd
set imagesize=128

echo Creating: %imagename%

echo create vdisk file=%cd%\%specimenspath%\%imagename% maximum=%imagesize% type=fixed > CreateVHD.diskpart
echo select vdisk file=%cd%\%specimenspath%\%imagename% >> CreateVHD.diskpart
echo attach vdisk >> CreateVHD.diskpart
echo convert mbr >> CreateVHD.diskpart
echo create partition primary align=1024 >> CreateVHD.diskpart

echo format fs=ntfs label="TestVolume" unit=1024k quick >> CreateVHD.diskpart

echo assign letter=x >> CreateVHD.diskpart

call :run_diskpart CreateVHD.diskpart

call :create_test_file_entries x

for /l %%i in (1, 1, 2) do (
	"C:\Program Files (x86)\Windows Kits\10\bin\10.0.19041.0\x64\vshadow.exe" -p x:

	echo VSS%%i > x:\vss%%i
)

echo select vdisk file=%cd%\%specimenspath%\%imagename% > UnmountVHD.diskpart
echo detach vdisk >> UnmountVHD.diskpart

call :run_diskpart UnmountVHD.diskpart

rem Create a fixed-size VHD image with a NTFS file system and unit size 2M and 2 volume snapshots
set unitsize=2m
set imagename=ntfs_%unitsize%_with_2_vss.vhd
set imagesize=128

echo Creating: %imagename%

echo create vdisk file=%cd%\%specimenspath%\%imagename% maximum=%imagesize% type=fixed > CreateVHD.diskpart
echo select vdisk file=%cd%\%specimenspath%\%imagename% >> CreateVHD.diskpart
echo attach vdisk >> CreateVHD.diskpart
echo convert mbr >> CreateVHD.diskpart
echo create partition primary align=2048 >> CreateVHD.diskpart

echo format fs=ntfs label="TestVolume" unit=2048k quick >> CreateVHD.diskpart

echo assign letter=x >> CreateVHD.diskpart

call :run_diskpart CreateVHD.diskpart

call :create_test_file_entries x

for /l %%i in (1, 1, 2) do (
	"C:\Program Files (x86)\Windows Kits\10\bin\10.0.19041.0\x64\vshadow.exe" -p x:

	echo VSS%%i > x:\vss%%i
)

echo select vdisk file=%cd%\%specimenspath%\%imagename% > UnmountVHD.diskpart
echo detach vdisk >> UnmountVHD.diskpart

call :run_diskpart UnmountVHD.diskpart

rem Create a fixed-size VHD image with a NTFS file system 30 volume snapshots
set unitsize=4096
set imagename=ntfs_with_30_vss.vhd
set imagesize=256

echo Creating: %imagename%

echo create vdisk file=%cd%\%specimenspath%\%imagename% maximum=%imagesize% type=fixed > CreateVHD.diskpart
echo select vdisk file=%cd%\%specimenspath%\%imagename% >> CreateVHD.diskpart
echo attach vdisk >> CreateVHD.diskpart
echo convert mbr >> CreateVHD.diskpart
echo create partition primary >> CreateVHD.diskpart

echo format fs=ntfs label="TestVolume" unit=%unitsize% quick >> CreateVHD.diskpart

echo assign letter=x >> CreateVHD.diskpart

call :run_diskpart CreateVHD.diskpart

call :create_test_file_entries x

for /l %%i in (1, 1, 30) do (
	"C:\Program Files (x86)\Windows Kits\10\bin\10.0.19041.0\x64\vshadow.exe" -p x:

	echo VSS%%i > x:\vss%%i
)

echo select vdisk file=%cd%\%specimenspath%\%imagename% > UnmountVHD.diskpart
echo detach vdisk >> UnmountVHD.diskpart

call :run_diskpart UnmountVHD.diskpart

exit /b 0

rem Creates test file entries
:create_test_file_entries
SETLOCAL
SET driveletter=%1

rem Create an emtpy file
type nul >> %driveletter%:\emptyfile

rem Create a directory
mkdir %driveletter%:\testdir1

rem Create a file
echo My file > %driveletter%:\testdir1\testfile1

rem Create a hard link to a file
mklink /H %driveletter%:\file_hardlink1 %driveletter%:\testdir1\testfile1

rem Create a symbolic link to a file
mklink %driveletter%:\file_symboliclink1 %driveletter%:\testdir1\testfile1

rem Create a junction (hard link to a directory)
mklink /J %driveletter%:\directory_junction1 %driveletter%:\testdir1

rem Create a symbolic link to a directory
mklink /D %driveletter%:\directory_symboliclink1 %driveletter%:\testdir1

rem Create a file with an altenative data stream (ADS)
type nul >> %driveletter%:\ads1
echo My ADS > %driveletter%:\ads1:myads

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
timeout /t 1 > nul

ENDLOCAL
exit /b 0

