# Read the ADDED_FILES environment variable from GitHub
$addedFiles = $env:ADDED_FILES

# Print the added files to the console
Write-Host "Added Files:"
Write-Host $addedFiles