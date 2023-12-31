# Admin
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole("Administrators")) { pwsh -NoProfile -ExecutionPolicy RemoteSigned -Command "Start-Process pwsh -Verb runas -ArgumentList '-ExecutionPolicy','RemoteSigned','$PSCommandPath'"; exit}

$RootDir = Split-Path -Path $PSScriptRoot


# Install software via winget
cd $PSScriptRoot
. .\winget.ps1

# Download iVCam
Start-Process msedge https://www.e2esoft.com/download/ivcam-x64
Start-Sleep -Seconds 1
# Download BandLab
Start-Process msedge https://downloads.bandlab.com/cakewalk/setup/CakewalkSetup.exe?d=20220627
Start-Sleep -Seconds 1
# Minimize vivalde
Add-Type -AssemblyName UIAutomationClient
$hwnd = (Get-Process | Where-Object {$_.MainWindowTitle -ne "" -and $_.ProcessName -like "*msedge*"}).MainWIndowHandle
$window = [System.Windows.Automation.AutomationElement]::FromHandle($hwnd)
$windowPattern=$window.GetCurrentPattern([System.Windows.Automation.WindowPattern]::Pattern)
$windowPattern.SetWindowVisualState([System.Windows.Automation.WindowVisualState]::Minimized)

# Install iVCam
$iVCam = (ls $HOME\Downloads\iVCam*).FullName
Start-Process -FilePath $iVCam -ArgumentList "/SILENT" -Wait

# Install Fenrir FS
Invoke-WebRequest -Uri "https://www.fenrir-inc.com/services/download.php?file=FenrirFS-setup.exe" -OutFile "$HOME\Downloads\fenrir_installer.exe"
Start-Process -FilePath $HOME\Downloads\fenrir_installer.exe -ArgumentList "/SILENT" -Wait

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
mkdir $HOME\FreeSoft
Invoke-WebRequest -Uri "https://drive.google.com/uc?id=1Iucxu0tDsD05Siyv8VBGgm9vjD-f-RhM&export=download" -OutFile "$HOME\Downloads\mmd.zip"
7z x $HOME\Downloads\mmd.zip -o"$HOME\FreeSoft"

# Unzip AviUtl
Invoke-WebRequest -Uri "http://spring-fragrance.mints.ne.jp/aviutl/aviutl110.zip" -OutFile "$HOME\Downloads\aviutl.zip"
mkdir $HOME\FreeSoft\AviUtl
7z x $HOME\Downloads\aviutl.zip -o"$HOME\FreeSoft\AviUtl"

# Install Nerd font
Invoke-WebRequest -Uri "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/Noto.zip" -OutFile "$HOME\Downloads\noto.zip"
7z x $HOME\Downloads\noto.zip -o"$HOME\Downloads\noto"
$fonts_script = $RootDir + "\scripts\install_font.vbs"
cscript /nologo $fonts_script "$HOME\Downloads\noto\NotoMonoNerdFont-Regular.ttf"

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

# Set up Config
# Setup config for windows terminal app
$WT_CONF = $RootDir + "\config\WindowsTerminal\settings.json"
Copy-Item $WT_CONF -Destination "$HOME\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json" -Force

# Setup config for JoyTokey
$JOYTOKEY_CONF = $RootDir + "\config\JoyTokey"
Copy-Item $JOYTOKEY_CONF -Destination $HOME\Documents -Force -Recurse

# Install VSCode extensions and set up config
$VSCode_ext = $RootDir + "\config\VSCode\extensions"
$VSCode_settings = $RootDir + "\config\VSCode\settings.json"
rm $HOME\.vscode\extensions\ -Recurse
Copy-Item $VSCode_settings -Destination $HOME\AppData\Roaming\Code\User\settings.json -Force
gc $VSCode_ext | % {& $HOME\AppData\Local\Programs\'Microsoft VS Code'\bin\code.cmd --install-extension $_}

# Setting Hotkey
$WsShell = New-Object -ComObject WScript.Shell
$SD_Shc = $WsShell.CreateShortcut("$HOME\AppData\Roaming\Microsoft\Windows\Start Menu\StableDiffusion.lnk")
$SD_Shc.TargetPath = "$HOME\StableDiffusion\webui-user.bat"
$SD_Shc.Save()

$SysMocap_Shc = $WsShell.CreateShortcut("$HOME\AppData\Roaming\Microsoft\Windows\Start Menu\SysMocap.lnk")
$SysMocap_Shc.TargetPath = "$HOME\.dotfiles\windows\cmd\SysMocap.bat"
$SysMocap_Shc.Save()

$MMD_Shc = $WsShell.CreateShortcut("$HOME\AppData\Roaming\Microsoft\Windows\Start Menu\MikuMikuDance.lnk")
$MMD_folder = (ls $HOME\FreeSoft\Miku*).FullName
$MMD = $MMD_folder + "\MikuMikuDance.exe"
$MMD_Shc.TargetPath = $MMD
$MMD_Shc.Save()

$AVIUTL_Shc = $WsShell.CreateShortcut("$HOME\AppData\Roaming\Microsoft\Windows\Start Menu\AviUtl.lnk")
$AVIUTL_Shc.TargetPath = "$HOME\FreeSoft\AviUtl\aviutl.exe"
$AVIUTL_Shc.Save()

mkdir "$HOME\AppData\Roaming\Microsoft\Windows\Start Menu\Shortcut"
$Ubuntu_Shc = $WsShell.CreateShortcut("$HOME\AppData\Roaming\Microsoft\Windows\Start Menu\Shortcut\ubuntu.lnk")
$Ubuntu_Shc.TargetPath = "ubuntu"
$Ubuntu_Shc.HotKey = "ALT+CTRL+U"
$Ubuntu_Shc.Save()

$Pwsh_Shc = $WsShell.CreateShortcut("$HOME\AppData\Roaming\Microsoft\Windows\Start Menu\Shortcut\pwsh.lnk")
$Pwsh_Shc.TargetPath = "wt.exe"
$Pwsh_Shc.Hotkey = "ALT+CTRL+P"
$Pwsh_Shc.Save()

# Add Path to commands
$cmd = ";" + $RootDir + "\cmd"
$PATH = $ENV:Path + $cmd
[System.Environment]::SetEnvironmentVariable("Path", $PATH, "User")
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")

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
