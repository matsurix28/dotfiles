# Installation

## Linux
```
curl -LO https://raw.githubusercontent.com/matsurix28/dotfiles/main/install_linux.sh; source install_linux.sh
```

## Windows
```
Invoke-WebRequest -Uri https://raw.githubusercontent.com/matsurix28/dotfiles/main/install_windows.ps1 -OutFile $HOME\Downloads\install_windows.ps1; start-process powershell -Verb RunAs -ArgumentList '-ExecutionPolicy', 'RemoteSigned', "$HOME\Downloads\install_windows.ps1"
```
