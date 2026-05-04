auto_shutdown__event:
  type: world
  debug: false
  events:
    on server start:
    - wait 5m
    - if <server.online_players.size> > 0:
      - stop
    - run auto_shutdown__start_countdown

    after player quits:
    - wait 1t
    - if <server.online_players.size> > 0:
      - stop
    - run auto_shutdown__start_countdown

    after player joins:
    - wait 1t
    - if !<server.has_flag[auto_shutdown_token]>:
      - stop
    - define was_warned <server.has_flag[auto_shutdown_warned]>
    - flag server auto_shutdown_token:!
    - flag server auto_shutdown_warned:!
    - if <[was_warned]>:
      - define message "접속으로 서버 종료가 취소됩니다"
      - run discord_webhook_send def.message:<[message]>

auto_shutdown__start_countdown:
  type: task
  debug: false
  script:
  - flag server auto_shutdown_token:<util.current_time_millis>
  - flag server auto_shutdown_warned:!
  - run auto_shutdown__countdown def.token:<server.flag[auto_shutdown_token]>

auto_shutdown__countdown:
  type: task
  debug: false
  definitions: token
  script:
  - if !<[token].exists>:
    - stop
  - wait 23h system
  - if !<server.has_flag[auto_shutdown_token]>:
    - stop
  - if <server.flag[auto_shutdown_token]> != <[token]>:
    - stop
  - if <server.online_players.size> > 0:
    - stop
  - flag server auto_shutdown_warned
  - define message "1시간 내에 아무도 접속하지 않으면 서버가 자동으로 종료됩니다"
  - run discord_webhook_send def.message:<[message]>
  - wait 1h system
  - if !<server.has_flag[auto_shutdown_token]>:
    - stop
  - if <server.flag[auto_shutdown_token]> != <[token]>:
    - stop
  - if <server.online_players.size> > 0:
    - stop
  - flag server auto_shutdown_token:!
  - flag server auto_shutdown_warned:!
  - execute as_server stop
