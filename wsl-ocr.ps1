$winPath = Read-Host "Paste the Windows path (e.g., D:\some\folder)"
$winPath = $winPath.Trim('"').Trim()
$driveLetter = $winPath[0].ToString().ToLower()

$wslMountPoint = "/mnt/$(($driveLetter).ToLower())"

# The core WSL command string, enclosed in single quotes for PowerShell to pass literally
# Note: The $USER variable is a Linux environment variable, bash will interpret it.
# The `id -u $USER` and `id -g $USER` will be executed within WSL.
$mountCommand = "sudo mount -t drvfs ${driveLetter}: $wslMountPoint -o uid=`$(id -u $USER),gid=`$(id -g $USER),metadata"

wsl bash -c $mountCommand

$relativePath = $winPath.Substring(3).Replace('\', '/')

$path = "$wslMountPoint/$relativePath"

$lsOutput = wsl bash -c "ls -1F $path"

Write-Host $lsOutput

$parsedFiles = @() # Initialize an empty array to store parsed objects

foreach ($line in $lsOutput) {
    $line = $line.Trim() # Remove any leading/trailing whitespace


    if ([string]::IsNullOrWhiteSpace($line)) {
        continue # Skip empty lines
    }

    $isDir = $line.EndsWith("/")
    $fileName = $line

    $fileName = $line.TrimEnd('/') # Remove the trailing slash for the name property for directories
    $fileName = $line.TrimEnd('*') # Remove the trailing * for the name property for executables
    $isPdf = $fileName.ToLower() -like "*.pdf" -and !$isDir

    # Create a custom object for easier manipulation
    $parsedFiles += [PSCustomObject]@{
        Name        = $fileName
        IsPdf       = $isPdf
    }
}

$pdfFiles = $parsedFiles | Where-Object { $_.IsPdf}

Write-Host "`n---- Found .pdf Files ----"
if ($pdfFiles) {
    $pdfFiles | Format-Table -AutoSize
} else {
    Read-Host "No .pdf files found. Press any key to exit"
    exit
}
Write-Host "---------------------------"

foreach ($pdf in $pdfFiles) {
    Write-Host "Doing OCR for $($pdf.Name)"
    wsl bash -c "cd $path && ocrmypdf -q -l deu --deskew --clean-final --output-type pdfa $($pdf.Name) OCR_$($pdf.Name)"
}

Read-Host "All .pdf files OCR'd. Press any key to exit"
exit
