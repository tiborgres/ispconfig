{% from "ispconfig/map.jinja" import ispconfig with context %}

{% if grains['os_family'] == 'RedHat' %}
epel-release:
  pkg.installed
{% endif %}

common_packages:
  pkg.installed:
    - pkgs:
      - postfix
      - mc
      - screen
      - net-tools
      - tcpdump
      - telnet
      - bind-utils
      - whois
      - psmisc
      - mlocate
      - ntpdate
      - sysstat
      - rsync
      - gdisk
      - bzip2
      - unzip
{% if grains['os_family'] == 'Debian' %}
      - vim
{% elif grains['os_family'] == 'RedHat' %}
      - vim-enhanced
    - require:
      - pkg: epel-release
{% endif %}

/var/spool/cron/root:
  file.managed:
    - source: salt://ispconfig/files/var.spool.cron.root.jinja
    - template: jinja
    - user: root
    - group: root
    - mode: 0600
    - require:
      - pkg: common_packages

{% if grains['os_family'] == 'RedHat' %}
/etc/selinux/config:
  file.managed:
    - source: salt://ispconfig/files/etc.selinux.config.jinja
    - template: jinja
    - user: root
    - group: root
    - mode: 0644
{% endif %}

/etc/cron.d/sysstat:
  file.managed:
    - source: salt://ispconfig/files/etc.cron.d.sysstat
    - user: root
    - group: root
    - mode: 0600
    - require:
      - pkg: common_packages

/etc/aliases:
  file.managed:
    - source: salt://ispconfig/files/etc.aliases.jinja
    - template: jinja
    - user: root
    - group: root
    - mode: 0644
/usr/bin/newaliases:
  cmd.run:
    - onchanges:
      - file: /etc/aliases

Development Tools:
  pkg.group_installed

quota:
  pkg.installed:
    - require:
      - pkg: Development Tools

/etc/default/grub:
  file.managed:
    - source: salt://ispconfig/files/etc.default.grub.jinja
    - template: jinja
    - user: root
    - group: root
    - mode: 0644

grub2-mkconfig -o /boot/grub2/grub.cfg:
  cmd.run:
    - require:
      - file: /etc/default/grub
    - onchanges:
      - file: /etc/default/grub

/:
  mount.mounted:
    - device: /dev/mapper/{{ salt['pillar.get']('lvm_vgname') }}-{{ salt['pillar.get']('lvm_lvroot') }}
    - fstype: xfs
    - opts: defaults,uquota,gquota,jqfmt=vfsv0
    - persist: true
    - dump: 1
    - pass_num: 1
    - require:
      - pkg: quota

mount -o remount /:
  cmd.run:
    - require:
      - mount: /
      - pkg: quota
      - cmd: grub2-mkconfig -o /boot/grub2/grub.cfg
    - onchanges:
      - mount: /

quotacheck -avugm:
  cmd.run:
    - require:
      - pkg: quota
      - file: /etc/default/grub
    - onchanges:
      - pkg: quota
    - watch:
      - file: /etc/default/grub
quotaon -avug:
  cmd.run:
    - require:
      - cmd: quotacheck -avugm
    - onchanges:
      - cmd: quotacheck -avugm








