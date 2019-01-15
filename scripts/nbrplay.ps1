Set-StrictMode -Version 2.0

$ErrorActionPreference = "Stop"

cd ~\ARF-Converter

rm *.arf
rm Converted\*.mp4
git clean -f

cp C:\vagrant\input\*.arf .
& { echo '1'; echo 'N'; } | python 'AutoConvert.py'

rm *.arf
mv -Force Converted\*.mp4 C:\vagrant\output
git clean -f
