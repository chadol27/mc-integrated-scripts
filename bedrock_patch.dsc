bedrock_patch__nether_ceiling:
  type: world
  debug: false
  events:
    after player teleported by portal to:world_nether:
      - if !<context.entity.name.starts_with[.]>:
        - stop
      - if <context.entity.location.y> >= 128:
        - define teleport_location <location[bedrock_patch_teleport_location].if_null[<location[0,0,0,world]>]>
        - teleport <context.entity> <[teleport_location]>
    on player places block in:bedrock_patch_teleport_protection:
      - if <player.gamemode> == CREATIVE:
        - stop
      - narrate "<&[error]>이 구역에서는 블럭을 설치할 수 없습니다."
      - determine cancelled
    on player breaks block in:bedrock_patch_teleport_protection:
      - if <player.gamemode> == CREATIVE:
        - stop
      - narrate "<&[error]>이 구역에서는 블럭을 부술 수 없습니다."
      - determine cancelled
    on player changes sign in:bedrock_patch_teleport_protection:
      - if <player.gamemode> == CREATIVE:
        - stop
      - narrate "<&[error]>이 구역에서는 표지판을 수정할 수 없습니다."
      - determine cancelled

bedrock_patch__command:
  type: command
  debug: false
  name: set_bedrock_teleport
  description: set bedrock teleport location
  usage: /set_bedrock_teleport
  permission: chadol.bedrock_patch.command
  script:
  - define teleport_location <player.location>
  - define protection_area <ellipsoid[<[teleport_location].x>,<[teleport_location].y>,<[teleport_location].z>,<[teleport_location].world.name>,50,50,50]>
  - note remove as:bedrock_patch_teleport_location
  - note remove as:bedrock_patch_teleport_protection
  - note <[teleport_location]> as:bedrock_patch_teleport_location
  - note <[protection_area]> as:bedrock_patch_teleport_protection
  - narrate "<&[emphasis]>베드락 텔레포트 위치를 설정했습니다: <[teleport_location].simple>"
  - narrate "<&[emphasis]>보호 구역(반경 50)을 갱신했습니다."
  - announce to_console "Bedrock teleport location set: <[teleport_location]>"
