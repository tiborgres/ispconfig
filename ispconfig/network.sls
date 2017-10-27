{% from "ispconfig/map.jinja" import ispconfig with context %}

# network
{% if grains['os_family'] == 'RedHat' %}
/etc/sysconfig/network:
  file.managed:
    - source: salt://ispconfig/files/etc.sysconfig.network.jinja
    - template: jinja
    - user: root
    - group: root
    - mode: 0644

# iptables firewall

# adding HTTP and HTTPS ports to firewall
{% set ports_to_be_added = [] %}
{%- for proto, port in salt['pillar.get']('ports', {}).iteritems() %}
 {% do ports_to_be_added.append(port) %}
{% endfor %}

# tmp test, remove me
{%- set proto = 'tcp' %}

# adding firewall rules to existing ruleset
{% for port in ports_to_be_added %}
firewall_append_{{ proto }}_{{ port }}:
  iptables.append:
    - table: filter
    - family: ipv4
    - chain: INPUT
    - jump: ACCEPT
    - match: state
    - connstate: NEW
    - dports:
        - {{ port }}
    - proto: {{ proto }}
    - save: True
{% endfor %}

iptables_service:
  service.running:
    - name: iptables.service
    - enable: True
    - reload: True
{% endif %}

/etc/resolv.conf:
  file.managed:
    - source: salt://ispconfig/files/etc.resolv.conf.jinja
    - template: jinja
    - user: root
    - group: root
    - mode: 0644
/etc/hosts:
  file.managed:
    - source: salt://ispconfig/files/etc.hosts.jinja
    - template: jinja
    - user: root
    - group: root
    - mode: 0644
