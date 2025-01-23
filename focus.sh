#!/bin/bash

# Define the entries
entries=(
  "127.0.0.1 facebook.com"
  "127.0.0.1 www.facebook.com"
  "127.0.0.1 instagram.com"
  "127.0.0.1 www.instagram.com"
  "127.0.0.1 threads.net"
  "127.0.0.1 www.threads.net"
)

# Function to add entries
add_entries() {
  for entry in "${entries[@]}"; do
    if ! grep -qF "$entry" /etc/hosts; then
      echo "$entry" | sudo tee -a /etc/hosts > /dev/null
      echo "Added: $entry"
    else
      echo "Already exists: $entry"
    fi
  done
}

# Function to remove entries
remove_entries() {
  for entry in "${entries[@]}"; do
    # Use sed to delete lines exactly matching the entry
    if grep -qF "$entry" /etc/hosts; then
      sudo sed -i.bak "\|^$entry\$|d" /etc/hosts
      echo "Removed: $entry"
    else
      echo "Not found: $entry"
    fi
  done
}

# Main script
if [[ $EUID -ne 0 ]]; then
  echo "This script must be run as root. Use sudo."
  exit 1
fi

if [[ $1 == "add" ]]; then
  add_entries
elif [[ $1 == "remove" ]]; then
  remove_entries
else
  echo "Usage: $0 {add|remove}"
  exit 1
fi
