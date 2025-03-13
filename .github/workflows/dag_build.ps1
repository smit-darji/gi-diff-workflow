# Read FILE_MODIFIED from GitHub environment
$fileModified = $env:FILE_MODIFIED

if ($fileModified -eq 'true') {
    Write-Host "config/requirements_2.7.2.txt is modified"
} else {
    Write-Host "config/requirements_2.7.2.txt is not modified"
}

$FolderName = ".\temp"
if (Test-Path $FolderName) {
    Write-Host "Folder Exists"
    Remove-Item $FolderName -Recurse -Force
}

# Create required directories
mkdir '.\temp\dna-datalake-airflow\dag'
mkdir '.\temp\dna-datalake-airflow\config'

# Copy DAG files to destination
Copy-Item -Path ".\DAG\*" -Destination ".\temp\dna-datalake-airflow\dag" -Recurse

# Get list of all files in config folder
$configFiles = Get-ChildItem -Path ".\config" -File

foreach ($file in $configFiles) {
    if ($file.Name -eq 'requirements_2.7.2.txt' -and $fileModified -ne 'true') {
        Write-Host "Skipping unmodified file: $($file.Name)"
        continue
    }
    Write-Host "Copying file: $($file.Name)"
    Copy-Item -Path $file.FullName -Destination ".\temp\dna-datalake-airflow\config"
}

Write-Host "Build completed"