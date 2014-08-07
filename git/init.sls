#!jinja|yaml

{% from "git/defaults.yaml" import rawmap with context %}
{% set datamap = salt['grains.filter_by'](rawmap, merge=salt['pillar.get']('git:lookup')) %}

git:
  pkg:
    - installed
    - pkgs: {{ datamap.pkgs }}

{% if 'global' in datamap.config.manage|default([]) %}
config_global:
  file:
    - managed
    - name: {{ datamap.config.global.name }}
    - user: root
    - group: root
    - mode: 644
    - contents_pillar: git:lookup:config:global:plain
{% endif %}

{% for u in salt['pillar.get']('git:config:manage:users', []) %}
user_gitconfig_{{ u }}:
  file:
    - managed
    - name: {{ salt['user.info'](u).home ~ '/.gitconfig' }}
    - source: salt://git/files/gitconfig
    - user: {{ u }}
    - group: {{ u }}
    - mode: 644
{% endfor %}
