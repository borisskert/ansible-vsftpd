#!/bin/bash
set -e

# update-vsftpd-user-password.sh username new_password

user=$1
password=$2

is_user_existing() {
  if cat </etc/passwd | grep "^$user:" 1>/dev/null; then
    true
  else
    false
  fi
}

update_user_password() {
  echo -e "$password\n$password" | /usr/sbin/chpasswd
}

if is_user_existing; then
  update_user_password
  echo "Password of $user updated"
fi
