{% from "ispconfig/map.jinja" import ispconfig with context %}

/usr/bin/rkhunter --update:
  cmd.run:
    - require:
      - file: /etc/rkhunter.conf
      - file: /etc/sysconfig/rkhunter
    - onchanges:
      - pkg: common_packages
/usr/bin/rkhunter --propupd:
  cmd.run:
    - require:
      - cmd: /usr/bin/rkhunter --update
      - file: /etc/rkhunter.conf
      - file: /etc/sysconfig/rkhunter
    - onchanges:
      - pkg: common_packages
    - watch:
      - file: /etc/rkhunter.conf
      - file: /etc/sysconfig/rkhunter
/etc/rkhunter.conf:
  file.managed:
    - source: salt://ispconfig/files/etc.rkhunter.conf.jinja
    - template: jinja
    - user: root
    - group: root
    - mode: 0600
    - require:
      - pkg: common_packages
/etc/sysconfig/rkhunter:
  file.managed:
    - source: salt://ispconfig/files/etc.sysconfig.rkhunter.jinja
    - template: jinja
    - user: root
    - group: root
    - mode: 0600
    - require:
      - pkg: common_packages
