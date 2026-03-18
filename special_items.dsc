special_items__mythic_trim_data:
  type: data
  allowed_patterns:
  - bolt
  - coast
  - dune
  - eye
  - flow
  - host
  - raiser
  - rib
  - sentry
  - shaper
  - silence
  - snout
  - spire
  - tide
  - vex
  - ward
  - wayfinder
  - wild
  allowed_materials:
  - amethyst
  - copper
  - diamond
  - emerald
  - gold
  - iron
  - lapis
  - netherite
  - quartz
  - redstone
  - resin

special_items__mythic_netherite_pickaxe:
  type: item
  material: netherite_pickaxe
  display name: <red>[Mythic] 효율 8 네더라이트 곡괭이
  lore:
  - 신화 아이템입니다
  - <gray>/mst로 섬손 토글 가능
  mechanisms:
    unbreakable: true
  enchantments:
  - efficiency:8
  allow in material recipes: false

special_items__mythic_netherite_sword:
  type: item
  material: netherite_sword
  display name: <red>[Mythic] 날카로움 7 네더라이트 검
  lore:
  - 신화 아이템입니다
  mechanisms:
    unbreakable: true
  enchantments:
  - sharpness:7
  - looting:3
  - sweeping_edge:3
  allow in material recipes: false

special_items__mythic_netherite_helmet:
  type: item
  material: netherite_helmet
  display name: <red>[Mythic] 보호 6 네더라이트 투구
  lore:
  - 신화 아이템입니다
  - <gray>/mtt로 가시 토글 가능
  - <gray>/mat <&lt>pattern<&gt> <&lt>material<&gt>로 장식 변경 가능
  mechanisms:
    unbreakable: true
  enchantments:
  - protection:6
  - aqua_affinity:1
  - respiration:3
  allow in material recipes: false

special_items__mythic_netherite_chestplate:
  type: item
  material: netherite_chestplate
  display name: <red>[Mythic] 보호 6 네더라이트 흉갑
  lore:
  - 신화 아이템입니다
  - <gray>/mtt로 가시 토글 가능
  - <gray>/mat <&lt>pattern<&gt> <&lt>material<&gt>로 장식 변경 가능
  mechanisms:
    unbreakable: true
  enchantments:
  - protection:6
  allow in material recipes: false

special_items__mythic_netherite_leggings:
  type: item
  material: netherite_leggings
  display name: <red>[Mythic] 보호 6 네더라이트 레깅스
  lore:
  - 신화 아이템입니다
  - <gray>/mtt로 가시 토글 가능
  - <gray>/mat <&lt>pattern<&gt> <&lt>material<&gt>로 장식 변경 가능
  mechanisms:
    unbreakable: true
  enchantments:
  - protection:6
  - swift_sneak:3
  allow in material recipes: false

special_items__mythic_netherite_boots:
  type: item
  material: netherite_boots
  display name: <red>[Mythic] 보호 6 네더라이트 부츠
  lore:
  - 신화 아이템입니다
  - <gray>/mtt로 가시 토글 가능
  - <gray>/mat <&lt>pattern<&gt> <&lt>material<&gt>로 장식 변경 가능
  mechanisms:
    unbreakable: true
  enchantments:
  - protection:6
  - feather_falling:4
  - depth_strider:3
  - soul_speed:3
  allow in material recipes: false

special_items__mythic_elytra:
  type: item
  material: elytra
  display name: <red>[Mythic] 부서지지 않는 겉날개
  lore:
  - 신화 아이템입니다
  mechanisms:
    unbreakable: true
  allow in material recipes: false

special_items__clorox:
  type: item
  material: potion
  debug: false
  display name: <white>락스
  mechanisms:
    color: white
    potion_effects: <list[[base_type=water]|[effect=wither;amplifier=0;duration=30;ambient=false;particles=true;icon=true]|[effect=poison;amplifier=4;duration=30;ambient=false;particles=true;icon=true]|[effect=instant_damage;amplifier=1;duration=1s;ambient=false;particles=true;icon=true]]>
  recipes:
    1:
      type: shapeless
      input: potion[potion_effects=[base_type=water]]|spider_eye|white_dye

special_items__clorox_event:
  type: world
  debug: false
  events:
    on player consumes item:
    - if <context.item> !matches special_items__clorox:
      - stop
    - announce "<&lt><player.name><&gt> <red>락스<reset>를 마셨습니다"
    - flag <player> special_items_clorox_recent expire:30s
    on player death flagged:special_items_clorox_recent:
    - define death_cause <context.cause.to_uppercase>
    - if !<list[POISON|WITHER|MAGIC].contains[<[death_cause]>]>:
      - stop
    - flag <player> special_items_clorox_recent:!
    - determine "<player.name>(이)가 락스를 마시고 죽었습니다"

special_items__mythic_station_lock_event:
  type: world
  debug: false
  events:
    on player clicks in anvil:
    - define blocked false
    - if <context.item> matches special_items__mythic_*:
      - define blocked true
    - if <context.cursor_item> matches special_items__mythic_*:
      - define blocked true
    - foreach <context.inventory.map_slots> key:slot as:slot_item:
      - if <[slot_item]> matches special_items__mythic_*:
        - define blocked true
    - if !<[blocked]>:
      - stop
    - narrate "<&[error]>Mythic 아이템은 모루에서 사용할 수 없습니다"
    - determine cancelled
    on player clicks in grindstone:
    - define blocked false
    - if <context.item> matches special_items__mythic_*:
      - define blocked true
    - if <context.cursor_item> matches special_items__mythic_*:
      - define blocked true
    - foreach <context.inventory.map_slots> key:slot as:slot_item:
      - if <[slot_item]> matches special_items__mythic_*:
        - define blocked true
    - if !<[blocked]>:
      - stop
    - narrate "<&[error]>Mythic 아이템은 숫돌에서 사용할 수 없습니다"
    - determine cancelled
    on player drags in anvil:
    - define blocked false
    - if <context.item> matches special_items__mythic_*:
      - define blocked true
    - foreach <context.inventory.map_slots> key:slot as:slot_item:
      - if <[slot_item]> matches special_items__mythic_*:
        - define blocked true
    - if !<[blocked]>:
      - stop
    - narrate "<&[error]>Mythic 아이템은 모루에서 사용할 수 없습니다"
    - determine cancelled
    on player drags in grindstone:
    - define blocked false
    - if <context.item> matches special_items__mythic_*:
      - define blocked true
    - foreach <context.inventory.map_slots> key:slot as:slot_item:
      - if <[slot_item]> matches special_items__mythic_*:
        - define blocked true
    - if !<[blocked]>:
      - stop
    - narrate "<&[error]>Mythic 아이템은 숫돌에서 사용할 수 없습니다"
    - determine cancelled

# special_items__mythic_command:
#   type: command
#   debug: false
#   name: special_items__mythic_all
#   description: give all mythic items for debug
#   usage: /special_items__mythic_all
#   aliases:
#   - sima
#   permission: chadol.special_items.command
#   script:
#   - if <context.server>:
#     - announce to_console "<&[error]>이 명령어는 플레이어만 사용할 수 있습니다"
#     - stop
#   - define mythic_scripts <list[]>
#   - foreach <util.scripts> as:loaded_script:
#     - if <[loaded_script].container_type> != item:
#       - foreach next
#     - if !<[loaded_script].name.starts_with[special_items__mythic_]>:
#       - foreach next
#     - define mythic_scripts:->:<[loaded_script].name>
#   - if <[mythic_scripts].is_empty>:
#     - narrate "<&[error]>지급할 mythic 아이템 스크립트가 없습니다"
#     - stop
#   - foreach <[mythic_scripts]> as:mythic_script:
#     - give <item[<[mythic_script]>]>
#   - narrate "<&[emphasis]>Mythic 아이템 <[mythic_scripts].size>개를 지급했습니다"

# special_items__mythic_clear_command:
#   type: command
#   debug: false
#   name: special_items__mythic_clear
#   description: remove all mythic items from inventory for debug
#   usage: /special_items__mythic_clear
#   aliases:
#   - simc
#   permission: chadol.special_items.command
#   script:
#   - if <context.server>:
#     - announce to_console "<&[error]>이 명령어는 플레이어만 사용할 수 있습니다"
#     - stop
#   - define removed_count 0
#   - foreach <player.inventory.map_slots> key:slot as:slot_item:
#     - if <[slot_item]> matches special_items__mythic_*:
#       - take slot:<[slot]> quantity:999 from:<player.inventory>
#       - define removed_count:+:1
#   - narrate "<&[emphasis]>Mythic 아이템 <[removed_count]>개를 인벤토리에서 제거했습니다"

special_items__mythic_silk_touch_command:
  type: command
  debug: false
  name: mythic_silk_touch
  description: toggle silk touch enchant on mythic netherite pickaxe
  usage: /mythic_silk_touch
  aliases:
  - mst
  permission: chadol.special_items.command
  script:
  - if <context.server>:
    - announce to_console "<&[error]>이 명령어는 플레이어만 사용할 수 있습니다"
    - stop
  - define held_item <player.item_in_hand>
  - if <[held_item]> !matches special_items__mythic_netherite_pickaxe:
    - narrate "<&[error]>손에 Mythic 네더라이트 곡괭이를 들고 있어야 합니다"
    - stop
  - define silk_touch_level <[held_item].enchantment_map.get[silk_touch].if_null[0]>
  - if <[silk_touch_level]> >= 1:
    - inventory adjust slot:hand remove_enchantments:<list[silk_touch]>
    - narrate "<&[warning]>섬세한 손길이 <red>꺼졌습니다"
    - stop
  - inventory adjust slot:hand enchantments:silk_touch=1
  - narrate "<&[warning]>섬세한 손길이 <blue>켜졌습니다"

special_items__mythic_thorns_toggle_command:
  type: command
  debug: false
  name: mythic_thorns_toggle
  description: toggle thorns enchant on mythic netherite armor
  usage: /mythic_thorns_toggle
  aliases:
  - mtt
  script:
  - if <context.server>:
    - announce to_console "<&[error]>이 명령어는 플레이어만 사용할 수 있습니다"
    - stop
  - define held_item <player.item_in_hand>
  - if <[held_item]> !matches special_items__mythic_netherite_helmet && <[held_item]> !matches special_items__mythic_netherite_chestplate && <[held_item]> !matches special_items__mythic_netherite_leggings && <[held_item]> !matches special_items__mythic_netherite_boots:
    - narrate "<&[error]>손에 Mythic 네더라이트 갑옷(투구, 흉갑, 레깅스, 부츠)을 들고 있어야 합니다"
    - stop
  - define thorns_level <[held_item].enchantment_map.get[thorns].if_null[0]>
  - if <[thorns_level]> >= 1:
    - inventory adjust slot:hand remove_enchantments:<list[thorns]>
    - narrate "<&[warning]>가시가 <red>꺼졌습니다"
    - stop
  - inventory adjust slot:hand enchantments:thorns=3
  - narrate "<&[warning]>가시가 <blue>켜졌습니다"

special_items__mythic_armor_trim_command:
  type: command
  debug: false
  name: mythic_armor_trim
  description: apply armor trim to mythic netherite armor
  usage: /mythic_armor_trim <&lt>pattern<&gt> <&lt>material<&gt>
  aliases:
  - mat
  tab completions:
    1: <script[special_items__mythic_trim_data].data_key[allowed_patterns].separated_by[|]>
    2: <script[special_items__mythic_trim_data].data_key[allowed_materials].separated_by[|]>
  script:
  - define usage "<&[error]>Usage: /mythic_armor_trim <&lt>pattern<&gt> <&lt>material<&gt>"
  - define allowed_patterns <script[special_items__mythic_trim_data].data_key[allowed_patterns]>
  - define allowed_materials <script[special_items__mythic_trim_data].data_key[allowed_materials]>
  - define patterns_text <[allowed_patterns].separated_by[<gray>, <white>]>
  - define materials_text <[allowed_materials].separated_by[<gray>, <white>]>
  - if <context.server>:
    - announce to_console "<&[error]>이 명령어는 플레이어만 사용할 수 있습니다"
    - stop
  - define held_item <player.item_in_hand>
  - if <[held_item]> !matches special_items__mythic_netherite_helmet && <[held_item]> !matches special_items__mythic_netherite_chestplate && <[held_item]> !matches special_items__mythic_netherite_leggings && <[held_item]> !matches special_items__mythic_netherite_boots:
    - narrate "<&[error]>손에 Mythic 네더라이트 갑옷(투구, 흉갑, 레깅스, 부츠)을 들고 있어야 합니다"
    - stop
  - if <context.args.size> < 2:
    - narrate <[usage]>
    - narrate "<white>Pattern: <[patterns_text]>"
    - narrate "<white>Material: <[materials_text]>"
    - stop
  - define trim_pattern <context.args.get[1].to_lowercase>
  - define trim_material <context.args.get[2].to_lowercase>
  - if !<[allowed_patterns].contains[<[trim_pattern]>]> || !<[allowed_materials].contains[<[trim_material]>]>:
    - narrate <[usage]>
    - narrate "<white>Pattern: <[patterns_text]>"
    - narrate "<white>Material: <[materials_text]>"
    - stop
  - inventory adjust slot:hand trim:[material=<[trim_material]>;pattern=<[trim_pattern]>]
  - narrate "<&[emphasis]>장식을 적용했습니다: <white><[trim_pattern]> <gray>/ <white><[trim_material]>"
