#!/bin/bash
set -e

# add-vsftpd-user.sh username password user_id

user=$1
password=$2
user_id=$3
gid=$user_id
group=$user

is_group_existing() {
  if cat </etc/group | grep "^$group:" 1>/dev/null; then
    true
  else
    false
  fi
}

is_user_existing() {
  if cat </etc/passwd | grep "^$user:" 1>/dev/null; then
    true
  else
    false
  fi
}

create_group() {
  addgroup ${gid:+-g $gid} "$group"
}

create_user() {
  adduser ${user_id:+-u $user_id} -D -G "$group" -h "/home/$user" -s /bin/false "$user"
  echo "$user:$password" | chpasswd
}

if ! is_group_existing; then
  create_group
  echo "Group $group created"
fi

if ! is_user_existing; then
  create_user
  echo "User $user created"
fi
