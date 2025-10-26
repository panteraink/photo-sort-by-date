Add-Type -AssemblyName System.Windows.Forms

$DateDirFormat = "`%Y/`%Y-`%m-`%d"

#dummy form for bringing folder dialogs to front 
$ownerForm = New-Object System.Windows.Forms.Form -Property @{TopMost = $true}

#asking for source folder
$CameraFolder = New-Object System.Windows.Forms.FolderBrowserDialog -Property @{
    RootFolder = [System.Environment+SpecialFolder]'MyComputer'
    Description = 'Select directory with photos'
}
[void]$CameraFolder.ShowDialog($ownerForm)
if ([string]::IsNullOrEmpty($CameraFolder.SelectedPath)) {
    exit
}

#asking for destenation folder
$StorageFolder = New-Object System.Windows.Forms.FolderBrowserDialog -Property @{
    RootFolder = [System.Environment+SpecialFolder]'MyComputer'
    Description = 'Select directory for storing photos'
}
[void]$StorageFolder.ShowDialog($ownerForm)
if ([string]::IsNullOrEmpty($StorageFolder.SelectedPath)) {
    exit
}

#asking for file type
$CameraBrand = Read-Host "Input camera brand:`n`t1 for old Canon`n`t3 for new Canon`n`t3 for Nikon`n`t4 for Samsung"
switch ($CameraBrand) {
    1 {
        $Fileformat = "cr2"
        break
    }
    2 {
        $Fileformat = "cr3"
        break
    }
    3 {
        $Fileformat = "nef"
        break
    }
    4 {
        $Fileformat = "srw"
        break
    }
    default {
        Write-Host "Please enter valid variant"
    }
}

#Write-Host $CameraFolder.SelectedPath $StorageFolder.SelectedPath $FileFormat

#running scrip for copying and creating folder structure
Get-ChildItem -Path "$($CameraFolder.SelectedPath)" -Recurse -File -Filter "*.$Fileformat" | ForEach-Object {
    exiftool -o . -d "$($StorageFolder.SelectedPath)\$DateDirFormat" "-directory<datetimeoriginal" $_.FullName
}