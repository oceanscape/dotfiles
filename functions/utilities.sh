#!/bin/bash

# DESCRIPTION
# Defines general utility functions.

# Answers a list of files stored in the home_files folder of this project.
function home_files() {
  for file in $(find home_files -type f); do
    printf "${file##*/}\n"
  done
}
export -f home_files

# Shows available files for install.
function show_files() {
  printf "Dotfiles available for install:\n"

  for file in $(home_files)
  do
    printf "  .${file%.*}\n"
  done
}
export -f show_files

# Installs a file.
# Parameters:
# $1 = The file name.
function install_file() {
  local source_file="home_files/$1"
  local dest_file="$HOME/.${1%.*}"

  if [[ ! -f "$dest_file" ]]; then
    cp "$source_file" "$dest_file"
    printf "  + $dest_file\n"
  fi
}
export -f install_file

# Installs all files.
function install_files() {
  printf "Installing dotfiles...\n"

  for file in $(home_files)
  do
    install_file $file
  done

  printf "Dotfiles install complete!\n"
}
export -f install_files

# Links a dotfile to this project.
# Parameters:
# $1 = The file name.
function link_file() {
  local source_file="$PWD/home_files/$1"
  local dest_file="$HOME/.${1%.*}"

  # Proceed only if the symbolic link doesn't already exist.
  if [[ ! -h "$dest_file" ]]; then
    read -p "  Link $dest_file -> $source_file (y/n)? " response
    if [[ $response == 'y' ]]; then
      ln -sf "$source_file" "$dest_file"
    fi
  fi
}
export -f link_file

# Links all files.
function link_files() {
  printf "Linking dotfiles...\n"

  for file in $(home_files)
  do
    link_file $file
  done

  printf "Dotfiles link complete!\n"
}
export -f link_files

# Checks a file for changes.
# Parameters:
# $1 = The file name.
function check_file() {
  local source_file="home_files/$1"
  local dest_file="$HOME/.${1%.*}"

  if [[ -f "$dest_file" ]]; then
    if [[ "$(diff $dest_file $source_file)" != '' ]]; then
      printf "  * $dest_file\n"
    fi
  else
    printf "  - $dest_file\n"
  fi
}
export -f check_file

# Checks all files for changes.
function check_files() {
  printf "Checking dotfiles for changes...\n"

  for file in $(home_files)
  do
    check_file $file
  done

  printf "Dotfiles check complete!\n"
}
export -f check_files

# Delete file.
# Parameters:
# $1 = The file name.
function delete_file() {
  local source_file="home_files/$1"
  local dest_file="$HOME/.${1%.*}"

  # Proceed only if the file exist.
  if [[ -f "$dest_file" ]]; then
    read -p "  Delete $dest_file (y/n)? " response
    if [[ $response == 'y' ]]; then
      rm -f "$dest_file"
    fi
  fi
}
export -f delete_file

# Delete files.
function delete_files() {
  printf "Deleting dotfiles...\n"

  for file in $(home_files)
  do
    delete_file $file
  done

  printf "Dotfiles deletion complete!\n"
}
export -f delete_files
