anti_explode__event:
  type: world
  debug: false
  events:
    on creeper explodes priority:-1:
    - determine <list[]>
    on entity explodes in:anti_explode_cuboid:
    - if <context.entity> matches wind_charge|breeze_wind_charge|wither_skull:
      - determine <list[]>
    - define message "<&[error]>폭발 방지 구역에서 엔티티 폭발이 발생해 취소되었습니다<n><reset>- <context.entity.type>, <proc[util_location_format].context[<context.location>]>"
    - narrate <[message]> targets:<context.location.find_players_within[50]>
    - announce to_console <[message]>
    - determine cancelled
    on block explodes in:anti_explode_cuboid:
    - define message "<&[error]>폭발 방지 구역에서 블록 폭발이 발생해 취소되었습니다<n><reset>- <proc[util_location_format].context[<context.block>]>"
    - narrate <[message]> targets:<context.block.find_players_within[50]>
    - announce to_console <[message]>
    - determine <list[]>
    on entity damaged by BLOCK_EXPLOSION in:anti_explode_cuboid:
    - if <context.entity.is_player>:
      - stop
    - determine cancelled
    on entity damaged by ENTITY_EXPLOSION in:anti_explode_cuboid:
    - if <context.entity.is_player>:
      - stop
    - determine cancelled

anti_explode__command:
  type: command
  debug: false
  name: anti_explode
  description: anti_explode
  usage: /anti_explode loc1|loc2|add|remove|list|test|show|showall|clear
  aliases:
  - ae
  permission: chadol.anti_explode.command
  tab completions:
    1: loc1|loc2|add|remove|list|test|show|clear|showall
  script:
  # loc1
  - if <context.args.first> == loc1:
    - flag <player> anti_explode_loc1:<player.location.with_y[-60]>
    - narrate "Location 1: <player.flag[anti_explode_loc1]>"
  # loc2
  - else if <context.args.first> == loc2:
    - flag <player> anti_explode_loc2:<player.location.with_y[320]>
    - narrate "Location 2: <player.flag[anti_explode_loc2]>"
  # add
  - else if <context.args.first> == add:
    - if !(<player.has_flag[anti_explode_loc1]> && <player.has_flag[anti_explode_loc2]>):
      - narrate "<&[error]>No location. /anti_explode loc1|loc2"

    - define cuboid <player.flag[anti_explode_loc1].to_cuboid[<player.flag[anti_explode_loc2]>]>
    - if <cuboid[anti_explode_cuboid].exists>:
      - note <cuboid[anti_explode_cuboid].add_member[<[cuboid]>]> as:anti_explode_cuboid
    - else:
      - note <[cuboid]> as:anti_explode_cuboid
    - narrate "Cuboid added: <[cuboid]>"
    - announce to_console "Anti Explode Cuboid Added: <[cuboid]>"
  # remove
  - else if <context.args.first> == remove:
    - define members <cuboid[anti_explode_cuboid].list_members>
    - if !<[members].exists> || <[members].size> == 0:
      - narrate "<&[error]>No cuboids. /anti_explode add"
      - stop
    - if !<context.args.get[2].is_integer>:
      - narrate "<&[error]>Usage: /anti_explode remove <&lt>number<&gt>"
      - stop
    - if <context.args.get[2]> < 1 || <context.args.get[2]> > <[members].size>:
      - narrate "<&[error]>Out of range. 1-<[members].size>"
      - stop
    - adjust <cuboid[anti_explode_cuboid]> remove_member:<context.args.get[2]>
    - narrate "Cuboid removed: <context.args.get[2]>"
    - announce to_console "Anti Explode Cuboid Removed: <context.args.get[2]>"
  # list
  - else if <context.args.first> == list:
    - narrate "Cuboid List: "
    - foreach <cuboid[anti_explode_cuboid].list_members> as:cuboid:
      - narrate "- <[cuboid].min.simple>:<[cuboid].max.simple>"
  # test
  - else if <context.args.first> == test:
    - narrate <cuboid[anti_explode_cuboid].contains[<player.location>]>
  # show
  - else if <context.args.first> == show:
    - define members <cuboid[anti_explode_cuboid].list_members>
    - if !<[members].exists> || <[members].size> == 0:
      - narrate "<&[error]>No cuboids. /anti_explode add"
      - stop
    - if !<context.args.get[2].is_integer>:
      - narrate "<&[error]>Usage: /anti_explode show <&lt>number<&gt>"
      - stop
    - if <context.args.get[2]> < 1 || <context.args.get[2]> > <[members].size>:
      - narrate "<&[error]>Out of range. 1-<[members].size>"
      - stop
    - define cuboid <[members].get[<context.args.get[2]>]>
    - showfake red_concrete <[cuboid].outline_2d[<player.location.y>]>
    - narrate "Showed: <context.args.get[2]>/<[members].size>"
  # showall
  - else if <context.args.first> == showall:
    - showfake red_concrete <cuboid[anti_explode_cuboid].outline_2d[<player.location.y>]>
    - narrate Showed
  # clear
  - else if <context.args.first> == clear:
    - note remove as:anti_explode_cuboid
    - narrate Cleared
  # error
  - else:
    - narrate "<&[error]>Unknown command"
