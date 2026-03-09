menu_gui__open_event:
  type: world
  debug: false
  events:
    after player starts sneaking:
    # 하늘을 보고 있음
    - if <player.location.pitch> < -85:
      - define gui <inventory[menu_gui__inventory]>
      - define night_vision_slot <[gui].find_item[menu_gui__night_vision_item]>
      - define sidebar_slot <[gui].find_item[menu_gui__sidebar_item]>
      - define difficulty_slot <[gui].find_item[menu_gui__difficulty_item]>
      # 야간 투시 현재 상태 표시
      - if <player.has_flag[night_vision]>:
        - inventory adjust destination:<[gui]> "display:<white>야간투시 끄기" slot:<[night_vision_slot]>
      - else:
        - inventory adjust destination:<[gui]> "display:<white>야간투시 켜기" slot:<[night_vision_slot]>
      # 사이드바 현재 상태 표시
      - if <player.has_flag[sidebar_off]>:
        - inventory adjust destination:<[gui]> "display:<white>사이드바 켜기" slot:<[sidebar_slot]>
      - else:
        - inventory adjust destination:<[gui]> "display:<white>사이드바 끄기" slot:<[sidebar_slot]>
      # 난이도 현재 상태 표시
      - define difficulty <player.location.world.difficulty>
      - if <[difficulty]> == EASY:
        - inventory adjust destination:<[gui]> "display:<white>난이도 설정 (현재: <&translate[key=options.difficulty.easy]>)" slot:<[difficulty_slot]>
      - else if <[difficulty]> == NORMAL:
        - inventory adjust destination:<[gui]> material:iron_sword slot:8
        - inventory adjust destination:<[gui]> "display:<white>난이도 설정 (현재: <&translate[key=options.difficulty.normal]>)" slot:<[difficulty_slot]>
      - else if <[difficulty]> == HARD:
        - inventory adjust destination:<[gui]> material:diamond_sword slot:8
        - inventory adjust destination:<[gui]> "display:<white>난이도 설정 (현재: <&translate[key=options.difficulty.hard]>)" slot:<[difficulty_slot]>

      - inventory open destination:<[gui]>
      - run util_sound_default

menu_gui__click_event:
  type: world
  debug: false
  events:
    after player clicks item in menu_gui__inventory:
    - inventory close
    - ratelimit <player> 5t
    # 규칙
    - if <context.item> matches menu_gui__rule_item:
      - run rule__show
    # 자살
    - if <context.item> matches menu_gui__suicide_item:
      - if <player.item_in_hand> matches totem_of_undying || <player.item_in_offhand> matches totem_of_undying:
        - narrate "<&[error]>실패: 불사의 토템을 장착하고 있습니다"
        - run util_sound_no
        - stop
      - kill
      - define message "<player.name> <red>자살"
      - announce <[message]>
      - announce <[message]> to_console
    # 엔더 상자
    - if <context.item> matches menu_gui__ender_chest_item:
      - if <player.name.starts_with[.]>:
        - wait 5t
      - inventory open destination:<player.enderchest>
      - run util_sound_default
    # 야간 투시
    - if <context.item> matches menu_gui__night_vision_item:
      - if <player.has_flag[night_vision]>:
        - flag <player> night_vision:!
        - cast NIGHT_VISION remove <player>
        - narrate "야간투시 <red>꺼짐"
      - else:
        - flag <player> night_vision
        - cast NIGHT_VISION duration:infinite amplifier:0 <player> no_ambient hide_particles no_icon no_clear
        - narrate "야간투시 <blue>켜짐"
      - run util_sound_yes
    # 사이드바
    - if <context.item> matches menu_gui__sidebar_item:
      - if <player.has_flag[sidebar_off]>:
        - flag <player> sidebar_off:!
        - narrate "사이드바 <blue>켜짐"
      - else:
        - flag <player> sidebar_off
        - sidebar remove players:<player>
        - narrate "사이드바 <red>꺼짐"
      - run util_sound_yes
    # 위치 공유
    - if <context.item> matches menu_gui__pos_share_item:
      - define message "<&lt><player.name><&gt> 위치 공유: <&[emphasis]><proc[util_location_format].context[<player.location>]>"
      - announce <[message]>
      - announce <[message]> to_console
      - run util_sound_yes
    # 아이템 이름 변경
    - if <context.item> matches menu_gui__name_change_item:
      - if <player.item_in_hand> matches air:
        - narrate "<&[error]>아이템을 들고 있지 않습니다"
        - run util_sound_no
        - stop
      - flag <player> name_change
      - adjust <player> edit_sign
      - run util_sound_default
    # 아이템 자랑
    - if <context.item> matches menu_gui__item_flex_item:
      - define item <player.item_in_hand>
      - if <[item]> matches air:
        - narrate "<&[error]>아이템을 들고 있지 않습니다"
        - run util_sound_no
        - stop
      - if <[item].display.exists>:
        - define itemname <&[emphasis]><[item].display><&[base]>(<[item].material.translated_name>/<[item].material.name>)
      - else:
        - define itemname <&[emphasis]><[item].material.translated_name><&[base]>(<[item].material.name>)
      - define itemcount <[item].quantity>
      - define itemcount_total <player.inventory.quantity_item[<[item].material.name>]>
      - define magic <yellow><magic>ABC<reset>
      - define message "<&lt><player.name><&gt> <[magic]><[itemname]><[magic]> <[itemcount]>개(총 <[itemcount_total]>개)를 자랑합니다"
      # 내구도
      - if <[item].max_durability> > 0:
        - define message "<[message]><n>- <&[base]>내구도 <reset><[item].max_durability.sub[<[item].durability>].div[<[item].max_durability>].mul[100].round>%"
      # 인챈트
      - foreach <[item].enchantment_map> key:key as:val:
        - define translated <&translate[key=enchantment.minecraft.<[key]>;fallback=<[key]>]>
        - define message "<[message]><n>- <&[base]><[translated]> <reset><[val]>"
      # 포션 효과
      - if <[item].effects_data.exists>:
        - foreach <[item].effects_data> as:effect_data:
          - if <[effect_data].contains[base_type]>:
            - define effect_key <[effect_data].get[type].if_null[<[effect_data].get[base_type]>].to_lowercase>
            - define effect_key <[effect_key].replace[long_].with[].replace[strong_].with[]>
            - define is_upgraded <[effect_data].get[upgraded].if_null[false]>
            - define is_extended <[effect_data].get[extended].if_null[false]>
            - define duration_text <empty>
            - if <[is_extended]>:
              - define duration_text " 시간 추가됨"
            - define level_text <empty>
            - if <[is_upgraded]>:
              - define level_text " II"
            - define translated <&translate[key=effect.minecraft.<[effect_key]>;fallback=<[effect_key]>]>
            - define message "<[message]><n>- <&[base]><[translated]><reset><[level_text]><[duration_text]>"
          - else if <[effect_data].contains[effect]>:
            - define effect_id <[effect_data].get[effect].to_lowercase>
            - define translated <&translate[key=effect.minecraft.<[effect_id]>;fallback=<[effect_id]>]>
            - define level <[effect_data].get[amplifier].if_null[0].add[1]>
            - define duration_text <empty>
            - if <[effect_data].contains[duration]>:
              - define duration_text " (<[effect_data].get[duration]>)"
            - define message "<[message]><n>- <&[base]><[translated]> <reset><[level]><[duration_text]>"
      # 셜커 상자 내용물 요약
      - if <[item].has_inventory> && <[item].material.name.to_uppercase.ends_with[SHULKER_BOX]>:
        - define unique_materials <list[]>
        - foreach <[item].inventory_contents> as:stack:
          - if <[stack].material.name> != AIR:
            - define mat <[stack].material.name>
            - if !<[unique_materials].contains[<[mat]>]>:
              - define unique_materials:->:<[mat]>
        - define shulker_entries <list[]>
        - foreach <[unique_materials]> as:mat:
          - define total 0
          - foreach <[item].inventory_contents> as:stack:
            - if <[stack].material.name> == <[mat]>:
              - define total:+:<[stack].quantity>
          - define shulker_entries:->:<[total]>/<[mat]>
        - if <[shulker_entries].is_empty>:
          - define message "<[message]><n>- <&[base]>비어 있음"
        - else:
          - define shulker_entries <[shulker_entries].sort_by_number[before[/]].reverse>
          - foreach <[shulker_entries]> as:entry:
            - define count <[entry].before[/]>
            - define mat <[entry].after[/]>
            - define translated <material[<[mat]>].translated_name>
            - define message "<[message]><n>- <&[base]><[translated]> <reset><[count]>개"
      # 마우스 호버
      - define message <&hover[<[item]>].type[SHOW_ITEM]><[message]><&end_hover>
      # 출력
      - announce <[message]>
      - announce <[message]> to_console
      - run util_sound_yes
    # 난이도 변경
    - if <context.item> matches menu_gui__difficulty_item:
      - define difficulty <player.location.world.difficulty>
      - if <[difficulty]> == EASY:
        - define new NORMAL
      - else if <[difficulty]> == NORMAL:
        - define new HARD
      - else:
        - define new EASY
      - foreach <server.worlds> as:world:
        - adjust <[world]> difficulty:<[new]>
      - define translated <&translate[key=options.difficulty.<[new].to_lowercase>]>
      - define message "<&[warning]><bold>=====서버 난이도 변경됨=====<n><reset><&lt><player.name><&gt> 난이도를 <&[emphasis]><[translated]><reset>(으)로 변경했습니다"
      - announce <[message]>
      - announce <[message]> to_console
      - run util_sound_yes
    # 플레이 시간 랭킹
    - if <context.item> matches menu_gui__ranking_item:
      - define message <proc[menu_gui__playtime_ranking_message]>
      - narrate <[message]>
      - run util_sound_default
    # 낚시 횟수 랭킹
    - if <context.item> matches menu_gui__fishing_ranking_item:
      - define message <proc[menu_gui__fishing_ranking_message]>
      - narrate <[message]>
      - run util_sound_default
    # 낚시 아이템 목록
    - if <context.item> matches menu_gui__fishing_loot_item:
      - run fishing__show_loot_list def:<player>
      - run util_sound_default

menu_gui__night_vision_event:
  type: world
  debug: false
  events:
    after delta time secondly:
    - foreach <server.online_players_flagged[night_vision]> as:loop_player:
      - if !<[loop_player].has_effect[NIGHT_VISION]>:
        - cast NIGHT_VISION duration:infinite amplifier:0 <[loop_player]> no_ambient hide_particles no_icon no_clear

menu_gui__name_change_event:
  type: world
  debug: false
  events:
    after player changes sign flagged:name_change:
    - define old_name <player.item_in_hand.material.name>
    - define new_name <context.new.first>
    - inventory adjust slot:hand display:<[new_name]>
    - flag <player> name_change:!
    - narrate "<[old_name]>의 이름을 <&[emphasis]>'<[new_name]>'<reset>(으)로 변경했습니다"
    - run util_sound_yes

menu_gui__ranking_command:
  type: command
  debug: false
  name: ranking
  description: show ranking
  usage: /ranking playtime|fishing
  aliases:
  - rank
  permission: chadol.menu_gui.command
  tab completions:
    1: playtime|fishing
  script:
  - define ranking_type <context.args.first.if_null[playtime]>
  - if <[ranking_type]> == playtime:
    - define message <proc[menu_gui__playtime_ranking_message]>
  - else if <[ranking_type]> == fishing:
    - define message <proc[menu_gui__fishing_ranking_message]>
  - else:
    - if <context.server>:
      - announce to_console "<&[error]>Usage: /ranking playtime|fishing"
    - else:
      - narrate "<&[error]>Usage: /ranking playtime|fishing"
    - stop
  - if <context.server>:
    - announce to_console <[message]>
  - else:
    - narrate <[message]>
    - run util_sound_default

menu_gui__playtime_ranking_message:
  type: procedure
  debug: false
  script:
  - define message " <n><&[emphasis]>서버 플레이 시간 랭킹"
  - define index 1
  - define list <server.players.sort_by_number[flag[time_played]].reverse.first[7]>
  - foreach <[list]> as:loop_player:
    - define message "<[message]><n><reset><[index]>. <&[base]><bold><[loop_player].name>: <reset><proc[util_sec_to_hms].context[<[loop_player].flag[time_played]>]>"
    - define index:+:1
  - determine <[message]>

menu_gui__fishing_ranking_message:
  type: procedure
  debug: false
  script:
  - define message " <n><&[emphasis]>서버 낚시 횟수 랭킹"
  - define index 1
  - define rank_entries <list[]>
  - foreach <server.players> as:loop_player:
    - define fish_count <[loop_player].flag[fishing_count].if_null[0]>
    - define rank_entries:->:<[fish_count]>/<[loop_player].uuid>
  - define list <[rank_entries].sort_by_number[before[/]].reverse.first[7]>
  - foreach <[list]> as:rank_entry:
    - define loop_player <player[<[rank_entry].after[/]>]>
    - define fish_count <[rank_entry].before[/]>
    - define rare_count <[loop_player].flag[fishing_rare_count].if_null[0]>
    - define legendary_count <[loop_player].flag[fishing_legendary_count].if_null[0]>
    - define mythic_count <[loop_player].flag[fishing_mythic_count].if_null[0]>
    - define message "<[message]><n><reset><[index]>. <&[base]><bold><[loop_player].name><reset><gray>: 낚시 <reset><[fish_count]>회<gray>, Rare <gold><[rare_count]>회<gray>, Legendary <&[emphasis]><[legendary_count]>회<gray>, Mythic <&[error]><[mythic_count]>회"
    - define index:+:1
  - determine <[message]>

menu_gui__inventory:
  type: inventory
  inventory: CHEST
  gui: true
  size: 27
  title: MENU
  slots:
  - [menu_gui__rule_item] [menu_gui__suicide_item] [menu_gui__ender_chest_item]
    [menu_gui__night_vision_item] [menu_gui__pos_share_item] [menu_gui__name_change_item]
    [menu_gui__item_flex_item] [menu_gui__difficulty_item] [menu_gui__ranking_item]
  - [menu_gui__sidebar_item] [menu_gui__fishing_loot_item] [menu_gui__fishing_ranking_item] [] [] [] [] [] []
  - [] [] [] [] [] [] [] [] []

menu_gui__rule_item:
  type: item
  material: writable_book
  display name: <white>규칙 & 안내 보기

menu_gui__suicide_item:
  type: item
  material: redstone_block
  display name: <white>자살하기

menu_gui__ender_chest_item:
  type: item
  material: ender_chest
  display name: <white>엔더 상자 열기

menu_gui__night_vision_item:
  type: item
  material: ender_eye
  display name: <white>야간투시 토글

menu_gui__sidebar_item:
  type: item
  material: paper
  display name: <white>사이드바 토글

menu_gui__pos_share_item:
  type: item
  material: compass
  display name: <white>현재 위치 공유하기

menu_gui__name_change_item:
  type: item
  material: name_tag
  display name: <white>현재 들고 있는 아이템 이름 변경 (표지판 첫 줄에 입력)

menu_gui__item_flex_item:
  type: item
  material: enchanted_golden_apple
  display name: <white>현재 들고 있는 아이템 자랑하기

menu_gui__difficulty_item:
  type: item
  material: wooden_sword
  display name: <white>난이도 설정

menu_gui__ranking_item:
  type: item
  material: player_head
  display name: <white>플레이 시간 랭킹 보기

menu_gui__fishing_loot_item:
  type: item
  material: fishing_rod
  display name: <white>낚시 아이템 목록 보기

menu_gui__fishing_ranking_item:
  type: item
  material: cod
  display name: <white>낚시 횟수 랭킹 보기
