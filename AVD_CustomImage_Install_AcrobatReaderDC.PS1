<#
======================================================================================================
 
 Created on:    07.16.2024
 Created by:    Gian Mattia Lolli
 Version:       0.4
 Mail:          gianmattia.lolli@4wardpro.it
 
 Function:      Custom install wrapper for AVD Custom Image Templates
 
 Borrowed ideas and script parts from Travis Roberts https://github.com/tsrob50
 
 This script is provided As Is without any warranty
 Compatible with Windows 10 and later
======================================================================================================


Version 0.1 - 07.16.2024
	First Draft PoC
Version 0.4 - 07.17.2024
	Variables Rewrite



#>
$templateFilePathFolder = "C:\AVDImageSoftware"
$logFile = "$templateFilePathFolder\" + (get-date -format 'yyyyMMdd') + '_installation.log'
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
$LocalFilePath = "$templateFilePathFolder\AcroRdrDC2400220857_en_US.exe"
$CommandLineArgs = "/sAll /rs /rps /silent /norestart /msi DISABLE_ARM_SERVICE_INSTALL=1"
$LocalDetectionExe = "C:\Program Files\Adobe\Acrobat Reader DC\Reader\AcroRd32.exe"

Write-Log "Starting AVD CUSTOM IMAGE TEMPLATE - CUSTOM SOFTWARE INSTALLATION: $SoftwareName"
Write-host "Starting AVD CUSTOM IMAGE TEMPLATE - CUSTOM SOFTWARE INSTALLATION: $SoftwareName : $((Get-Date).ToUniversalTime()) "


# Local Folder creation
if (-Not (Test-Path -Path $templateFilePathFolder -ErrorAction SilentlyContinue)) {
    New-Item -Type Directory -Path $templateFilePathFolder | Out-Null
}

# Download Software
try {
    Write-Log "Downloading $SoftwareName from $DownloadLink"
    Write-host "AVD CUSTOM IMAGE TEMPLATE - Downloading $SoftwareName from $DownloadLink : $((Get-Date).ToUniversalTime()) "
    Invoke-WebRequest -Uri $DownloadLink -OutFile $LocalFilePath
    Write-Log "Downloaded $SoftwareName successfully."
    Write-host "AVD CUSTOM IMAGE TEMPLATE - Downloaded $SoftwareName successfully: $SoftwareName : $((Get-Date).ToUniversalTime()) "
}
catch {
    $ErrorMessage = $_.Exception.Message
    Write-Log "Error downloading $SoftwareName : $ErrorMessage"
    Write-host "AVD CUSTOM IMAGE TEMPLATE - Error downloading $SoftwareName : $SoftwareName : $((Get-Date).ToUniversalTime()) "
    exit 1
}

Set-Location $templateFilePathFolder

# Run Install Command
try {
   Start-Process -FilePath $LocalFilePath -Wait -ArgumentList $CommandLineArgs -Wait -Passthru
    if (Test-Path $LocalDetectionExe) {
        Write-Log "$SoftwareName has been installed successfully."
        Write-host "AVD CUSTOM IMAGE TEMPLATE - Installation Completed: $SoftwareName : $((Get-Date).ToUniversalTime()) "
    }
    else {
        Write-Log "Error detecting $SoftwareName after installation."
        Write-host "AVD CUSTOM IMAGE TEMPLATE - Error detecting $SoftwareName after installation: $SoftwareName : $((Get-Date).ToUniversalTime()) "
    }
}
catch {
    $ErrorMessage = $_.Exception.Message
    Write-Log "Error installing $SoftwareName : $ErrorMessage"
    Write-host "AVD CUSTOM IMAGE TEMPLATE - Error during Installation: $SoftwareName : $((Get-Date).ToUniversalTime()) "
    exit 1
}
