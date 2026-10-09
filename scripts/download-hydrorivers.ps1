$Url = "https://data.hydrosheds.org/file/HydroRIVERS/HydroRIVERS_v10_as_shp.zip"
$OutDir = Join-Path $PSScriptRoot "..\data\river_source"
$OutFile = Join-Path $OutDir "HydroRIVERS_v10_as_shp.zip"
New-Item -ItemType Directory -Force -Path $OutDir | Out-Null
Invoke-WebRequest -Uri $Url -OutFile $OutFile
Write-Host "Đã tải HydroRIVERS Asia Shapefile vào: $OutFile"
