{% from "ispconfig/map.jinja" import ispconfig with context %}

{% if grains['os_family'] == 'RedHat' %}
zabbix-release:
  pkg.installed:
    - sources:
      - zabbix-release: salt://ispconfig/files/zabbix-release-3.0-1.el{{pillar['os_version']}}.noarch.rpm
/etc/yum.repos.d/zabbix.repo:
  file.managed:
    - source: salt://ispconfig/files/etc.yum.repos.d.zabbix.repo
    - template: jinja
    - user: root
    - group: root
    - mode: 0644
    - require:
      - pkg: zabbix-release
zabbix-agent:
  pkg.installed:
    - require:
      - file: /etc/yum.repos.d/zabbix.repo
/etc/zabbix/zabbix_agentd.conf:
  file.managed:
    - source: salt://ispconfig/files/etc.zabbix.zabbix_agentd.conf.jinja
    - template: jinja
    - user: root
    - group: root
    - mode: 0644
    - require:
      - pkg: zabbix-agent
make sure zabbix-agent is running:
  service.running:
    - name: zabbix-agent
    - enable: true
    - require:
      - pkg: zabbix-agent
    - watch:
      - file: /etc/zabbix/zabbix_agentd.conf
{% endif %}