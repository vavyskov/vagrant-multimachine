# vagrant-multimachine

Debian LAPP (Linux, Apache, PostgreSQL, PHP) stack

Operatin system:
- Debian

Server:
- Apache
- (LDAP)

Programming language:
- PHP

Database:
- PostgreSQL

Database management:
- Adminer

Development:
- Composer

LDAP management:
- (LDAP Account Manager)

# Usage

## 1. Run `vagrant up` to configure
- the `symfony.example.com` server environment
- the `ldap.example.com` server environment

## 2. You can use URL
- the `localhost` for Symfony
- the `localhost:8080` for LDAP Account Manager
- (the `ldap://localhost:389` for OpenLDAP)

## 3. Configure your system `hosts` file

    192.168.33.10 symfony.example.com
    192.168.33.20 ldap.example.com

- Linux: `/etc/hosts`
- macOX: `/private/etc/hosts`
- Windows: `C:\Windows\System32\drivers\etc\hosts`

The LDAP comes pre-configured with the following entries:

    uid=user1,ou=people,dc=example,dc=com
    uid=user2,ou=people,dc=example,dc=com

    cn=nas,ou=group,dc=example,dc=com
