$FolderName = ".\temp"
if (Test-Path $FolderName) {
    Write-Host "Folder Exists. Removing..."
    Remove-Item $FolderName -Recurse -Force
}

# Create new folders
Write-Host "Creating folder structure..."
mkdir '.\temp\dna-datalake-airflow\dag' -Force
mkdir '.\temp\dna-datalake-airflow\config' -Force

# Read added/modified files from environment variable
if ($env:ADDED_FILES -ne "[]") {
    Write-Host "`nAdded/Modified Files:"
    $env:ADDED_FILES | ConvertFrom-Json | ForEach-Object { Write-Host $_ }
} else {
    Write-Host "No added/modified files found."
}

# Print created folder structure (for debugging)
Write-Host "`n=== Folder Structure ==="
Get-ChildItem -Recurse .\temp
