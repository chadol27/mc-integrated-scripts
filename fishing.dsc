fishing__data:
  type: data
  chance_multipliers:
  - 0.4
  - 0.5
  - 0.6
  - 0.7
  - 0.8
  - 0.8
  - 0.9
  - 0.9
  - 1.0
  - 1.0
  - 1.2
  - 1.3
  - 1.5
  - 2.0
  # 바다의 행운 레벨(0~3) 기준 등급별 확률(%)
  rare_percent_luck_0: 2.0
  rare_percent_luck_1: 3.0
  rare_percent_luck_2: 5.0
  rare_percent_luck_3: 7.5
  legendary_percent_luck_0: 0.0
  legendary_percent_luck_1: 0.1
  legendary_percent_luck_2: 0.25
  legendary_percent_luck_3: 0.5
  rare_items:
  - gold_block[quantity=5]
  - emerald_block[quantity=5]
  - lapis_block[quantity=5]
  - diamond_block
  - netherite_ingot
  - totem_of_undying
  - shulker_shell
  - wither_skeleton_skull
  - golden_apple
  - glow_ink_sac[quantity=5]
  - breeze_rod[quantity=10]
  - quartz[quantity=16]
  legendary_items:
  - fishing__wind_burst_book
  - enchanted_golden_apple
  - trident
  - heavy_core
  - nether_star

fishing__wind_burst_book:
  type: item
  material: enchanted_book
  enchantments:
  - wind_burst:3

fishing__swift_sneak_book:
  type: item
  material: enchanted_book
  enchantments:
  - swift_sneak:3

fishing__event:
  type: world
  debug: false
  events:
    on player fishes while CAUGHT_FISH:
    # 행운 인챈트 레벨 정규화
    - define luck_level <player.item_in_hand.enchantment_map.get[luck_of_the_sea].if_null[0]>
    - define luck_level <[luck_level].max[0].min[3]>
    # 퍼센트 값을 정수 범위(1~chance_scale) 판정값으로 변환
    - define chance_scale 100000
    - define chance_multiplier <server.flag[fishing_chance_multiplier].if_null[1.0]>
    - define rare_percent <script[fishing__data].data_key[rare_percent_luck_<[luck_level]>].mul[<[chance_multiplier]>]>
    - define legendary_percent <script[fishing__data].data_key[legendary_percent_luck_<[luck_level]>].mul[<[chance_multiplier]>]>
    - define rare_chance <[rare_percent].mul[<[chance_scale]>].div[100].round>
    - define legendary_chance <[legendary_percent].mul[<[chance_scale]>].div[100].round>
    - define roll <util.random.int[1].to[<[chance_scale]>]>
    # Legendary 우선 판정
    - if <[roll]> <= <[legendary_chance]>:
      - define reward_key <script[fishing__data].data_key[legendary_items].random>
      - define reward <item[<[reward_key]>]>
      - define reward_name <[reward].material.translated_name>
      - define reward_name <&hover[<[reward]>].type[SHOW_ITEM]><&f><[reward_name]><&end_hover>
      - define reward_qty_text <empty>
      - if <[reward].quantity> > 1:
        - define reward_qty_text " <gray>x<[reward].quantity>"
      - flag <player> fishing_legendary_count:+:1
      - define fish_count <player.statistic[fish_caught].if_null[0]>
      - define legendary_percent_display <[legendary_percent].mul[100].round.div[100]>
      - define message "<&lt><player.name><&gt> <&[emphasis]>[Legendary]<reset> <[reward_name]><reset><[reward_qty_text]>(을)를 낚았습니다 <gray>(낚시 <[fish_count]>회, 확률 <[legendary_percent_display]>% 돌파)"
      - narrate "<&[emphasis]>[Legendary] 희귀 어획물 발견! <&f><[reward_name]><[reward_qty_text]>"
      - announce <[message]>
      - announce to_console <[message]>
      - foreach <server.online_players> as:loop_player:
        - playsound <[loop_player]> sound:minecraft:ui.toast.challenge_complete sound_category:MASTER volume:1 pitch:1
      - determine CAUGHT:<[reward]>
      - stop
    # 남은 구간에서 Rare 판정
    - else if <[roll]> <= <[legendary_chance].add[<[rare_chance]>]>:
      - define reward_key <script[fishing__data].data_key[rare_items].random>
      - define reward <item[<[reward_key]>]>
      - define reward_name <[reward].material.translated_name>
      - define reward_qty_text <empty>
      - if <[reward].quantity> > 1:
        - define reward_qty_text " <gray>x<[reward].quantity>"
      - flag <player> fishing_rare_count:+:1
      - narrate "<&[emphasis]>[Rare] 희귀 어획물 발견! <&f><[reward_name]><[reward_qty_text]>"
      - determine CAUGHT:<[reward]>
      - stop
    - else:
      - stop
    on system time secondly:
    - if <server.online_players.is_empty>:
      - stop
    # 낚싯대 들고 있을 때만 실시간 확률/통계 액션바 표시
    - foreach <server.online_players> as:p:
      - if <[p].item_in_hand.material.name> != fishing_rod:
        - foreach next
      - define luck_level <[p].item_in_hand.enchantment_map.get[luck_of_the_sea].if_null[0]>
      - define luck_level <[luck_level].max[0].min[3]>
      - define fish_count <[p].statistic[fish_caught].if_null[0]>
      - define chance_multiplier <server.flag[fishing_chance_multiplier].if_null[1.0]>
      - define rare_percent <script[fishing__data].data_key[rare_percent_luck_<[luck_level]>].mul[<[chance_multiplier]>]>
      - define legendary_percent <script[fishing__data].data_key[legendary_percent_luck_<[luck_level]>].mul[<[chance_multiplier]>]>
      - define rare_percent_display <[rare_percent].mul[100].round.div[100]>
      - define legendary_percent_display <[legendary_percent].mul[100].round.div[100]>
      - define rare_count <[p].flag[fishing_rare_count].if_null[0]>
      - define legendary_count <[p].flag[fishing_legendary_count].if_null[0]>
      - actionbar "<&[emphasis]>낚시: <white><[fish_count]>회<reset> <gray>| <&[emphasis]>Rare: <white><[rare_percent_display]>% (<[rare_count]>회)<reset> <gray>| <&[emphasis]>Legendary: <white><[legendary_percent_display]>% (<[legendary_count]>회)<reset> <gray>| <&[emphasis]>배수: <white>x<[chance_multiplier]>" targets:<[p]>
    after delta time minutely every:10:
    - if <server.online_players.is_empty>:
      - stop
    - run fishing__reroll_multiplier

fishing__command:
  type: command
  debug: false
  name: fishing_multiplier
  description: reroll/show fishing chance multiplier
  usage: /fishing_multiplier reroll|show
  aliases:
  - fm
  permission: chadol.fishing.command
  tab completions:
    1: reroll|show
  script:
  - if <context.args.first.if_null[show]> == reroll:
    - run fishing__reroll_multiplier
    - narrate "<&[emphasis]>낚시 확률 배수를 다시 설정했습니다: <white>x<server.flag[fishing_chance_multiplier].if_null[1.0]>"
    - stop
  - if <context.args.first.if_null[show]> == show:
    - narrate "<&[emphasis]>현재 낚시 확률 배수: <white>x<server.flag[fishing_chance_multiplier].if_null[1.0]>"
    - stop
  - narrate "<&[error]>Usage: /fishing_multiplier reroll|show"

fishing__reroll_multiplier:
  type: task
  debug: false
  script:
  - define new_multiplier <script[fishing__data].data_key[chance_multipliers].random>
  - flag server fishing_chance_multiplier:<[new_multiplier]>
  - define message "<&[warning]>낚시 확률 배수가 변경되었습니다: <&[emphasis]>x<[new_multiplier]>"
  - announce <[message]>
  - announce to_console <[message]>

fishing__show_loot_list:
  type: task
  definitions: target
  debug: false
  script:
  # 메뉴에서 호출: 확률표 + 등급별 아이템 목록 채팅 출력
  - define rare_items <script[fishing__data].data_key[rare_items]>
  - define legendary_items <script[fishing__data].data_key[legendary_items]>
  - narrate " " targets:<[target]>
  - narrate "<&[emphasis]>낚시 아이템 목록" targets:<[target]>
  - narrate "<&[emphasis]>확률표 (바다의 행운)" targets:<[target]>
  - foreach <list[0|1|2|3]> as:luck:
    - define rare_percent <script[fishing__data].data_key[rare_percent_luck_<[luck]>]>
    - define legendary_percent <script[fishing__data].data_key[legendary_percent_luck_<[luck]>]>
    - narrate "- <white>Lv.<[luck]><gray>: <gold>Rare <white><[rare_percent]>%<gray> / <&[emphasis]>Legendary <white><[legendary_percent]>%" targets:<[target]>
  - narrate " " targets:<[target]>
  - narrate <gold>[Rare] targets:<[target]>
  - foreach <[rare_items]> as:reward_key:
    - define reward <item[<[reward_key]>]>
    - define reward_name <[reward].material.translated_name>
    - define reward_name <&hover[<[reward]>].type[SHOW_ITEM]><[reward_name]><&end_hover>
    - if <[reward].quantity> > 1:
      - narrate "- <[reward_name]> <gray>x<[reward].quantity>" targets:<[target]>
    - else:
      - narrate "- <[reward_name]>" targets:<[target]>
  - narrate <&[emphasis]>[Legendary] targets:<[target]>
  - foreach <[legendary_items]> as:reward_key:
    - define reward <item[<[reward_key]>]>
    - define reward_name <[reward].material.translated_name>
    - define reward_name <&hover[<[reward]>].type[SHOW_ITEM]><[reward_name]><&end_hover>
    - if <[reward].quantity> > 1:
      - narrate "- <[reward_name]> <gray>x<[reward].quantity>" targets:<[target]>
    - else:
      - narrate "- <[reward_name]>" targets:<[target]>
