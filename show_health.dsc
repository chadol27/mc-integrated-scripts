show_health__below_name:
  type: world
  debug: false
  events:
    on server start:
    - scoreboard add id:main objective:health criteria:health displayslot:below_name

    on player joins:
    - scoreboard add viewers:<player> id:main objective:health criteria:health displayslot:below_name

show_health__command:
  type: command
  debug: false
  name: show_health_apply
  description: show_health
  usage: /show_health_apply
  permission: chadol.show_health.command
  script:
  - scoreboard add id:main objective:health criteria:health displayslot:below_name
  - foreach <server.online_players> as:loop_player:
    - scoreboard add viewers:<[loop_player]> id:main objective:health criteria:health displayslot:below_name
  - narrate "<&[base]>닉네임 아래 체력 표시를 모든 접속자에게 적용했습니다"
  - announce to_console "show_health_apply executed"
