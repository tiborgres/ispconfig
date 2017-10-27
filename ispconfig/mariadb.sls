{% from "ispconfig/map.jinja" import ispconfig with context %}

mariadb-server:
  pkg.installed

/etc/my.cnf:
  file.managed:
    - source: salt://ispconfig/files/etc.my.cnf.jinja
    - template: jinja
    - user: root
    - group: root
    - mode: 0644
    - require:
      - pkg: mariadb-server

/etc/my.cnf.d:
  file.directory:
    - user: root
    - group: root
    - mode: 0755
    - require:
      - pkg: mariadb-server

/etc/my.cnf.d/server.cnf:
  file.managed:
    - source: salt://ispconfig/files/etc.my.cnf.d.server.cnf.jinja
    - template: jinja
    - user: root
    - group: root
    - mode: 0644
    - require:
      - file: /etc/my.cnf.d

/etc/my.cnf.d/client.cnf:
  file.managed:
    - source: salt://ispconfig/files/etc.my.cnf.d.client.cnf.jinja
    - template: jinja
    - user: root
    - group: root
    - mode: 0644
    - require:
      - file: /etc/my.cnf.d

/etc/my.cnf.d/mysql-clients.cnf:
  file.managed:
    - source: salt://ispconfig/files/etc.my.cnf.d.mysql-clients.cnf.jinja
    - template: jinja
    - user: root
    - group: root
    - mode: 0644
    - require:
      - file: /etc/my.cnf.d

/root/.my.cnf:
  file.managed:
    - source: salt://ispconfig/files/root.my.cnf.jinja
    - template: jinja
    - user: root
    - group: root
    - mode: 0600
    - require:
      - cmd: mariadb_rootpassword

mariadb_service:
  service.running:
    - name: mariadb.service
    - enable: True
    - require:
      - file: /etc/my.cnf
      - file: /etc/my.cnf.d/server.cnf
      - file: /etc/my.cnf.d/client.cnf
      - file: /etc/my.cnf.d/mysql-clients.cnf
    - watch:
      - file: /etc/my.cnf
      - file: /etc/my.cnf.d/server.cnf
      - file: /etc/my.cnf.d/client.cnf
      - file: /etc/my.cnf.d/mysql-clients.cnf

# change mariadb root password
mariadb_rootpassword:
  cmd.run:
    - name: mysqladmin --user={{ salt['pillar.get']('mariadb_rootuser') }} password '{{ salt['pillar.get']('mariadb_rootpassword') }}'
    - onchanges:
      - service: mariadb_service

mysqltuner:
  pkg.installed:
    - require:
      - pkg: mariadb-server

mytop:
  pkg.installed:
    - require:
      - pkg: mariadb-server
/root/.mytop:
  file.managed:
    - source: salt://ispconfig/files/root.mytop.jinja
    - template: jinja
    - user: root
    - group: root
    - mode: 0600
    - require:
      - pkg: mytop

#phpMyAdmin:
#  pkg.installed:
#    - require:
#      - pkg: php.packages
#/etc/httpd/conf.d/phpMyAdmin.conf:
#  file.managed:
#    - source: salt://ispconfig/files/etc.httpd.conf.d.phpMyAdmin.conf
#    - user: root
#    - group: root
#    - mode: 0644
#    - require:
#      - pkg: phpMyAdmin
#/etc/phpMyAdmin/config.inc.php:
#  file.managed:
#    - source: salt://ispconfig/files/etc.phpMyAdmin.config.inc.php
#    - user: root
#    - group: apache
#    - mode: 0640
#    - require:
#      - pkg: phpMyAdmin













