bedrock_patch__nether_ceiling:
  type: world
  debug: false
  events:
    after player teleported by portal to:world_nether:
      - if !<context.entity.name.starts_with[.]>:
        - stop
      - if <context.entity.location.y> >= 128:
        - teleport <context.entity> <location[0,0,0,world]>