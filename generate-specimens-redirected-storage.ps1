# Script to generate VSS redirected storage test files
# Requires Windows 10 / Server 2016 or later for advanced storage/case-sensitivity features.

. .\shared_windows.ps1

$ErrorActionPreference = "Stop"
$SpecimensPath = "specimens-redirected"

if (-not (Test-Path "${SpecimensPath}")) {
   New-Item -ItemType Directory -Path "${SpecimensPath}" | Out-Null
}

$ImageSize = 128

$MainImageName = "main_vss.vhd"
$MainImageFullPath = "${Pwd}\${SpecimensPath}\${MainImageName}"

Write-Host "Creating: ${MainImageName}" -foreground Yellow

CreateAndMountVhd -DriveLetter "X" -FileSystem "ntfs" -ImageFullPath ${MainImageFullPath} -ImageSize ${ImageSize} -ImageType "expandable"

$StorageImageName = "storage_vss.vhd"
$StorageImageFullPath = "${Pwd}\${SpecimensPath}\${StorageImageName}"

Write-Host "Creating: ${StorageImageName}" -foreground Yellow

CreateAndMountVhd -DriveLetter "Y" -FileSystem "ntfs" -ImageFullPath ${StorageImageFullPath} -ImageSize ${ImageSize} -ImageType "expandable"

Start-Sleep -Seconds 3

Invoke-CimMethod -ClassName Win32_ShadowStorage -MethodName Create -Arguments @{
    Volume     = "X:\"
    DiffVolume = "Y:\"
}

vssadmin list shadowstorage

$Shadow = Invoke-CimMethod -ClassName Win32_ShadowCopy -MethodName Create -Arguments @{
    Volume = "X:\"
}

CreateTestFileEntriesExtended -DriveLetter "X"

$Shadow = Invoke-CimMethod -ClassName Win32_ShadowCopy -MethodName Create -Arguments @{
    Volume = "X:\"
}

UnmountVhd -ImageFullPath ${MainImageFullPath}
UnmountVhd -ImageFullPath ${StorageImageFullPath}
