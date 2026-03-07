kill_glow__event:
  type: world
  debug: false
  events:
    on player death:
    - if !<context.damager.exists>:
      - stop
    - if <context.damager> !matches player:
      - stop
    - cast GLOWING duration:5m amplifier:0 <context.damager> no_ambient hide_particles no_icon no_clear
