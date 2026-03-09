special_items__mythic_netherite_pickaxe:
  type: item
  material: netherite_pickaxe
  display name: <red>[Mythic] 효율 8 네더라이트 곡괭이
  lore:
  - 신화 아이템입니다
  mechanisms:
    unbreakable: true
  enchantments:
  - efficiency:8
  allow in material recipes: false

special_items__mythic_netherite_helmet:
  type: item
  material: netherite_helmet
  display name: <red>[Mythic] 보호 5 네더라이트 투구
  lore:
  - 신화 아이템입니다
  mechanisms:
    unbreakable: true
  enchantments:
  - protection:5
  allow in material recipes: false

special_items__mythic_netherite_chestplate:
  type: item
  material: netherite_chestplate
  display name: <red>[Mythic] 보호 5 네더라이트 흉갑
  lore:
  - 신화 아이템입니다
  mechanisms:
    unbreakable: true
  enchantments:
  - protection:5
  allow in material recipes: false

special_items__mythic_netherite_leggings:
  type: item
  material: netherite_leggings
  display name: <red>[Mythic] 보호 5 네더라이트 레깅스
  lore:
  - 신화 아이템입니다
  mechanisms:
    unbreakable: true
  enchantments:
  - protection:5
  allow in material recipes: false

special_items__mythic_netherite_boots:
  type: item
  material: netherite_boots
  display name: <red>[Mythic] 보호 5 네더라이트 부츠
  lore:
  - 신화 아이템입니다
  mechanisms:
    unbreakable: true
  enchantments:
  - protection:5
  allow in material recipes: false

special_items__mythic_totem_of_undying:
  type: item
  material: totem_of_undying
  display name: <red>[Mythic] 64중첩 불사의 토템
  lore:
  - 신화 아이템입니다
  mechanisms:
    components_patch: <map[max_stack_size=int:64]>
  allow in material recipes: false

special_items__mythic_command:
  type: command
  debug: false
  name: special_items__mythic_all
  description: give all mythic items for debug
  usage: /special_items__mythic_all
  aliases:
  - sima
  permission: chadol.special_items.command
  script:
  - if <context.server>:
    - announce to_console "<&[error]>이 명령어는 플레이어만 사용할 수 있습니다"
    - stop
  - define mythic_scripts <list[]>
  - foreach <util.scripts> as:loaded_script:
    - if <[loaded_script].container_type> != item:
      - foreach next
    - if !<[loaded_script].name.starts_with[special_items__mythic_]>:
      - foreach next
    - define mythic_scripts:->:<[loaded_script].name>
  - if <[mythic_scripts].is_empty>:
    - narrate "<&[error]>지급할 mythic 아이템 스크립트가 없습니다"
    - stop
  - foreach <[mythic_scripts]> as:mythic_script:
    - give <item[<[mythic_script]>]>
  - narrate "<&[emphasis]>Mythic 아이템 <[mythic_scripts].size>개를 지급했습니다"

special_items__mythic_clear_command:
  type: command
  debug: false
  name: special_items__mythic_clear
  description: remove all mythic items from inventory for debug
  usage: /special_items__mythic_clear
  aliases:
  - simc
  permission: chadol.special_items.command
  script:
  - if <context.server>:
    - announce to_console "<&[error]>이 명령어는 플레이어만 사용할 수 있습니다"
    - stop
  - define removed_count 0
  - foreach <player.inventory.map_slots> key:slot as:slot_item:
    - if <[slot_item]> matches special_items__mythic_*:
      - take slot:<[slot]> quantity:999 from:<player.inventory>
      - define removed_count:+:1
  - narrate "<&[emphasis]>Mythic 아이템 <[removed_count]>개를 인벤토리에서 제거했습니다"
