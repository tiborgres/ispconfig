{% from "ispconfig/map.jinja" import ispconfig with context %}

# TODO

include:
  - ssl

ius-release:
  pkg.installed:
    - sources:
      - ius-release: salt://ispconfig/files/ius-release.rpm

httpd.packages:
  pkg.installed:
    - pkgs:
      - httpd24u
      - httpd24u-mod_ssl
    - require:
      - pkg: ius-release

/etc/httpd/conf/httpd.conf:
  file.managed:
    - source: salt://ispconfig/files/etc.httpd.conf.httpd.conf.jinja
    - template: jinja
    - user: root
    - group: root
    - mode: 0644
    - require:
      - pkg: httpd.packages

/etc/httpd/conf.d/ssl.conf:
  file.managed:
    - source: salt://ispconfig/files/etc.httpd.conf.d.ssl.conf.jinja
    - template: jinja
    - user: root
    - group: root
    - mode: 0644
    - require:
      - pkg: httpd.packages
      - file: /etc/pki/tls/certs/intermediate.crt
      - file: /etc/pki/tls/certs/{{ salt['pillar.get']('sslname')}}.crt
      - file: /etc/pki/tls/private/{{ salt['pillar.get']('sslname')}}.key
httpd.service:
  service.running:
    - enable: True
    - reload: True
    - require:
      - pkg: httpd.packages
      - pkg: mod-pagespeed-stable
      - file: /etc/httpd/*
#      - file: /etc/httpd/conf/httpd.conf
#      - file: /etc/httpd/conf.d/ssl.conf
#      - file: /etc/httpd/conf/sites-enabled
    - watch:
      - pkg: httpd.packages
      - pkg: mod-pagespeed-stable
      - file: /etc/httpd/*
      - file: /etc/php.ini
#      - file: /etc/httpd/conf/httpd.conf
#      - file: /etc/httpd/conf.d/ssl.conf
#      - file: /etc/httpd/conf.d/phpMyAdmin.conf
#      - file: /etc/php.ini