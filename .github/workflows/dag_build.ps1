# Define folder paths
$FolderName = ".\temp"
if (Test-Path $FolderName) {
    Write-Host "Folder Exists"
    Remove-Item $FolderName -Recurse -Force
}

# Create required directories
mkdir '.\temp\dna-datalake-airflow\dag' | Out-Null
mkdir '.\temp\dna-datalake-airflow\config' | Out-Null

# Copy all DAG files (unconditionally)
Write-Host "Copying DAG files..."
Copy-Item -Path ".\DAG\*" -Destination ".\temp\dna-datalake-airflow\dag" -Recurse

# Get list of changed files from the last commit
try {
    $changedFiles = git diff --name-only HEAD~1
    if ($changedFiles) {
        $changedFilesList = $changedFiles -split "`n"
        Write-Host "Changed files:"
        $changedFilesList | ForEach-Object { Write-Host "- $_" }
    } else {
        Write-Host "No changed files detected."
        $changedFilesList = @()
    }
} catch {
    Write-Host "Error detecting changes from the last commit. Skipping diff check."
    $changedFilesList = @()
}

# Always copy other config files
Write-Host "Copying other config files..."
Get-ChildItem -Path ".\config" | ForEach-Object {
    $fileName = $_.Name
    if ($fileName -eq "requirements.txt") {
        if ($changedFilesList -contains "config/requirements.txt") {
            Write-Host "Copying changed requirements.txt"
            Copy-Item -Path ".\config\requirements.txt" -Destination ".\temp\dna-datalake-airflow\config" -Force
        } else {
            Write-Host "Skipping requirements.txt (no changes)"
        }
    } else {
        # Always copy other config files
        Write-Host "Copying $fileName"
        Copy-Item -Path ".\config\$fileName" -Destination ".\temp\dna-datalake-airflow\config" -Force
    }
}

Write-Host "✅ Build completed!"
