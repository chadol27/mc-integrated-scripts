ender_chest_extended__open:
  type: task
  debug: false
  script:
  - define inventory <inventory[ender_chest_extended__inventory]>
  - if <player.has_flag[ender_chest_extended_contents]>:
    - adjust <[inventory]> "contents:<player.flag[ender_chest_extended_contents]>"
  - inventory open destination:<[inventory]>
  - run util_sound_default

ender_chest_extended__close_event:
  type: world
  debug: false
  events:
    after player closes ender_chest_extended__inventory:
    - flag <player> "ender_chest_extended_contents:<context.inventory.list_contents>"

ender_chest_extended__inventory:
  type: inventory
  inventory: CHEST
  size: 54
  title: 확장 엔더 상자
