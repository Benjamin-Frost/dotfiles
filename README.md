# dotfiles

This repository contains my personal dotfiles for MacOS.

## Requirements

Before you begin, make sure you have the following tools installed:

- Command Line Tools: `xcode-select --install`
- [Homebrew](https://brew.sh/)

## Installation

First, clone this repository to your home directory:
   
```sh
git clone https://github.com/Benjamin-Frost/dotfiles.git ~/dotfiles
cd ~/dotfiles
```

Use Homebrew to install the required packages as specified in the `Brewfile`:
   
```sh
brew bundle install
```

Use GNU Stow to create symbolic links for the dotfiles in your home directory:
   
```sh
stow .
```
