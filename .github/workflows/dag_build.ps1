$FolderName = ".\temp"
if (Test-Path $FolderName) {
    Write-Host "Folder Exists. Removing..."
    Remove-Item $FolderName -Recurse -Force
}

# Create new folders
Write-Host "Creating folder structure..."
mkdir '.\temp\dna-datalake-airflow\dag' -Force
mkdir '.\temp\dna-datalake-airflow\config' -Force

Write-Host "ADDED_FILES content: $env:ADDED_FILES"
