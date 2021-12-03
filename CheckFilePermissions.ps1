# CheckPermissions.ps1

# Enter username here, either by promt or defining the var in the doc of doing so by Input
# $user = Read-Host "Input the sAMAccountName of user"
$User = "John"
# Enter the starting directory here, either by promt or defining the var in the doc of doing so by Input
# $user = Read-Host "Input the sAMAccountName of user"
$startingDir= "C:\Users\"
# Location of the file where we will save all the wrong files. It must be created before the file execution
$outdoc = "CheckPermissionsOutput.txt" 

# Counters of control and to show the final result
$filesProcessed = 0
$filesOk = 0
$filesBad = 0

# Clear the content from the outdoc file
Clear-Content $outdoc

foreach ($file in $(Get-ChildItem $startingDir -recurse)) {

    $permission = (Get-Acl $file.fullname).Access | Where-Object{$_.IdentityReference -match $user} | Select-Object IdentityRefernce, FileSystemRights
    $actual = $file.fullname
    if ($permission) {
        $filesProcessed++
        $filesOk++
    }
    Else {
        $filesProcessed++
        $filesBad++
        Write-Host "$user no tiene permisos en $file"
        Write-Output $actual | Add-Content -Path $outdoc
    }
}
Write-Output "Processed files: $filesProcessed"
Write-Output "Amount of files with the right permissions: $filesOk"
Write-Output "Amount of files with the wrong permissions: $filesBad"
# We add this pause so we can read the output of the results, in case we don't launch the script from a ps console
pause 
