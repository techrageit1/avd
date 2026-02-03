# Install DRMM
$drmmDownloadUrl = "https://vidal.rmm.datto.com/download-agent/windows/c33c8241-3c7d-4340-814e-ec791f7399d7"
$drmmDestination = "$env:TEMP/AgentInstall.exe"

# Download the file
Invoke-WebRequest -Uri $drmmDownloadUrl -OutFile $drmmDestination

# Start the process and wait for it to finish
Start-Process -FilePath $drmmDestination

Start-Sleep -Seconds 20

# Confirm
Write-Host ""
Write-Host "DRMM installation complete."

# Define Paths
$FslogixUrl = "https://aka.ms/fslogix_download"
$FslogixZip = "C:\Temp\FSLogix.zip"
$FslogixExtractPath = "C:\Temp\FSLogix"
$FslogixInstaller = "C:\Temp\FSLogix\x64\Release\FSLogixAppsSetup.exe"

# Download FSLogix
Write-Host "Downloading FSLogix..."
Invoke-WebRequest -Uri $FslogixUrl -OutFile $FslogixZip
Expand-Archive -Path $FslogixZip -DestinationPath $FslogixExtractPath

# Install FSLogix Silently
Write-Host ""
Write-Host "Installing FSLogix..."
Start-Process -FilePath $FslogixInstaller -ArgumentList "/quiet /norestart" -Wait

# Configure FSLogix Registry Keys
Write-Host ""
Write-Host "Configuring FSLogix Registry Settings..."

$RegistryPath = "HKLM:\SOFTWARE\FSLogix\Profiles"

# Ensure FSLogix registry path exists
if (!(Test-Path $RegistryPath)) {
    New-Item -Path $RegistryPath -Force | Out-Null
}

# Registry Settings
Set-ItemProperty -Path "HKLM:\SOFTWARE\FSLogix\Profiles" -Name "DeleteLocalProfileWhenVHDShouldApply" -Type DWord -Value 1
Set-ItemProperty -Path "HKLM:\SOFTWARE\FSLogix\Profiles" -Name "RoamIdentity" -Type DWord -Value 1
Set-ItemProperty -Path "HKLM:\SOFTWARE\FSLogix\Profiles" -Name "FlipFlopProfileDirectoryName" -Type DWord -Value 0
Set-ItemProperty -Path "HKLM:\SOFTWARE\FSLogix\Profiles" -Name "PreventLoginWithFailure" -Type DWord -Value 1
Set-ItemProperty -Path "HKLM:\SOFTWARE\FSLogix\Profiles" -Name "PreventLoginWithTempProfile" -Type DWord -Value 1
Set-ItemProperty -Path "HKLM:\SOFTWARE\FSLogix\Profiles" -Name "SizeInMBs" -Type DWord -Value 150000
Set-ItemProperty -Path "HKLM:\SOFTWARE\FSLogix\Profiles" -Name "VolumeType" -Type String -Value "vhdx"
Set-ItemProperty -Path "HKLM:\SOFTWARE\FSLogix\Profiles" -Name "VHDLocations" -Type String -Value "\\picstorage02.file.core.windows.net\fslogixprofileshare02"
Set-ItemProperty -Path "HKLM:\SOFTWARE\FSLogix\Profiles" -Name "Enabled" -Type DWord -Value 1
Set-ItemProperty -Path "HKLM:\SOFTWARE\FSLogix\Profiles" -Name "OutlookCachedMode" -Type DWord -Value 1

Write-Host ""
Write-Host "FSLogix registry configuration complete."

# Confirm
Write-Host ""
Write-Host "FSLogix installation and configuration complete."
