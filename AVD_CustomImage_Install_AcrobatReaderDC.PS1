<#
======================================================================================================
 
 Created on:    07.16.2024
 Created by:    Gian Mattia Lolli
 Version:       0.1
 Mail:          gianmattia.lolli@4wardpro.it
 
 Function:      Custom install wrapper for AVD Custom Image Templates
 
 Borrowed ideas and script parts from Travis Roberts https://github.com/tsrob50
 
 This script is provided As Is without any warranty
 Compatible with Windows 10 and later
======================================================================================================


Version 0.1 - 07.16.2024
First Draft PoC


#>

$logFile = "C:\AVDImageSoftware\" + (get-date -format 'yyyyMMdd') + '_installation.log'
function Write-Log {
    Param([string]$message)
    Write-Output "$(get-date -format 'yyyyMMdd HH:mm:ss') $message" | Out-File -Encoding utf8 $logFile -Append
}


<#
# First Concept: Download and install EXE or MSI, Concept:

======================================================================================================
									Adobe Acrobat Reader
======================================================================================================
#>

#Variables:
$SoftwareName = "Acrobat Reader"
$DownloadLink = "https://ardownload2.adobe.com/pub/adobe/reader/win/AcrobatDC/2400220857/AcroRdrDC2400220857_en_US.exe"
$LocalFilePath = "C:\\AVDImageSoftware\\AcroRdrDC2400220857_en_US.exe"
$CommandLineArgs = "/sAll /rs /rps /silent /norestart /msi DISABLE_ARM_SERVICE_INSTALL=1"
$LocalDetectionExe = "C:\Program Files\Adobe\Acrobat Reader DC\Reader\AcroRd32.exe"

# https://ardownload2.adobe.com/pub/adobe/acrobat/win/AcrobatDC/2400220857/AcroRdrDCx642400220857_MUI.exe


# Local Folder creation
if (-Not (Test-Path -Path "C:\AVDImageSoftware")) {
    New-Item -Type Directory -Path "C:\AVDImageSoftware" | Out-Null
}


# Download Software
try {
    Invoke-WebRequest -Uri $DownloadLink -OutFile $LocalFilePath -ErrorAction Stop
    Write-Log "Downloaded $SoftwareName successfully."
}
catch {
    $ErrorMessage = $_.Exception.Message
    Write-Log "Error downloading $SoftwareName : $ErrorMessage"
    exit 1
}

# Run Install Command
try {
   Start-Process -FilePath $LocalFilePath -Wait -ArgumentList $CommandLineArgs -ErrorAction Stop
    if (Test-Path $LocalDetectionExe) {
        Write-Log "$SoftwareName has been installed successfully."
    }
    else {
        Write-Log "Error detecting $SoftwareName after installation."
    }
}
catch {
    $ErrorMessage = $_.Exception.Message
    Write-Log "Error installing $SoftwareName : $ErrorMessage"
    exit 1
}
