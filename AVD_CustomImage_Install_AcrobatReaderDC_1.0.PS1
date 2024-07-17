<#
======================================================================================================
 
 Created on:    07.16.2024
 Created by:    Gian Mattia Lolli
 Version:       0.6
 Mail:          gianmattia.lolli@4wardpro.it
 
 Function:      Custom install wrapper for AVD Custom Image Templates
 
 Borrowed ideas and script parts from Travis Roberts https://github.com/tsrob50
 
 This script is provided As Is without any warranty
 Compatible with Windows 10 and later
======================================================================================================


Version 0.1 - 07.16.2024
	First Draft PoC
Version 1.0 - 07.17.2024
	Variables Rewrite
	Bugfixing


#>

<#
# First Concept: Download and install EXE or MSI, Concept:

======================================================================================================
									Adobe Acrobat Reader
======================================================================================================
#>

#Variables:
$templateFilePathFolder = "C:\AVDImageSoftware"
$SoftwareName = "Acrobat Reader"
$DownloadLink = "https://ardownload2.adobe.com/pub/adobe/reader/win/AcrobatDC/2400220857/AcroRdrDC2400220857_en_US.exe"
$LocalFilePath = "$templateFilePathFolder\AcroRdrDC2400220857_en_US.exe"
$CommandLineArgs = "/sAll /rs /rps /silent /norestart /msi DISABLE_ARM_SERVICE_INSTALL=1"
$LocalDetectionExe = "C:\Program Files\Adobe\Acrobat Reader DC\Reader\AcroRd32.exe"

Write-host "Starting AVD CUSTOM IMAGE TEMPLATE - CUSTOM SOFTWARE INSTALLATION $SoftwareName $((Get-Date).ToUniversalTime()) "

# Local Folder creation
if (-Not (Test-Path -Path $templateFilePathFolder -ErrorAction SilentlyContinue)) {
    New-Item -Type Directory -Path $templateFilePathFolder | Out-Null
}

# Download Software
try {
    Write-host "AVD CUSTOM IMAGE TEMPLATE - Downloading from $DownloadLink $((Get-Date).ToUniversalTime()) "
    Invoke-WebRequest -Uri $DownloadLink -OutFile $LocalFilePath
    Write-host "AVD CUSTOM IMAGE TEMPLATE - Downloaded successfully $((Get-Date).ToUniversalTime()) "
}
catch {
    $ErrorMessage = $_.Exception.Message
    Write-host "AVD CUSTOM IMAGE TEMPLATE - Error downloading $SoftwareName $((Get-Date).ToUniversalTime()) "
    exit 1
}

Set-Location $templateFilePathFolder

# Run Install Command
try {
   Start-Process -FilePath $LocalFilePath -ArgumentList $CommandLineArgs -Wait -Passthru
}
catch {
    $ErrorMessage = $_.Exception.Message
    Write-host "AVD CUSTOM IMAGE TEMPLATE - Error during Installation $SoftwareName $((Get-Date).ToUniversalTime()) "
    Write-host "AVD CUSTOM IMAGE TEMPLATE - $ErrorMessage $((Get-Date).ToUniversalTime()) "
    exit 1
}
