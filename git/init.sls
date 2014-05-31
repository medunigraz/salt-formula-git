#!jinja|yaml

{% from "git/defaults.yaml" import rawmap with context %}
{% set datamap = salt['grains.filter_by'](rawmap, merge=salt['pillar.get']('git:lookup')) %}

git:
  pkg:
    - installed
    - pkgs:
{% for p in datamap.pkgs %}
      - {{ p }}
{% endfor %}

{% for u in salt['pillar.get']('git:config:manage:users', []) %}
gitconfig_{{ u }}:
  file:
    - managed
    - name: {{ salt['user.info'](u).home ~ '/.gitconfig' }}
    - source: salt://git/files/gitconfig
    - mode: 644
    - user: {{ u }}
    - group: {{ u }}
{% endfor %}
