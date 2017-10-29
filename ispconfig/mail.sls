{% from "ispconfig/map.jinja" import ispconfig with context %}

include:
  - ispconfig.rootdir
  - ispconfig.ssl

# mailserver part of formula
mail_packages:
  pkg.installed:
    - aggregate: true
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
    - target: {{ salt['pillar.get']('ssl:fullchain_crt') }}
    - force: True
    - require:
      - file: {{ salt['pillar.get']('ssl:fullchain_crt') }}

# smtpd.cert symlink
/etc/postfix/smtpd.cert:
  file.symlink:
    - target: {{ salt['pillar.get']('postfix_smtpd_crt') }}
    - force: True
    - require:
      - file: {{ salt['pillar.get']('postfix_smtpd_crt') }}

# smtpd.key
{{ salt['pillar.get']('postfix_smtpd_key') }}:
  file.symlink:
    - target: {{ salt['pillar.get']('ssl:key') }}
    - force: True
    - require:
      - file: {{ salt['pillar.get']('ssl:key') }}

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

# antispam part of formula
antispam_packages:
  pkg.installed:
    - aggregate: true
    - pkgs:
      - amavisd-new
      - spamassassin
      - bogofilter
      - clamav-server
      - clamav-data
      - clamav-update
      - clamav-filesystem
      - clamav
      - clamav-scanner-systemd
      - clamav-devel
      - clamav-lib
      - clamav-server-systemd
      - unzip
      - bzip2
      - perl-DBD-MySQL
      - dspam
      - dspam-hash
      - pypolicyd-spf

# CRM114 packages installation
crm114_packages:
  pkg.installed:
    - sources:
      - crm114: {{ salt['pillar.get']('rpm_crm114') }}
      - libtre5: {{ salt['pillar.get']('rpm_libtre5') }}
      - tre: {{ salt['pillar.get']('rpm_tre') }}
    - require:
      - pkg: antispam_packages

# /etc/bogofilter.cf
{{ salt['pillar.get']('bogofilter_cf') }}:
  file.managed:
    - source: salt://ispconfig/files/etc.bogofilter.cf
    - user: root
    - group: root
    - mode: 0644
    - require:
      - pkg: antispam_packages

# /etc/freshclam.conf
{{ salt['pillar.get']('freshclam_conf') }}:
  file.managed:
    - source: salt://ispconfig/files/etc.freshclam.conf
    - user: root
    - group: root
    - mode: 0644
    - require:
      - pkg: antispam_packages

# /etc/sysconfig/freshclam
{{ salt['pillar.get']('freshclam_sysconfig') }}:
  file.managed:
    - source: salt://ispconfig/files/etc.sysconfig.freshclam
    - user: root
    - group: root
    - mode: 0644
    - require:
      - file: {{ salt['pillar.get']('freshclam_conf') }}
    - onchanges_in:
      - cmd: freshclam

# onetime run of ClamAV database update - freshclam
freshclam:
  cmd.run:
    - require:
      - file: {{ salt['pillar.get']('freshclam_sysconfig') }}
    - onchanges:
      - file: {{ salt['pillar.get']('freshclam_sysconfig') }}

# amavisd service
amavisd:
  service.running:
    - enable: True
    - reload: True
    - require:
      - pkg: antispam_packages
    - watch:
      - file: {{ salt['pillar.get']('freshclam_conf') }}
    - onchanges_in:
      - cmd: salt://ispconfig/files/sa-update.sh

# sa-update inside the helper script with fake exitcode 0
salt://ispconfig/files/sa-update.sh:
  cmd.script:
    - require:
      - service: amavisd
    - onchanges:
      - service: amavisd

# ClamAV service
clamd@amavisd.service:
  service.running:
    - enable: True
    - require:
      - service: amavisd
    - watch:
      - service: amavisd

# antispam scripts
{{ salt['pillar.get']('amavis_bin_dir') }}:
  file.directory:
    - user: amavis
    - group: amavis
    - mode: 0755
    - require:
      - pkg: antispam_packages

{{ salt['pillar.get']('amavis_bin_dir') }}/spam.sh:
  file.managed:
    - source: salt://ispconfig/files/var.spool.amavisd.bin.spam.sh
    - user: amavis
    - group: amavis
    - mode: 0700
    - require:
      - file: {{ salt['pillar.get']('amavis_bin_dir') }}

/root/bin/copy_sync.sh:
  file.managed:
    - source: salt://ispconfig/files/root.bin.copy_sync.sh
    - user: root
    - group: root
    - mode: 0700
    - require:
      - file: /root/bin
      - pkg: antispam_packages
      - pkg: crm114_packages

/root/bin/clear_spams.sh:
  file.managed:
    - source: salt://ispconfig/files/root.bin.clear_spams.sh
    - user: root
    - group: root
    - mode: 0700
    - require:
      - file: /root/bin
      - pkg: antispam_packages
      - pkg: crm114_packages

/root/bin/train_spams.sh:
  file.managed:
    - source: salt://ispconfig/files/root.bin.train_spams.sh
    - user: root
    - group: root
    - mode: 0700
    - require:
      - file: /root/bin/copy_sync.sh
      - file: /root/bin/clear_spams.sh
      - file: {{ salt['pillar.get']('amavis_bin_dir') }}/spam.sh
