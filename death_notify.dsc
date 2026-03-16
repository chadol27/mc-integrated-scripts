death_notify__event:
  type: world
  debug: false
  events:
    on player death:
    - narrate "죽은 위치: <&[emphasis]><proc[util_location_format].context[<player.location>]>"
    - wait 1t
    - announce "<&lt><player.name><&gt> 지금까지 <red><player.statistic[deaths]><reset>번 죽음"
    on player damaged by player:
    - if <context.damage> < 10:
      - stop
    - if <context.damager.item_in_hand> !matches *spear|mace:
      - stop
    - define item <context.damager.item_in_hand>
    - define rounded_damage <context.damage.mul[10].round.div[10]>
    - if <[item].display.exists>:
      - define itemname <&[emphasis]><[item].display><&[base]>(<[item].material.translated_name>/<[item].material.name>)
    - else:
      - define itemname <&[emphasis]><[item].material.translated_name><&[base]>(<[item].material.name>)
    - define itemname <&hover[<[item]>].type[SHOW_ITEM]><[itemname]><&end_hover>
    - announce "<white><&lt><context.damager.name><&gt><reset> <context.entity.name><white>에게 <reset><[itemname]><white>(을)를 사용해서 <reset><&[emphasis]><[rounded_damage]><white> 데미지를 주었습니다"
    on entity death:
    - if <context.entity> matches player:
      - stop
    - if <context.entity.type> != villager && !<context.entity.custom_name.exists>:
      - stop
    - define translated <&translate[key=entity.minecraft.<context.entity.type>]>
    - if <context.entity.custom_name.exists>:
      - define message "이름 있는 엔티티 <&[emphasis]><context.entity.custom_name><reset>(<[translated]>/<context.entity.type>) <&[warning]>사망:"
    - else:
      - define message "<&[emphasis]><[translated]><reset>(<context.entity.type>) <&[warning]>사망:"
    - define message <[message]><n><&[emphasis]><proc[util_location_format].context[<context.entity.location>]>
    - define message "<[message]> <&[warning]><context.cause>"
    - if <context.damager.exists>:
      - define message "<[message]> <reset>by <&[emphasis]><context.damager.name.if_null[context.damager]>"
    - announce <[message]>
