{% from "ispconfig/map.jinja" import ispconfig with context %}

include:
  - ispconfig.network
  - ispconfig.rootdir
  - ispconfig.common
  - ispconfig.zabbix_agent
  - ispconfig.mariadb
  - ispconfig.httpd
  - ispconfig.rkhunter