{% from "ispconfig/map.jinja" import ispconfig with context %}

include:
  - ssl

mail_packages:
  pkg.installed:
    - pkgs:
      - postfix
      - getmail
      - dovecot
      - dovecot-mysql
      - dovecot-pigeonhole
      - mailman

#/etc/postfix/smtpd.crt:
#  file.symlink:
#    - target: {{ salt['pillar.get']('sslcrtpath') }}/fullchain.pem
#    - force: True
#    - require:
#      - file: /etc/pki/tls/certs/fullchain.pem
#
#/etc/postfix/smtpd.cert:
#  file.symlink:
#    - target: {{ salt['pillar.get']('sslcrtpath') }}/{{ salt['pillar.get']('sslname')}}.crt
#    - force: True
#    - require:
#      - file: {{ salt['pillar.get']('sslcrtpath') }}/{{ salt['pillar.get']('sslname')}}.crt
#
#/etc/postfix/smtpd.key:
#  file.symlink:
#    - target: {{ salt['pillar.get']('sslkeypath') }}/{{ salt['pillar.get']('sslname')}}.key
#    - force: True
#    - require:
#      - file: {{ salt['pillar.get']('sslkeypath') }}/{{ salt['pillar.get']('sslname')}}.key
#
#postfix.service:
#  service.running:
#    - enable: True
#    - reload: True
#    - require:
#      - file: /etc/postfix/smtpd.crt
#      - file: /etc/postfix/smtpd.key
#    - onchanges:
#      - file: /etc/postfix/smtpd.crt
#      - file: /etc/postfix/smtpd.key
#
#/etc/dovecot:
#  file.directory:
#    - user: root
#    - group: root
#    - mode: 0755
#    - require:
#      - pkg: mail_packages
#
#/etc/dovecot/dovecot.conf:
#  file.managed:
#    - source: salt://ispconfig/files/etc.dovecot.dovecot.conf
#    - user: root
#    - group: root
#    - mode: 0644
#    - require:
#      - file: /etc/dovecot
#
#/etc/dovecot/dovecot-sql.conf:
#  file.managed:
#    - source: salt://ispconfig/files/etc.dovecot.dovecot-sql.conf.jinja
#    - template: jinja
#    - user: root
#    - group: root
#    - mode: 0600
#    - require:
#      - file: /etc/dovecot
#
#/etc/dovecot-sql.conf:
#  file.symlink:
#    - target: /etc/dovecot/dovecot-sql.conf
#    - force: True
#    - require:
#      - file: /etc/dovecot/dovecot-sql.conf
#
#dovecot.service:
#  service.running:
#    - enable: True
#    - reload: True
#    - require:
#      - file: /etc/dovecot/dovecot.conf
#      - file: /etc/dovecot/dovecot-sql.conf
#    - watch:
#      - file: /etc/dovecot/dovecot.conf
#      - file: /etc/dovecot/dovecot-sql.conf


























