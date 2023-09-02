# Install software via winget

# Install sudo
winget install --id gerardog.gsudo --accept-source-agreements --accept-package-agreements

# Install iTunes
winget install --id 9PB2MZ1ZMB1S --accept-source-agreements --accept-package-agreements

# Install LINE
winget install --id XPFCC4CD725961 --accept-source-agreements --accept-package-agreements

# Install Wireless Adapter
winget install --id 9WZDNCRFJBB1 --accept-source-agreements --accept-package-agreements

# Install 7z
winget install --id 7zip.7zip --accept-source-agreements --accept-package-agreements

# Install JoyTokey
winget install --id JTKsoftware.JoyToKey --accept-source-agreements --accept-package-agreements

# Install Clip Studio
winget install --id XPDP32QDDFL4PK --accept-source-agreements --accept-package-agreements

# Install ESET Security
winget install --id ESET.Security --accept-source-agreements --accept-package-agreements

# Install Steam
winget install --id Valve.Steam --accept-source-agreements --accept-package-agreements

# Install Logi Options
winget install --id Logitech.OptionsPlus --accept-source-agreements --accept-package-agreements

# Install Remote mouse
winget install --id EmoteInteractive.RemoteMouse --accept-source-agreements --accept-package-agreements

# Install Virtual Box
winget install --id Oracle.VirtualBox --accept-source-agreements --accept-package-agreements

# Install Minecraft
winget install --id Mojang.MinecraftLauncher --accept-source-agreements --accept-package-agreements

# Install Android Studio
winget install --id Google.AndroidStudio --accept-source-agreements --accept-package-agreements

# Install Gimp
winget install --id GIMP.GIMP --accept-source-agreements --accept-package-agreements

# Install Inkscape
winget install --id Inkscape.Inkscape --accept-source-agreements --accept-package-agreements

# Install Thunderbird
winget install --id Mozilla.Thunderbird --accept-source-agreements --accept-package-agreements

# Install Blender
winget install --id BlenderFoundation.Blender --accept-source-agreements --accept-package-agreements

# Install Google Chrome
winget install --id Google.Chrome --accept-source-agreements --accept-package-agreements

# Install VSCode
winget install --id Microsoft.VisualStudioCode --accept-source-agreements --accept-package-agreements

# Install Windows Terminal
winget install --id Microsoft.WindowsTerminal --accept-source-agreements --accept-package-agreements

# Install PowerToys
winget install --id Microsoft.PowerToys --accept-source-agreements --accept-package-agreements

# Install python 3.10.6 for Stable Diffusion
winget install --id Python.Python.3.10 --version 3.10.6 --accept-source-agreements --accept-package-agreements


# Setting Path
$7Z = ";" + $env:Programfiles + "\7-Zip\"
$code = ";" + $HOME + "\AppData\Local\Programs\Microsoft VS Code\"
$py = ";" + $HOME + "\AppData\Local\Programs\Python\Python310"
$PATH = $ENV:Path + $7Z + $code + $py
[System.Environment]::SetEnvironmentVariable("Path", $PATH, "User")
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")

# Remove default python.exe
rm $HOME\AppData\Local\Microsoft\WindowsApps\python.exe
