$FolderName = ".\temp"
if (Test-Path $FolderName) {
    Write-Host "Folder Exists"
    Remove-Item $FolderName -Recurse -Force
}

# Create folders
mkdir '.\temp\dna-datalake-airflow\dag' -Force
mkdir '.\temp\dna-datalake-airflow\config' -Force

# Read changed files
$changedFiles = Get-Content ".\changed_files.txt"
