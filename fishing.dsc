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
  rare_percent_luck_0: 0.0
  rare_percent_luck_1: 2.0
  rare_percent_luck_2: 5.0
  rare_percent_luck_3: 7.5
  legendary_percent_luck_0: 0.0
  legendary_percent_luck_1: 0.05
  legendary_percent_luck_2: 0.1
  legendary_percent_luck_3: 0.3
  mythic_percent_luck_0: 0.0
  mythic_percent_luck_1: 0.0
  mythic_percent_luck_2: 0.0
  mythic_percent_luck_3: 0.05
  rare_items:
  - redstone_block[quantity=5]
  - gold_block[quantity=5]
  - lapis_block[quantity=5]
  - emerald_block[quantity=3]
  - diamond_block
  - netherite_scrap
  - totem_of_undying
  - shulker_shell
  - wither_skeleton_skull
  - golden_apple
  - glow_ink_sac[quantity=5]
  - breeze_rod[quantity=10]
  - quartz[quantity=32]
  legendary_items:
  - fishing__wind_burst_book
  - enchanted_golden_apple
  - trident
  - heavy_core
  - nether_star
  mythic_items:
  - special_items__mythic_netherite_pickaxe
  - special_items__mythic_netherite_helmet
  - special_items__mythic_netherite_chestplate
  - special_items__mythic_netherite_leggings
  - special_items__mythic_netherite_boots
  - special_items__mythic_totem_of_undying[quantity=64]

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
    # fish_caught 통계 증가값을 즉시 플래그에 캐시
    on player statistic fish_caught increments:
    - flag <player> fishing_count:<context.new_value>
    on player fishes while CAUGHT_FISH:
    # 열린 수역이 아니면 특수 아이템 판정을 하지 않음
    - if !<context.hook.fish_hook_in_open_water.if_null[false]>:
      - narrate "<&[error]>경고: 열린 수역이 아닙니다. <reset>자동 낚시 방지를 위해 보물(바닐라)과 특수 어획물(플러그인)이 나오지 않습니다. 5x5x2의 물 위 5x5x2만큼 공기여야 합니다."
      - run util_sound_no
      - stop
    # 행운 인챈트 레벨 정규화
    - define luck_level <player.item_in_hand.enchantment_map.get[luck_of_the_sea].if_null[0]>
    - define luck_level <[luck_level].max[0].min[3]>
    # 배율 적용된 퍼센트 확률 계산
    - define chance_multiplier <server.flag[fishing_chance_multiplier].if_null[1.0]>
    - define rare_percent <script[fishing__data].data_key[rare_percent_luck_<[luck_level]>].mul[<[chance_multiplier]>]>
    - define legendary_percent <script[fishing__data].data_key[legendary_percent_luck_<[luck_level]>].mul[<[chance_multiplier]>]>
    - define mythic_percent <script[fishing__data].data_key[mythic_percent_luck_<[luck_level]>].mul[<[chance_multiplier]>]>
    # Mythic 우선 판정
    - if <util.random_chance[<[mythic_percent]>]>:
      - define reward_key <script[fishing__data].data_key[mythic_items].random>
      - define reward <item[<[reward_key]>]>
      - define reward_name <[reward].material.translated_name>
      - define reward_name <&hover[<[reward]>].type[SHOW_ITEM]><&f><[reward_name]><&end_hover>
      - define reward_qty_text <empty>
      - define reward_enchants <list[]>
      - foreach <[reward].enchantment_map> key:key as:val:
        - define translated <&translate[key=enchantment.minecraft.<[key]>;fallback=<[key]>]>
        - define "reward_enchants:->:<[translated]> Lv.<[val]>"
      - define enchant_text <empty>
      - if <[reward].material.name> == enchanted_book && !<[reward_enchants].is_empty>:
        - define enchant_text " <gray>(<[reward_enchants].separated_by[<gray>, ]>)"
      - if <[reward].quantity> > 1:
        - define reward_qty_text " <gray>x<[reward].quantity>"
      - flag <player> fishing_mythic_count:+:1
      - define fish_count <player.statistic[fish_caught].if_null[0]>
      - define mythic_percent_display <[mythic_percent].mul[100].round.div[100]>
      - define message "<&lt><player.name><&gt> <&[error]>[Mythic]<reset> <[reward_name]><reset><[reward_qty_text]>(을)를 낚았습니다 <gray>(낚시 <[fish_count]>회, 확률 <[mythic_percent_display]>% 돌파)"
      - narrate "<&[error]>[Mythic] 신화 어획물 발견! <&f><[reward_name]><[reward_qty_text]><[enchant_text]>"
      - announce <[message]>
      - announce to_console <[message]>
      - foreach <server.online_players> as:loop_player:
        - playsound <[loop_player]> sound:minecraft:ui.toast.challenge_complete sound_category:MASTER volume:1 pitch:1
      - determine CAUGHT:<[reward]>
      - stop
    # 남은 구간에서 Legendary 판정
    - else if <util.random_chance[<[legendary_percent]>]>:
      - define reward_key <script[fishing__data].data_key[legendary_items].random>
      - define reward <item[<[reward_key]>]>
      - define reward_name <[reward].material.translated_name>
      - define reward_name <&hover[<[reward]>].type[SHOW_ITEM]><&f><[reward_name]><&end_hover>
      - define reward_qty_text <empty>
      - define reward_enchants <list[]>
      - foreach <[reward].enchantment_map> key:key as:val:
        - define translated <&translate[key=enchantment.minecraft.<[key]>;fallback=<[key]>]>
        - define "reward_enchants:->:<[translated]> Lv.<[val]>"
      - define enchant_text <empty>
      - if <[reward].material.name> == enchanted_book && !<[reward_enchants].is_empty>:
        - define enchant_text " <gray>(<[reward_enchants].separated_by[<gray>, ]>)"
      - if <[reward].quantity> > 1:
        - define reward_qty_text " <gray>x<[reward].quantity>"
      - flag <player> fishing_legendary_count:+:1
      - define fish_count <player.statistic[fish_caught].if_null[0]>
      - define legendary_percent_display <[legendary_percent].mul[100].round.div[100]>
      - define message "<&lt><player.name><&gt> <&[emphasis]>[Legendary]<reset> <[reward_name]><reset><[reward_qty_text]>(을)를 낚았습니다 <gray>(낚시 <[fish_count]>회, 확률 <[legendary_percent_display]>% 돌파)"
      - narrate "<&[emphasis]>[Legendary] 희귀 어획물 발견! <&f><[reward_name]><[reward_qty_text]><[enchant_text]>"
      - announce <[message]>
      - announce to_console <[message]>
      - foreach <server.online_players> as:loop_player:
        - playsound <[loop_player]> sound:minecraft:ui.toast.challenge_complete sound_category:MASTER volume:1 pitch:1
      - determine CAUGHT:<[reward]>
      - stop
    # 남은 구간에서 Rare 판정
    - else if <util.random_chance[<[rare_percent]>]>:
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
      - define fish_count <[p].flag[fishing_count].if_null[0]>
      - define chance_multiplier <server.flag[fishing_chance_multiplier].if_null[1.0]>
      - define rare_percent <script[fishing__data].data_key[rare_percent_luck_<[luck_level]>].mul[<[chance_multiplier]>]>
      - define legendary_percent <script[fishing__data].data_key[legendary_percent_luck_<[luck_level]>].mul[<[chance_multiplier]>]>
      - define mythic_percent <script[fishing__data].data_key[mythic_percent_luck_<[luck_level]>].mul[<[chance_multiplier]>]>
      - define rare_percent_display <[rare_percent].mul[100].round.div[100]>
      - define legendary_percent_display <[legendary_percent].mul[100].round.div[100]>
      - define mythic_percent_display <[mythic_percent].mul[100].round.div[100]>
      - define rare_count <[p].flag[fishing_rare_count].if_null[0]>
      - define legendary_count <[p].flag[fishing_legendary_count].if_null[0]>
      - define mythic_count <[p].flag[fishing_mythic_count].if_null[0]>
      - actionbar "<&[warning]><[rare_percent_display]><gray>/<&[emphasis]><[legendary_percent_display]><gray>/<&[error]><[mythic_percent_display]><gray>% (x<[chance_multiplier]>) <white><[fish_count]><gray>/<&[warning]><[rare_count]><gray>/<&[emphasis]><[legendary_count]><gray>/<&[error]><[mythic_count]><gray>회" targets:<[p]>
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
  - define mythic_items <script[fishing__data].data_key[mythic_items]>
  - define message " <n><&[emphasis]>낚시 아이템 목록<n><&[emphasis]>확률표 (바다의 행운)"
  - foreach <list[0|1|2|3]> as:luck:
    - define rare_percent <script[fishing__data].data_key[rare_percent_luck_<[luck]>]>
    - define legendary_percent <script[fishing__data].data_key[legendary_percent_luck_<[luck]>]>
    - define mythic_percent <script[fishing__data].data_key[mythic_percent_luck_<[luck]>]>
    - define message "<[message]><n>- <white>Lv.<[luck]><gray>: <gold>Rare <white><[rare_percent]>%<gray> / <&[emphasis]>Legendary <white><[legendary_percent]>%<gray> / <&[error]>Mythic <white><[mythic_percent]>%"
  - define message "<[message]><n> <n><gold>[Rare]"
  - foreach <[rare_items]> as:reward_key:
    - define message <[message]><n><proc[fishing__format_loot_line].context[<[reward_key]>]>
  - define message <[message]><n><&[emphasis]>[Legendary]<reset>
  - foreach <[legendary_items]> as:reward_key:
    - define message <[message]><n><proc[fishing__format_loot_line].context[<[reward_key]>]>
  - define message <[message]><n><&[error]>[Mythic]<reset>
  - foreach <[mythic_items]> as:reward_key:
    - define message <[message]><n><proc[fishing__format_loot_line].context[<[reward_key]>]>
  - narrate <[message]> targets:<[target]>

fishing__format_loot_line:
  type: procedure
  debug: false
  definitions: reward_key
  script:
  - define reward <item[<[reward_key]>]>
  - if <[reward].display.exists>:
    - define reward_name <[reward].display>
  - else:
    - define reward_name <[reward].material.translated_name>
  - define reward_name <&hover[<[reward]>].type[SHOW_ITEM]><[reward_name]><&end_hover>
  - define reward_enchants <list[]>
  - foreach <[reward].enchantment_map> key:key as:val:
    - define translated <&translate[key=enchantment.minecraft.<[key]>;fallback=<[key]>]>
    - define "reward_enchants:->:<[translated]> Lv.<[val]>"
  - define enchant_text <empty>
  - if <[reward].material.name> == enchanted_book && !<[reward_enchants].is_empty>:
    - define enchant_text " <gray>(<[reward_enchants].separated_by[<gray>, ]>)"
  - if <[reward].quantity> > 1:
    - determine "<reset>- <[reward_name]> <gray>x<[reward].quantity><[enchant_text]>"
  - determine "<reset>- <[reward_name]><[enchant_text]>"
