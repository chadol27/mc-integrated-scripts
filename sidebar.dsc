sidebar__loop:
  type: world
  debug: false
  events:
    after delta time secondly:
    - foreach <server.online_players> as:player:
      - if <[player].has_flag[time_played]>:
        - flag <[player]> time_played:+:1
      - else:
        - flag <[player]> time_played:0

      - if <[player].has_flag[sidebar_off]>:
        - sidebar remove players:<[player]>
        - foreach next

      - define time_played <[player].flag[time_played]>

      - define values <list[]>
      - define values <[values].include[<&[emphasis]><italic><&lt>자바/베드락 통합<&gt>]>
      - define values <[values].include[<&[base]>접속 중: <reset>(<server.online_players.size>/<server.max_players>)명]>
      - define values <[values].include[<&[base]>좌표:]>
      - define values <[values].include[- <proc[util_location_format].context[<[player].location>]>]>
      - define values <[values].include[- <proc[util_location_facing].context[<[player].location>]>]>
      - define values <[values].include[<&[base]>인게임: <reset><proc[util_tick_to_ms].context[<[player].location.world.time>]>]>
      - define values <[values].include[<&[base]>플레이: <reset><proc[util_sec_to_hms].context[<[time_played]>]>]>

      - sidebar set "title:<green><bold>CHADOL <gold>야생 서버" values:<[values]>
        players:<[player]>
