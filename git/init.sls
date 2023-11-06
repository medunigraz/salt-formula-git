#!jinja|yaml

{% if salt['pillar.get']('git:enabled', False) %}

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
    - contents_pillar: git:lookup:config:global:contents
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

{% for path, clone in salt['pillar.get']('git:clones', {}).items() %}
git_clone_{{ path }}:
  git.latest:
    - name: {{ clone.get('url') }}
    - target: {{ path }}
    - user: {{ clone.get('user') }}
    - force_clone: {{ clone.get('overwrite', False) }}
    - require:
      - pkg: git
{% endfor %}
{% endif %}
