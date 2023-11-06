git:
  enabled: True
  config:
    manage:
      users:
        - root
  clones:
    /etc/freeradius:
      url: https://git.example.com/freeradius.git
      rev: production
      user: freerad
      overwrite: True
