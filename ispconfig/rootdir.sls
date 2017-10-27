{% from "ispconfig/map.jinja" import ispconfig with context %}

root:
  user.present:
    - password: {{ salt['pillar.get']('rootpassword') }}
/root:
  file.directory:
    - user: root
    - group: root
    - dir_mode: 0700
    - file_mode: 0600
/root/work:
  file.directory:
    - user: root
    - group: root
    - dir_mode: 0700
    - file_mode: 0600
    - require:
      - file: /root
/root/bin:
  file.directory:
    - user: root
    - group: root
    - dir_mode: 0700
    - require:
      - file: /root
/root/bin/apdejt.sh:
  file.managed:
    - source: salt://ispconfig/files/root.bin.apdejt.sh
    - user: root
    - group: root
    - mode: 0700
    - require:
      - file: /root/bin
/root/.bashrc:
  file.managed:
    - source: salt://ispconfig/files/root.bashrc
    - user: root
    - group: root
    - mode: 0600
    - require:
      - file: /root
/root/.ssh:
  file.directory:
    - user: root
    - group: root
    - dir_mode: 0700
    - require:
      - file: /root
root_ssh_keys:
 ssh_auth.present:
  - user: root
  - names:
{%- for ssh, key in salt['pillar.get']('ssh:key', {}).iteritems() %}
    - {{ key }}
{% endfor %}
  - require:
    - file: /root/.ssh







