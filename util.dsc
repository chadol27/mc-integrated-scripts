util_location_format:
  type: procedure
  debug: false
  definitions: location
  script:
  # - determine "[<[location].world.name>] <[location].x.round>, <[location].y.round>, <[location].z.round>"
  - determine <[location].round_down.format[[world] bx, by, bz]>

util_location_facing:
  type: procedure
  debug: false
  definitions: location
  script:
  - define yaw <[location].yaw.raw>
  - if <[yaw]> < 45 || <[yaw]> >= 315:
      - determine "south (Z+)"
  - else if <[yaw]> < 135:
      - determine "west (X-)"
  - else if <[yaw]> < 225:
      - determine "north (Z-)"
  - else:
      - determine "east (X+)"

util_sound_yes:
  type: task
  debug: false
  script:
  - playsound <player> sound:ENTITY_PLAYER_LEVELUP sound_category:MASTER

util_sound_no:
  type: task
  debug: false
  script:
  - playsound <player> sound:BLOCK_ANVIL_LAND sound_category:MASTER

util_sound_default:
  type: task
  debug: false
  script:
  - playsound <player> sound:UI_BUTTON_CLICK sound_category:MASTER

util_sec_to_hms:
  type: procedure
  debug: false
  definitions: seconds
  script:
  - define d <[seconds].div[86400].round_down>
  - define h <[seconds].mod[86400].div[3600].round_down>
  - define m <[seconds].mod[3600].div[60].round_down>
  - define s <[seconds].mod[60]>
  - if <[d]> > 0:
    - determine "<[d]>d <[h]>h <[m]>m <[s]>s"
  - else if <[h]> > 0:
    - determine "<[h]>h <[m]>m <[s]>s"
  - else if <[m]> > 0:
    - determine "<[m]>m <[s]>s"
  - else:
    - determine <[s]>s

util_tick_to_ms:
  type: procedure
  debug: false
  definitions: tick
  script:
  - define hour <[tick].div[1000].add[6].mod[24].round_down>
  - define minute <[tick].mod[1000].mul[60].div[1000].round_down>

  - define hh <[hour].pad_left[2].with[0]>
  - define mm <[minute].pad_left[2].with[0]>

  - determine <[hh]>:<[mm]>
