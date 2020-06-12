# ansible-vsftpd

Installs a [vsftpd](https://security.appspot.com/vsftpd.html) FTP server as a systemd-managed Docker container.

## System requirements

* Docker
* Systemd

## Role requirements

* python-docker package

## Tasks

* Create volume directories
* Setup vsftpd config
* Build Docker image
* Setup logrotate (optional)
* Create user accounts (within Docker container)

## Role parameters

| Variable       | Type | Mandatory? | Default | Description           |
|----------------|------|------------|---------|-----------------------|
| vsftpd_data_port | number | no     | 20      | Defines the ftp data port |
| vsftpd_control_port | number | no  | 21      | Defines the ftp control port |
| vsftpd_interface    | ip address | no | 0.0.0.0 | Defines the mapped Docker network interface address |
| vsftpd_volumes_path | text       | yes |        | Defines the volumes base directory on host system   |
| vsftpd_config_path  | text       | no  | `{{ vsftpd_volumes_path }}/config` | Defines the config volume directory on host system |
| vsftpd_log_volume   | text       | no  | `{{ vsftpd_volumes_path }}/log`    | Defines the log volume directory on host system |
| vsftpd_home_volume  | text       | no  | `{{ vsftpd_volumes_path }}/home`   | Defines the home volume directory for vsftpd users on the host system |
| vsftpd_pasv_enable  | boolean    | no  | false                              | Enables/Disables ftp PASV mode |
| vsftpd_pasv_min_port | number    | yes, if PASV enabled |                   | Defines the minimum PASV port |
| vsftpd_pasv_max_port | number    | yes, if PASV enabled |                   | Defines the maximum PASV port |
| vsftpd_pasv_address  | text      | no                   |                   | Defines the PASV ip address |
| vsftpd_pasv_addr_resolve | text  | no                   |                   | Read the vsftp docs: see `pasv_addr_resolve` option |
| vsftpd_users         | array of `user` | no             | []                | Defines the vsftpd users |
| vsftpd_anonymous_enable | boolean      | no             | false             | Enables anonymous access without login |
| vsftpd_anon_upload_enable | boolean    | no             | false             | Enables anonymous file uploads         |
| vsftpd_ipv6_enable        | boolean    | no             | false             | Enables IPv6 support |
| vsftpd_ssl_enable         | boolean    | no             | false             | Enables SSL/TLS support |
| vsftpd_ssl_cert_file:     | text       | yes, if SSL/TLS is enabled |       | Setup the SSL/TLS certificate file path |
| vsftpd_ssl_private_key_file | text     | yes, if SSL/TLS is enabled |       | Setup the SSL/TLS private |
| vsftpd_require_ssl_reuse    | boolean  | no                         | true  | Read the vsftp docs: see `require_ssl_reuse` option |
| vsftpd_allow_anon_ssl       | boolean  | no                         | false | Read the vsftp docs: see `allow_anon_ssl` option |
| vsftpd_implicit_ssl         | boolean  | no                         | false | Read the vsftp docs: see `implicit_ssl` option |
| vsftpd_banner               | text     | no                         | Welcome to FTP Server | Read the vsftp docs: see `ftpd_banner` option |
| vsftpd_dirmessage_enable    | boolean  | no                         | false                 | Read the vsftp docs: see `dirmessage_enable` option |
| vsftpd_max_clients          | number   | no                         | 0                     | Read the vsftp docs: see `max_clients` option |
| vsftpd_max_per_ip           | number   | no                         | 0                     | Read the vsftp docs: see `max_per_ip` option  |
| vsftpd_xferlog_enable       | boolean  | no                         | false                 | Read the vsftp docs: see `xferlog_enable` option |
| vsftpd_log_ftp_protocol     | boolean  | no                         | false                 | Read the vsftp docs: see `log_ftp_protocol` option |
| vsftpd_chroot_users         | boolean  | no                         | false                 | Enable user chroot (read the vsftpd docs for further details) |
| vsftpd_logrotate_enable     | boolean  | no                         | false                 | Enables logrotate configuration for the logs |

### Definition `user`

| Property      | Type | Mandatory? | Description           |
|---------------|------|------------|-----------------------|
| username      | text | yes        | Username of the specified user |
| password      | text | yes        | (Clear text) password of the specified user |
| uid           | number | yes      | Unix user id                                |
| update_password | boolean | yes   | Defines if the user password will be updated |

## Usage

### Requirements

```yaml
- name: install-vsftpd
  src: https://github.com/borisskert/ansible-vsftpd.git
  scm: git
```

### Playbook

```yaml
- hosts: test_machine
  become: yes

  roles:
    - role: install-vsftpd
      vsftpd_centos_version: 8.1.1911
      vsftpd_volumes_path: /srv/vsftpd
      vsftpd_log_volume: /var/log/vsftpd
      vsftpd_home_volume: /srv/vsftpd/home
      vsftpd_anonymous_enable: true
      vsftpd_anon_upload_enable: true
      vsftpd_pasv_enable: true
      vsftpd_pasv_min_port: 21111
      vsftpd_pasv_max_port: 21112
      vsftpd_pasv_address: my.ftpserver.org
      vsftpd_pasv_addr_resolve: true
      vsftpd_ipv6_enable: false
      vsftpd_ssl_enable: true
      vsftpd_require_ssl_reuse: false
      vsftpd_implicit_ssl: false
      vsftpd_allow_anon_ssl: true
      vsftpd_ssl_cert_file: /srv/openssl/certs/ftp.site.org/fullchain.pem
      vsftpd_ssl_private_key_file: /srv/openssl/certs/ftp.site.org/privkey.pem
      vsftpd_xferlog_enable: true
      vsftpd_log_ftp_protocol: true
      vsftpd_chroot_users: true
      vsftpd_logrotate_enable: true
      vsftpd_users:
        - username: foo
          password: foo123
          uid: 2001
        - username: bar
          password: bar123
          uid: 2002
```

## Testing

Requirements:

* [Vagrant](https://www.vagrantup.com/)
* [VirtualBox](https://www.virtualbox.org/)
* [Ansible](https://docs.ansible.com/)
* [Molecule](https://molecule.readthedocs.io/en/latest/index.html)
* [yamllint](https://yamllint.readthedocs.io/en/stable/#)
* [ansible-lint](https://docs.ansible.com/ansible-lint/)
* [Docker](https://docs.docker.com/)

### Run within docker

```shell script
molecule test
```

### Run within Vagrant

```shell script
 molecule test --scenario-name vagrant --parallel
```

I recommend to use [pyenv](https://github.com/pyenv/pyenv) for local testing.
Within the Github Actions pipeline I use [my molecule Docker image](https://github.com/borisskert/docker-molecule).

## License

MIT

## Design decisions

| Decision | Alternatives | Reason |
| -------- | ------------ | ------ |
| Why centos base image? | alpine | vsftp on alpine causes weird segfaults on logoff when TLS enabled |

## Links

* [vsftpd_conf](http://vsftpd.beasts.org/vsftpd_conf.html)
