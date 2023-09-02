# Admin
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole("Administrators")) { pwsh -NoProfile -ExecutionPolicy RemoteSigned -Command "Start-Process pwsh -Verb runas -ArgumentList '-ExecutionPolicy','RemoteSigned','$PSCommandPath'"; exit}

$RootDir = Split-Path -Path $PSScriptRoot


# Install software via winget
cd $PSScriptRoot
. .\winget.ps1

# Install Stable Diffusion
git clone https://github.com/AUTOMATIC1111/stable-diffusion-webui.git $HOME\StableDiffusion
python -m pip install --upgrade pip
$AutoLaunch = (gc $HOME\StableDiffusion\webui-user.bat) -replace "set COMMANDLINE_ARGS=", "set COMMANDLINE_ARGS=--autolaunch --medvram --xformers`r`n`r`ncd %~dp0"
$AutoLaunch > $HOME\StableDiffusion\webui-user.bat
cd $HOME\StableDiffusion
$SD = Start-Process -FilePath "$HOME\StableDiffusion\webui-user.bat" -PassThru
while ($true) {
  if (Get-Process | Where-Object {$_.MainWindowTitle -like "*Stable Diffusion*"}) {
    Get-Process | Where-Object {$_.MainWindowTitle -like "*Stable Diffusion*"} | Stop-Process
    Stop-Process $SD.Id
    break
  }
  Start-Sleep -Seconds 30
}

# wsl --install
wsl --install -n

# Download BandLab
Start-Process msedge https://www.bandlab.com/products/desktop/assistant/download/windows
Start-Sleep -Seconds 1
# Minimize vivalde
Add-Type -AssemblyName UIAutomationClient
$hwnd = (Get-Process | Where-Object {$_.MainWindowTitle -ne "" -and $_.ProcessName -like "*msedge*"}).MainWIndowHandle
$window = [System.Windows.Automation.AutomationElement]::FromHandle($hwnd)
$windowPattern=$window.GetCurrentPattern([System.Windows.Automation.WindowPattern]::Pattern)
$windowPattern.SetWindowVisualState([System.Windows.Automation.WindowVisualState]::Minimized)

# Install Fenrir FS
Invoke-WebRequest -Uri "https://www.fenrir-inc.com/services/download.php?file=FenrirFS-setup.exe" -OutFile "$HOME\Downloads\fenrir_installer.exe"
Start-Process -FilePath $HOME\Downloads\fenrir_installer.exe /SILENT -Wait

# Install vc2008 for MikuMikuDance
Invoke-WebRequest -Uri "https://download.microsoft.com/download/5/D/8/5D8C65CB-C849-4025-8E95-C3966CAFD8AE/vcredist_x64.exe" -OutFile "$HOME\Downloads\vc2008.exe"
Start-Process -FilePath $HOME\Downloads\vc2008.exe /q -Wait

# Install vcc2010 for MikuMikuDance
Invoke-WebRequest -Uri "https://download.microsoft.com/download/1/6/5/165255E7-1014-4D0A-B094-B6A430A6BFFC/vcredist_x64.exe" -OutFile "$HOME\Downloads\vc2010.exe"
Start-Process -FilePath $HOME\Downloads\vc2010.exe /q -Wait

# Install DirectX for MikuMikuDance
Invoke-WebRequest -Uri "https://download.microsoft.com/download/8/4/A/84A35BF1-DAFE-4AE8-82AF-AD2AE20B6B14/directx_Jun2010_redist.exe" -OutFile "$HOME\Downloads\directx.exe"
mkdir $HOME\Downloads\directx
Start-Process -FilePath $HOME\Downloads\directx.exe /Q, /T:$HOME\Downloads\directx -Wait
Start-Process -FilePath $HOME\Downloads\directx\DXSETUP.exe /SILENT -Wait

# Install MMD
Invoke-WebRequest -Uri "https://drive.google.com/uc?id=1Iucxu0tDsD05Siyv8VBGgm9vjD-f-RhM&export=download" -OutFile "$HOME\Downloads\mmd.zip"
cd $env:Programfiles
mkdir FreeSoft
7z x $HOME\Downloads\mmd.zip -o"$env:Programfiles\FreeSoft"

# Unzip AviUtl
Invoke-WebRequest -Uri "http://spring-fragrance.mints.ne.jp/aviutl/aviutl110.zip" -OutFile "$HOME\Downloads\aviutl.zip"
cd $env:Programfiles
mkdir FreeSoft\AviUtl
7z x $HOME\Downloads\aviutl.zip -o"$env:Programfiles\FreeSoft\AviUtl"

# Install Nerd font
Invoke-WebRequest -Uri "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/Noto.zip" -OutFile "$HOME\Downloads\noto.zip"
7z x $HOME\Downloads\noto.zip -o"$HOME\Downloads\noto"
$fonts_script = $RootDir + "\scripts\install_font.vbs"
cscript /nologo $fonts_script "$HOME\Downloads\noto\NotoMonoNerdFont-Regular.ttf"


# Set up Config
# Setup config for windows terminal app
$WT_CONF = $RootDir + "\config\WindowsTerminal\settings.json"
New-Item -Value $WT_CONF -Path "$HOME\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json" -ItemType SymbolicLink -Force

# Setup config for JoyTokey
$JOYTOKEY_CONF = $RootDir + "\config\JoyToky"
New-Item -Value $JOYTOKEY_CONF -Path $HOME\Documents\JoyTokey -ItemType SymbolicLink -Force

# Install VSCode extensions and set up config
$VSCode_ext = $RootDir + "\config\VSCode\extensions.json"
$VSCode_settings = $RootDir + "\config\VSCode\settings.json"
rm $HOME\.vscode\extensions\ -Recurse
New-Item -Value $VSCode_ext -Path $HOME\.vscode\extensions\extensions.json -ItemType SymbolicLink -Force
New-Item -Value $VSCode_settings -Path $HOME\AppData\Roaming\Code\User\settings.json -ItemType SymbolicLink -Force
sls '"identifier":{"id":".*?"' .\extensions.json -AllMatches | % {$_.Matches.Value} | % {$_ -replace '"identifier":{"id":"', ''} | % {$_ -replace '"', ''} | % {code --install-extension $_}

# Change Registry
cd $PSScriptRoot
. .\regset.ps1

# Restart and run script after restart
$script = $RootDir + "\scripts\after_reboot.ps1"
$pwsh = (gcm pwsh).Source
$regRunOnceKey = "HKLM:\Software\Microsoft\Windows\CurrentVersion\RunOnce"
$restartKey = "Restart-And-RunOnce"
Set-ItemProperty -path $regRunOnceKey -name $restartKey -value "$pwsh -ExecutionPolicy RemoteSigned $script"
Restart-Computer -Force
