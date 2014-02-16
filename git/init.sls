{% from "git/defaults.yaml" import rawmap with context %}
{% set datamap = salt['grains.filter_by'](rawmap, merge=salt['pillar.get']('git:lookup')) %}

git:
  pkg:
    - installed
    - pkgs:
{% for p in datamap['pkgs'] %}
      - {{ p }}
{% endfor %}
