Set-StrictMode -Version 2.0

$ErrorActionPreference = "Stop"

cd ~

iex (
    (New-Object System.Net.WebClient).
        DownloadString('https://chocolatey.org/install.ps1')
)

choco feature enable -n allowGlobalConfirmation

choco upgrade git
choco upgrade python3
# choco upgrade webexnetworkplayer `
#     --checksum '8A5BCA2515C46EF8C413B18FC7486CEFB36C0F558E071E086E02D86BF31271A1'
choco upgrade webexnetworkplayer --ignore-checksum

mkdir C:\ProgramData\WebEx\WebEx\500\plugin -ErrorAction 0
cp C:\vagrant\libfaac.dll C:\ProgramData\WebEx\WebEx\500\plugin\ -ErrorAction 0

# Make `refreshenv` available right away, by defining the
# $env:ChocolateyInstall variable and importing the Chocolatey profile module.
$env:ChocolateyInstall = Convert-Path "$((Get-Command choco).path)\..\.."
Import-Module "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"

# refreshenv is now an alias for Update-SessionEnvironment
# (rather than invoking refreshenv.cmd, the *batch file* for use with cmd.exe)
# This should make git.exe accessible via the refreshed $env:PATH, so that it can be
# called by name only.
refreshenv

$ErrorActionPreference = "Continue"
git clone --depth=1 https://github.com/elliot-labs/ARF-Converter.git 2>$null
$ErrorActionPreference = "Stop"
cd ARF-Converter
git pull
mkdir Converted -ErrorAction 0
