$FolderName = ".\temp"
if (Test-Path $FolderName) {
    Write-Host "Folder Exists"
    Remove-Item $FolderName  -Recurse -Force
}
mkdir '.\temp\dna-datalake-airflow\dag'
mkdir '.\temp\dna-datalake-airflow\config'
Copy-Item -Path ".\DAG\*" -Destination ".\temp\dna-datalake-airflow\dag" -Recurse
Copy-Item -Path ".\config\*" -Destination ".\temp\dna-datalake-airflow\config" -Recurse