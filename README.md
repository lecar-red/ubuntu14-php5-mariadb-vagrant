# Vagrant Box and setup for Legacy PHP5 applications

Vagrant box using Ubuntu 14 (trusty), php5 and mariadb 10.1 for legacy applications including nginx instead of Apache.

## Getting Started

- clone this repo
- install [Virtual Box](https://www.virtualbox.org)
- install [Vagrant](https://www.vagrantup.com/downloads.html)
- `cd repo`
- run `vagrant up`

## Nginx

you may need to alter where your `www` root or drop stuff in:

### Connecting

- http://127.0.0.1:8888
- test php: http://127.0.0.1:8888/info.php

## Connecting to MariaDB

<table>
  <tr><td>Host</td><td>`127.0.0.1`</td></tr>
  <tr><td>User</td><td>`root`</td></tr>
  <tr><td>Password</td><td>`password`</td></tr>
  <tr><td>Port</td><td>`13306`</td></tr>
</table>

# Warnings :)

**_ NOT FOR PRODUCTION USE (See simple default password!!!) _**

