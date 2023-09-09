Param (
    [switch]$PowerToys,
    [switch]$Terminal,
    [switch]$VSCode
)

function update_PT {
    $LatestPowerToys = (ls $HOME\Documents\PowerToys\Backup\settings_*.ptb | Sort-Object LastWriteTime -Descending)[0].FullName
    rm $HOME\.dotfiles\windows\config\PowerToys\*
    if (Test-Path $LatestPowerToys) {
        Copy-Item $LatestPowerToys -Destination $HOME\.dotfiles\windows\config\PowerToys -Force
    }
}

function update_WT {
    $WT_Conf = "$HOME\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
    if (Test-Path $WT_Conf) {
        Copy-Item  $WT_Conf -Destination $HOME\.dotfiles\windows\config\WindowsTerminal -Force
    }
}

function update_VSC {
    $VSC_Settings = "$HOME\AppData\Roaming\Code\User\settings.json"
    if (Test-Path $VSC_Settings) {
        Copy-Item $VSC_Settings -Destination $HOME\.dotfiles\windows\config\VSCode -Force
    }
    $VSC_Ext = "$HOME\.vscode\extensions\extensions.json"
    if (Test-Path $VSC_Ext) {
        sls '"identifier":{"id":".*?"' $VSC_Ext -AllMatches | % {$_.Matches.Value} | % {$_ -replace '"identifier":{"id":"', ''} | % {$_ -replace '"', ''} > $HOME\.dotfiles\windows\config\VSCode\extensions
    }
}

if ((! $PowerToys) -and (! $Terminal) -and (! $VSCode)) {
    update_PT
    update_VSC
    update_WT
} else {
    if ($PowerToys) {
        update_PT
    }
    if ($Terminal) {
        update_WT
    }
    if ($VSCode) {
        update_VSC
    }
}
