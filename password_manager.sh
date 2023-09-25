#!/bin/bash

DB_FILE="passwords.txt"

list_passwords() {
  if [ -e "$DB_FILE" ]; then
    cat "$DB_FILE"
  else
    echo "Password database is empty."
  fi
}

add_password() {
  read -p "Account Name: " account
  read -sp "Password: " password
  echo "$account:$password" >> "$DB_FILE"
  echo -e "\nPassword added."
}

generate_password() {
  read -sp "Generate Password (press Enter for a random password): " password
  if [ -z "$password" ]; then
    password=$(openssl rand -base64 12)
    echo -e "\nGenerated Password: $password"
  else
    echo -e "\nCustom Password added."
  fi
  read -p "Account Name: " account
  echo "$account:$password" >> "$DB_FILE"
  echo -e "\nPassword added."
}

update_password() {
  read -p "Account Name to Update: " account
  if grep -q "^$account:" "$DB_FILE"; then
    read -sp "New Password: " new_password
    sed -i "s/^$account:.*/$account:$new_password/" "$DB_FILE"
    echo -e "\nPassword updated."
  else
    echo "Account not found."
  fi
}

delete_password() {
  read -p "Account Name to Delete: " account
  if grep -q "^$account:" "$DB_FILE"; then
    sed -i "/^$account:/d" "$DB_FILE"
    echo "Password deleted."
  else
    echo "Account not found."
  fi
}

#LOOP
while true; do
  echo -e "\n1. List Passwords"
  echo "2. Add Password"
  echo "3. Generate Password"
  echo "4. Update Password"
  echo "5. Delete Password"
  echo "6. Exit"
  read -p "Make your selection (1/2/3/4/5/6): " choice

  case $choice in
    1) list_passwords ;;
    2) add_password ;;
    3) generate_password ;;
    4) update_password ;;
    5) delete_password ;;
    6) echo "Exiting." ; exit ;;
    *) echo "Invalid choice. Please try again." ;;
  esac
done
