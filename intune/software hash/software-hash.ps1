# Paths to the 'Program Files' and 'Program Files (x86)' directories
$directories = @(
    "${env:ProgramFiles}", # Default Program Files directory
    "${env:ProgramFiles(x86)}" # Program Files (x86) directory for 32-bit applications on 64-bit systems
)

# Define the output file where hashes and paths of executables will be saved
$outputFile = "C:\Users\youruser\Desktop\software_hashes.txt"

# Create or clear the output file
if (Test-Path $outputFile) {
    Clear-Content $outputFile
} else {
    New-Item -ItemType File -Path $outputFile
}

# Function to process each executable file, compute the hash, write to the output file, and include the file path
function Process-File($file) {
    # Compute the SHA256 hash of the file
    $hash = Get-FileHash -Path $file.FullName -Algorithm SHA256

    # Verbose output to console
    Write-Host "Processing $($file.Name): Hash = $($hash.Hash)"

    # Write the hash and full file path to the output file
    "$($hash.Hash), $($file.FullName)" | Out-File -FilePath $outputFile -Append
}

# Iterate over each directory
foreach ($directory in $directories) {
    # Check if directory exists
    if (Test-Path $directory) {
        Write-Host "Processing directory: $directory"
        # Iterate over all executable files in the directory and its subdirectories
        Get-ChildItem -Path $directory -Recurse -File | Where-Object { $_.Extension -eq ".exe" } | ForEach-Object {
            Process-File $_
        }
    } else {
        Write-Host "Directory not found: $directory"
    }
}

Write-Host "Hashes and paths of executables have been saved to $outputFile"
