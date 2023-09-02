#!/bin/zsh

print "\n# Language version -------------------------"
asdf list
print "\n--------------------------------------------\n\n"


print "\n# Packages version -------------------------"

print "\n# asdf version:"
asdf version

print "\n# neovim version:"
nvim -v

print "\n# lazygit version:"
lazygit -v
print "\n--------------------------------------------\n\n"
