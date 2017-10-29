{% from "ispconfig/map.jinja" import ispconfig with context %}

# ssl certificate
{{ salt['pillar.get']('ssl:crt') }}:
  file.managed:
    - contents:
        {{ salt['pillar.get']('ssl:crt_content') | yaml_encode }}
    - user: root
    - group: root
    - mode: 0644

# ssl key
{{ salt['pillar.get']('ssl:key') }}:
  file.managed:
    - contents:
        {{ salt['pillar.get']('ssl:key_content') | yaml_encode }}
    - user: root
    - group: root
    - mode: 0644

# ssl chain (from letsencrypt)
{{ salt['pillar.get']('ssl:chain_crt') }}:
  file.managed:
    - contents:
        {{ salt['pillar.get']('ssl:chain_crt_content') | yaml_encode }}
    - user: root
    - group: root
    - mode: 0644

# ssl fullchain (merged certificate and chain)
{{ salt['pillar.get']('ssl:fullchain_crt') }}:
  file.managed:
    - contents:
        {{ salt['pillar.get']('ssl:fullchain_crt_content') | yaml_encode }}
    - user: root
    - group: root
    - mode: 0644
