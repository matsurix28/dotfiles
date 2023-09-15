Start-Sleep -Seconds 30

$RootDir = Split-Path -Path $PSScriptRoot

# Set auto login false
$regLogonKey = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon"
Set-ItemProperty -path $regLogonKey -name "AutoAdminLogon" -value 0
Set-ItemProperty -path $regLogonKey -name "DefaultUsername" -value ""
Set-ItemProperty -path $regLogonKey -name "DefaultPassword" -value ""

# Install Volta
Invoke-WebRequest -Uri https://github.com/volta-cli/volta/releases/download/v1.1.1/volta-1.1.1-windows-x86_64.msi -OutFile $HOME\Downloads\volta.msi
cmd /c "msiexec.exe /i $HOME\Downloads\volta.msi /passive"

# Install Node.js
volta install node
volta install npm

# Install SysMocap
git clone https://github.com/xianfei/SysMocap.git $HOME\SysMocap
cd $HOME\SysMocap
npm i
npm start

# Restore PowerToys settings
mkdir $HOME\Documents\PowerToys\Backup
$PT_CONF = $RootDir + "\config\PowerToys\settings_*"
Copy-Item $PT_CONF -Destination "$HOME\Documents\PowerToys\Backup" -Force
Start-Process $HOME\AppData\Local\PowerToys\PowerToys.exe
$wsobj = new-object -comobject wscript.shell
$result = $wsobj.popup("[全般]→[バックアップ&復元]→[復元]", 0, "PowerToys 設定の復元")

Add-Type -AssemblyName UIAutomationClient
$hwnd = (Get-Process | ? {($_.MainWindowTitle -ne "") -and ($_.ProcessName -like "powertoys*")}).MainWindowHandle

$window = [System.Windows.Automation.AutomationElement]::FromHandle($hwnd)
$windowPattern=$window.GetCurrentPattern([System.Windows.Automation.WindowPattern]::Pattern)

while ($true) {
  if (! ($windowPattern.Current.WindowVisualState -match 'Normal|Maximized'))
  {
    break
  }
  Start-Sleep -Seconds 1
}

# Install Cakewalk
Start-Process -FilePath $HOME\Downloads\CakewalkSetup.exe -Wait

# Setup Ubuntu on wsl
cd $PSScriptRoot
$DNS=Get-DnsClientServerAddress | Where-Object {$_.InterfaceAlias -match "イーサネット$|Wi-Fi"} | Where-Object {$_.AddressFamily -match "^2$"} | select -ExpandProperty ServerAddresses | Sort-Object | Get-Unique
wsl --install -d ubuntu -n; ubuntu run "./start_wsl.sh $DNS"
