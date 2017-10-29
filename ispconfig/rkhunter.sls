{% from "ispconfig/map.jinja" import ispconfig with context %}

rkhunter:
  pkg.installed

/etc/rkhunter.conf:
  file.managed:
    - source: salt://ispconfig/files/etc.rkhunter.conf.jinja
    - template: jinja
    - user: root
    - group: root
    - mode: 0600
    - require:
      - pkg: rkhunter

/etc/sysconfig/rkhunter:
  file.managed:
    - source: salt://ispconfig/files/etc.sysconfig.rkhunter.jinja
    - template: jinja
    - user: root
    - group: root
    - mode: 0600
    - require:
      - pkg: rkhunter

# rkhunter --update inside the helper script with fake exitcode 0
salt://ispconfig/files/rkhunter-update.sh:
  cmd.script:
    - require:
      - file: /etc/rkhunter.conf
      - file: /etc/sysconfig/rkhunter
    - onchanges:
      - pkg: rkhunter
      - file: /etc/rkhunter.conf
      - file: /etc/sysconfig/rkhunter

/usr/bin/rkhunter --propupd:
  cmd.run:
    - require:
      - cmd: salt://ispconfig/files/rkhunter-update.sh
      - file: /etc/rkhunter.conf
      - file: /etc/sysconfig/rkhunter
    - onchanges:
      - pkg: rkhunter
      - file: /etc/rkhunter.conf
      - file: /etc/sysconfig/rkhunter
