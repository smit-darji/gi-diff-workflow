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

# Fetch Git history to avoid missing refs
Write-Host "Fetching Git history..."
git fetch --all --quiet

# Check if origin/Master exists without failing on error
try {
    $baseRef = git rev-parse --verify origin/Master 2>$null
    if ($baseRef) {
        $changedFiles = git diff --name-only origin/Master...HEAD
        Write-Host "Changed files: $changedFiles"
    } else {
        Write-Host "Base ref 'origin/Master' not found. Skipping diff check."
        $changedFiles = @()
    }
} catch {
    Write-Host "Error checking origin/Master. Skipping diff check."
    $changedFiles = @()
}

# Always copy other config files
Write-Host "Copying other config files..."
Get-ChildItem -Path ".\config" | ForEach-Object {
    $fileName = $_.Name
    if ($fileName -eq "requirements.txt") {
        # Only copy if changed
        if ($changedFiles -contains "config/requirements.txt") {
            Write-Host "Copying changed requirements.txt"
            Copy-Item -Path ".\config\requirements.txt" -Destination ".\temp\dna-datalake-airflow\config" -Force
        } else {
            Write-Host "Skipping requirements.txt (no changes)"
        }
    } else {
        # Always copy other files
        Write-Host "Copying $fileName"
        Copy-Item -Path ".\config\$fileName" -Destination ".\temp\dna-datalake-airflow\config" -Force
    }
}

Write-Host "✅ Build completed!"
