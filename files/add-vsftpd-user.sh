#!/bin/bash
set -e

# add-vsftpd-user.sh username password user_id

user=$1
password=$2
user_id=$3
gid=$user_id

is_user_existing() {
  if cat </etc/passwd | grep "^$user:" 1>/dev/null; then
    true
  else
    false
  fi
}

create_user() {
  adduser \
    --uid "$user_id" \
    --home-dir "/home/$user" \
    --gid ftp \
    --shell /bin/false \
    "$user"
  echo "$user:$password" | chpasswd
}

if ! is_user_existing; then
  create_user
  echo "User $user created"
fi
