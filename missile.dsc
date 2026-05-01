missile__launch:
  type: task
  debug: false
  definitions: shooter|target
  script:
  - flag server missile_in_progress
  - if !<[shooter].location.exists> || !<[target].location.exists>:
    - flag server missile_in_progress:!
    - narrate "<&[error]>미사일을 발사할 수 없습니다. 발사자 또는 타겟의 위치를 확인할 수 없습니다." targets:<[shooter]>
    - stop
  - define shooter_launch_location <[shooter].location>
  - define missile_location <[shooter_launch_location].add[0,1.2,0]>
  - define missile_speed 0.1
  - define missile_velocity <location[0,1,0].mul[<[missile_speed]>]>
  - repeat 600 as:tick:
    - if !<[target].is_online>:
      - flag server missile_in_progress:!
      - narrate "<&[error]>미사일 추적이 중단되었습니다. 타겟이 오프라인 상태입니다." targets:<[shooter]>
      - repeat stop
    - if !<[target].location.exists>:
      - flag server missile_in_progress:!
      - narrate "<&[error]>미사일 추적이 중단되었습니다. 타겟의 위치를 확인할 수 없습니다." targets:<[shooter]>
      - repeat stop
    - if <[shooter_launch_location].world.name> != <[target].location.world.name>:
      - flag server missile_in_progress:!
      - narrate "<&[error]>미사일 추적이 중단되었습니다. 타겟이 다른 월드로 이동했습니다." targets:<[shooter]>
      - repeat stop
    - define target_location <[target].location>
    - define missile_speed <[missile_speed].add[0.02]>
    - define target_distance <[missile_location].distance[<[target_location]>]>
    - if <[tick]> > 8:
      - define to_target <[target_location].sub[<[missile_location]>]>
      - define desired_direction <[to_target].normalize>
      - if <[target_distance]> <= 12:
        - define missile_current_weight 0.5
        - define missile_target_weight 0.5
      - else if <[target_distance]> <= 25:
        - define missile_current_weight 0.8
        - define missile_target_weight 0.2
      - else:
        - define missile_current_weight 0.9
        - define missile_target_weight 0.1
      - define current_direction_weighted <[missile_velocity].normalize.mul[<[missile_current_weight]>]>
      - define target_direction_weighted <[desired_direction].mul[<[missile_target_weight]>]>
      - define missile_direction <[current_direction_weighted].add[<[target_direction_weighted]>].normalize>
      - define missile_velocity <[missile_direction].mul[<[missile_speed]>]>
    - else:
      - define missile_velocity <[missile_velocity].normalize.mul[<[missile_speed]>]>
    - define missile_location <[missile_location].add[<[missile_velocity]>]>
    - fakespawn primed_tnt <[missile_location]> players:<[missile_location].find_players_within[64]> duration:5t
    - if <[tick].mod[2]> == 0:
      - playsound <[missile_location]> sound:BLOCK_NOTE_BLOCK_PLING sound_category:MASTER volume:3.2 pitch:1.4

    - if <[missile_location].distance[<[target_location]>]> <= 4:
      - flag server missile_in_progress:!
      - playsound <[missile_location]> sound:ENTITY_GENERIC_EXPLODE sound_category:MASTER volume:1.5 pitch:0.9
      - playeffect effect:EXPLOSION_LARGE at:<[missile_location]> quantity:1 offset:0
      - playeffect effect:SMOKE_LARGE at:<[missile_location]> quantity:3 offset:0.5
      - execute as_server "damage <[target].name> 50 minecraft:player_explosion by <[shooter].name>" silent
      - repeat stop

    - if <[tick]> == 600:
      - flag server missile_in_progress:!
      - narrate "<&[warning]>미사일 추적 시간이 만료되었습니다." targets:<[shooter]>
    - wait 1t

missile__event:
  type: world
  debug: false
  events:
    on missile command:
    - if <context.source_type> != PLAYER:
      - announce to_console "미사일 명령어는 플레이어만 사용할 수 있습니다."
      - determine fulfilled
    - if <server.has_flag[missile_in_progress]>:
      - narrate "<&[error]>이미 미사일이 발사 중입니다. 잠시 후 다시 시도해 주세요." targets:<player>
      - determine fulfilled
    - if <context.args.size> < 1:
      - narrate "<&[error]>사용법: /missile <player>" targets:<player>
      - determine fulfilled
    - define target <server.match_player[<context.args.get[1]>]||null>
    - if !<[target].exists>:
      - narrate "<&[error]>온라인 플레이어를 찾지 못했습니다." targets:<player>
      - determine fulfilled
    - if !<player.location.exists> || !<[target].location.exists>:
      - narrate "<&[error]>타겟의 위치를 확인할 수 없습니다. 잠시 후 다시 시도해 주세요." targets:<player>
      - determine fulfilled
    - if <player.location.world.name> != <[target].location.world.name> || <player.location.distance[<[target].location>]> > 200:
      - narrate "<&[error]>타겟은 같은 월드의 200블럭 안에 있어야 합니다." targets:<player>
      - determine fulfilled
    - announce "<&lt><player.name><&gt> <[target].name>에게 미사일을 발사했습니다!"
    - run missile__launch def:<player>|<[target]>
    - determine fulfilled

missile__command:
  type: command
  debug: false
  name: missile
  description: fire a guided missile at an online player
  usage: /missile <&lt>player<&gt>
  permission: chadol.missile.command
  tab completions:
    1: <server.online_players.parse[name]>
  script:
  - stop
