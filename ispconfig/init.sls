{% from "ispconfig/map.jinja" import ispconfig with context %}

include:
  - ispconfig.network
  - ispconfig.rootdir
  - ispconfig.common
  - ispconfig.ssl
  - ispconfig.zabbix_agent
  - ispconfig.mariadb
  - ispconfig.httpd
  - ispconfig.mail
  - ispconfig.rkhunter
