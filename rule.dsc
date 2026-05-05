rule__show:
  type: task
  debug: false
  script:
  - define message "<&[emphasis]>맨 위를 보고 Shift(웅크리기)를 눌러 메뉴 열기"
  - define message "<[message]><n><&[warning]><bold>관리자 연락처: <reset>chadol_27(discord)"
  - narrate <[message]>
  - run util_sound_default
