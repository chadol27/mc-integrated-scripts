discord_webhook_send:
  type: task
  debug: false
  definitions: message
  script:
  - if !<[message].exists>:
    - stop
  - define payload <map.with[content].as[<[message]>].to_json>
  - ~webget <secret[discord_webhook]> method:POST data:<[payload]> headers:<map.with[Content-Type].as[application/json]> timeout:10s hide_failure save:discord_webhook_response

discord_webhook__event:
  type: world
  debug: false
  events:
    on server start:
    - define message "서버 켜짐"
    - run discord_webhook_send def.message:<[message]>
    on shutdown:
    - define message "서버 꺼짐"
    - run discord_webhook_send def.message:<[message]>