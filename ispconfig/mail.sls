{% from "ispconfig/map.jinja" import ispconfig with context %}

# commented as 'ssl' formula is not done yet
#include:
#  - ssl

mail_packages:
  pkg.installed:
    - pkgs:
      - postfix
      - getmail
      - dovecot
      - dovecot-mysql
      - dovecot-pigeonhole
      - mailman

# /etc/postfix/main.cf cannot be salted now as it is configured by ispconfig-install script
# this will be added here, later.

# /etc/postfix/master.cf cannot be salted now as it is configured by ispconfig-install script
# this will be added here, later.

# smtpd.crt
{{ salt['pillar.get']('postfix_smtpd_crt') }}:
  file.symlink:
    - target: {{ salt['pillar.get']('ssl_postfix_crt') }}
    - force: True
#    - require:
#      - file: {{ salt['pillar.get']('ssl_postfix_crt') }}

# smtpd.cert symlink
/etc/postfix/smtpd.cert:
  file.symlink:
    - target: {{ salt['pillar.get']('postfix_smtpd_crt') }}
    - force: True
#    - require:
#      - file: {{ salt['pillar.get']('postfix_smtpd_crt') }}

# smtpd.key
{{ salt['pillar.get']('postfix_smtpd_key') }}:
  file.symlink:
    - target: {{ salt['pillar.get']('ssl_key') }}
    - force: True
#    - require:
#      - file: {{ salt['pillar.get']('ssl_key') }}

# tag_as_foreign.re
{{ salt['pillar.get']('tag_as_foreign_re') }}:
  file.managed:
    - contents: |
        /^/  FILTER amavis:{{ salt['pillar.get']('amavis_foreign_interface') }}
    - user: root
    - group: root
    - mode: 0644
    - require:
      - pkg: mail_packages

# tag_as_originating.re
{{ salt['pillar.get']('tag_as_originating_re') }}:
  file.managed:
    - contents: |
        /^/  FILTER amavis:{{ salt['pillar.get']('amavis_originating_interface') }}
    - user: root
    - group: root
    - mode: 0644
    - require:
      - pkg: mail_packages

# postfix service
postfix.service:
  service.running:
    - enable: True
    - reload: True
    - require:
#      - file: {{ salt['pillar.get']('postfix_main_cf') }}
#      - file: {{ salt['pillar.get']('postfix_master_cf') }}
      - file: {{ salt['pillar.get']('postfix_smtpd_crt') }}
      - file: {{ salt['pillar.get']('postfix_smtpd_key') }}
      - file: {{ salt['pillar.get']('tag_as_foreign_re') }}
      - file: {{ salt['pillar.get']('tag_as_originating_re') }}
    - watch:
#      - file: {{ salt['pillar.get']('postfix_main_cf') }}
#      - file: {{ salt['pillar.get']('postfix_master_cf') }}
      - file: {{ salt['pillar.get']('postfix_smtpd_crt') }}
      - file: {{ salt['pillar.get']('postfix_smtpd_key') }}
      - file: {{ salt['pillar.get']('tag_as_foreign_re') }}
      - file: {{ salt['pillar.get']('tag_as_originating_re') }}

# dovecot config dir
{{ salt['pillar.get']('dovecot_dir') }}:
  file.directory:
    - user: root
    - group: root
    - mode: 0755
    - require:
      - pkg: mail_packages

# /etc/dovecot/dovecot.cnf cannot be salted now as it is configured by ispconfig-install script
# this will be added here, later.

# /etc/dovecot/dovecot-sql.cnf cannot be salted now as it is configured by ispconfig-install script
# this will be added here, later.

# dovecot service
dovecot.service:
  service.running:
    - enable: True
    - reload: True
    - require:
      - pkg: mail_packages
#      - file: {{ salt['pillar.get']('dovecot_dovecot_conf') }}
#      - file: {{ salt['pillar.get']('dovecot_dovecot-sql_conf') }}
#    - watch:
#      - file: {{ salt['pillar.get']('dovecot_dovecot_conf') }}
#      - file: {{ salt['pillar.get']('dovecot_dovecot-sql_conf') }}
