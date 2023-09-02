$RootDir = Split-Path -Path $PSScriptRoot

# Set auto login false
$regLogonKey = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon"
Set-ItemProperty -path $regLogonKey -name "AutoAdminLogon" -value 0
Set-ItemProperty -path $regLogonKey -name "DefaultUsername" -value ""
Set-ItemProperty -path $regLogonKey -name "DefaultPassword" -value ""


# Restore PowerToys settings
mkdir $HOME\Documents\PowerToys\Backup
$PT_CONF = $RootDir + "\config\PowerToys\settings_*"
Write-Host $PT_CONF
Copy-Item $PT_CONF -Destination "$HOME\Documents\PowerToys\Backup"
Start-Process $HOME\AppData\Local\PowerToys\PowerToys.exe
$wsobj = new-object -comobject wscript.shell
$result = $wsobj.popup("[全般]→[バックアップ&復元]→[復元]", 0, "PowerToys 設定の復元")

$POWERTOYS_WINDOW_TITLE = "*PowerToys*"
Add-Type -AssemblyName UIAutomationClient
$hwnd = (Get-Process |?{$_.MainWindowTitle -like $POWERTOYS_WINDOW_TITLE})[0].MainWindowHandle
$window = [System.Windows.Automation.AutomationElement]::FromHandle($hwnd)
$windowPattern=$window.GetCurrentPattern([System.Windows.Automation.WindowPattern]::Pattern)

while ($true) {
  if (! ($windowPattern.Current.WindowVisualState -match 'Normal|Maximized'))
  {
    break
  }
  Start-Sleep -Seconds 1
}


# Install cakewalk
Start-Process -FilePath $HOME\Downloads\BandLab*

Start-Sleep -Seconds 30

while ($true) {
  $BAND = Get-Process | Where-Object {$_.MainWindowTitle -ne ""} | Select-Object MainWindowTitle | Select-String "BandLab"
  if ($BAND -eq $null)
  {
    echo "owata"
    break
  }
  else
  {
    echo "madaya"
  }
  Start-Sleep -Seconds 5
}


# Setup Ubuntu on wsl
cd $PSScriptRoot
$DNS=Get-DnsClientServerAddress | Where-Object {$_.InterfaceAlias -match "イーサネット$|Wi-Fi"} | Where-Object {$_.AddressFamily -match "^2$"} | select -ExpandProperty ServerAddresses | Sort-Object | Get-Unique
wsl --install -d ubuntu -n; ubuntu run "./start_wsl.sh $DNS"

# Setting Hotkey
$WsShell = New-Object -ComObject WScript.Shell
$SD_Shc = $WsShell.CreateShortcut('AppData\Roaming\Microsoft\Windows\Start Menu\StableDiffusion.lnk')
$SD_Shc.TargetPath = "$HOME\StableDiffusion\webui-user.bat"
$SD_Shc.Save()

mkdir "$HOME\AppData\Roaming\Microsoft\Windows\Start Menu\Shortcut"
$Ubuntu_Shc = $WsShell.CreateShortcut('AppData\Roaming\Microsoft\Windows\Start Menu\Shortcut\ubuntu.lnk')
$Ubuntu_Shc.TargetPath = "ubuntu"
$Ubuntu_Shc.HotKey = "ALT+CTRL+U"
$Ubuntu_Shc.Save()

$Pwsh_Shc = $WsShell.CreateShortcut('AppData\Roaming\Microsoft\Windows\Start Menu\Shortcut\pwsh.lnk')
$Pwsh_Shc.TargetPath = "pwsh"
$Pwsh_Shc.Hotkey = "ALT+CTRL+P"
$Pwsh_Shc.Save()
