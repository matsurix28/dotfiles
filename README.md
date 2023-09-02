# Installation

## Linux
```
curl -LO https://raw.githubusercontent.com/knterada5/.dotfiles/main/install_linux.sh; source install_linux.sh
```

## Windows
<a id="start.bat" href="https://raw.githubusercontent.com/knterada5/.dotfiles/main/install_windows.ps1" download="start.bat">start.bat</a> 
<a href="https://github.com/knterada5/.dotfiles/blob/main/test/%E3%82%B9%E3%82%AF%E3%83%AA%E3%83%BC%E3%83%B3%E3%82%B7%E3%83%A7%E3%83%83%E3%83%88%202023-07-29%20112948.png" download>syasinn</a>
```
Invoke-WebRequest -Uri https://raw.githubusercontent.com/knterada5/.dotfiles/main/install_windows.ps1 -OutFile $HOME\Downloads\install_windows.ps1; start-process powershell -Verb RunAs -ArgumentList '-ExecutionPolicy', 'RemoteSigned', "$HOME\Downloads\install_windows.ps1"
```
