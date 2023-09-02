function RegSet {
    param (
        $RegPath,
        $RegKey,
        $RegKeyType,
        $RegKeyValue
    )
    $Elements = $RegPath -split "\\"
    $RegPath = ""
    $First = $true
    foreach ($Element in $Elements) {
        if($First) {
            $First = $false
        }
        else {
            $RegPath += "\"
        }
        $RegPath += $Element
        if( -not (Test-Path $RegPath) ) {
            mkdir $RegPath
        }
    }

    $Result = Get-ItemProperty $RegPath -Name $RegKey -ErrorAction SilentlyContinue
    if ($null -ne $Result) {
        Set-ItemProperty $RegPath -Name $RegKey -Value $RegKeyValue
    }
    else {
        New-ItemProperty $RegPath -Name $RegKey -PropertyType $RegKeyType -Value $RegKeyValue
    }
}

# Backup registry file
REG EXPORT "HKCR" $HOME\reg_hkcr_backup.reg
REG EXPORT "HKCU" $HOME\reg_hkcu_backup.reg
REG EXPORT "HKLM" $HOME\reg_hklm_backup.reg

# Enable Key assignment
RegSet "HKCU:\Software\Microsoft\IME\15.0\IMEJP\MSIME" "IsKeyAssignmentEnabled" 'DWord' 1

# Assign IME off to Muhenkan key
RegSet "HKCU:\Software\Microsoft\IME\15.0\IMEJP\MSIME" "KeyAssignmentMuhenkan" 'DWord' 1

# Hide Recycle bin on Desktop
RegSet "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" "{645FF040-5081-101B-9F08-00AA002F954E}" 'DWord' 1

# Remove Searchbox from Taskbar
RegSet "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search" "SearchboxTaskbarMode" 'DWord' 0

# Remoce Task View Button from Taskbar
RegSet "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "ShowTaskViewButton" 'DWord' 0

# Remove Chat from Taskbar
RegSet "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "TaskbarMn" 'DWord' 0

# Remove Widget from Taskbar
RegSet "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "TaskbarDa" 'DWord' 0

# Hide Frequent folder
RegSet "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer" "ShowFrequent" 'DWord' 0

# Hide Recent file
RegSet "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer" "ShowRecent" 'DWord' 0

# Show Drives with no media
RegSet "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "HideDrivesWithNoMedia" 'DWord' 0

# Show Hidden file
RegSet "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "Hidden" 'DWord' 1

# Show file extensions
RegSet "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "HideFileExt" 'DWord' 0

# Show All folders in Navigation pane
RegSet "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "NavPaneShowAllFolders" 'DWord' 1

# Hide Most Used Apps
RegSet "HKCU:\Software\Microsoft\Windows\CurrentVersion\Start" "ShowFrequentList" 'DWord' 0

# Hide Recently Added Apps
RegSet "HKCU:\Software\Microsoft\Windows\CurrentVersion\Start" "ShowRecentList" 'DWord' 0

# Hide Recommendations
RegSet "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "Start_IrisRecommendations" 'DWord' 0

# Hide Recent files
RegSet "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "Start_TrackDocs" 'DWord' 0

# Remove Icons from start menu
RegSet "HKCU:\Software\Microsoft\Windows\CurrentVersion\Start" "VisiblePlaces" 'DWord' 0

# Set Wallpaper Black solid color
RegSet "HKCU:\Control Panel\Desktop" "ImageColor" 'DWord' 3305111551
RegSet "HKCU:\Control Panel\Desktop" "WallPaper" 'String' ""
RegSet "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Wallpapers" "BackgroundType" 'DWord' 1

# Enable Dark Mode
RegSet "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" "SystemUsesLightTheme" 'DWord' 0
RegSet "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" "AppsUseLightTheme" 'DWord' 0
