#!/bin/zsh

# Install asdf-nodejs.
asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git
asdf install nodejs latest
asdf global nodejs latest

# Install asdf-python.
asdf plugin add python
asdf install python latest
asdf global python latest

# Install asdf-lua.
asdf plugin add lua
asdf install lua latest
asdf global lua latest

# Install asdf-golang.
asdf plugin add golang
asdf install golang latest
asdf global golang latest

# Install asdf-r
asdf plugin add rlang https://github.com/asdf-community/asdf-r.git
asdf install rlang latest
asdf global rlang latest

# Install asdf-java
asdf plugin add java
JDK=`asdf list all java | grep -E ^"openjdk" | tail -n 1`
asdf install java $JDK
asdf global java $JDK

# Install asdf-kotlin.
asdf plugin add kotlin
asdf install kotlin latest
asdf global kotlin latest

# Install asdf-php
asdf plugin add php
asdf install php latest
asdf global php latest

# Install asdf-rust
asdf plugin-add rust https://github.com/asdf-community/asdf-rust.git
asdf install rust latest
asdf global rust latest
