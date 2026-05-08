# Denizen Script: \*.dsc

- 항상 아래의 두 사이트를 참고할 것
  - https://meta.denizenscript.com/
  - https://guide.denizenscript.com/
- 아래의 container를 만들 때는 항상 debug: false를 기본으로 추가할 것
  - world
  - task
  - command
  - procedure
- container 이름: <file_name>\_\_<container_name>
- 새로운 명령어를 생성할 때는 permission:을 넣을 지 물어볼 것
- 인게임 메시지에는 존댓말 사용
- <player>와 같이 메시지에 괄호를 포함시킬 때 <&lt>, <&gt>로 이스케이핑 할 것

## 프로젝트 개요

- 이 디렉터리는 Minecraft 서버의 Denizen 스크립트 모음이다.
- 파일은 기능별 `*.dsc`로 나뉘며, 대부분의 container는 `<file_name>__<container_name>` 형식을 따른다.
- 주 용도는 서버 편의 기능, 보호/자동화, GUI 메뉴, 커스텀 아이템, Discord 알림, 낚시 보상, 플레이어 표시 정보 관리다.
- 새 기능을 만들 때는 기존 파일에 작은 container를 추가하는 방식을 우선하고, 기능 경계가 분명하면 새 `*.dsc` 파일로 분리한다.

## 주요 파일 구조

- `util.dsc`: 공통 유틸리티 procedure/task. 위치/시간 포맷, 공통 사운드, 색상/표시 보조 로직이 다른 스크립트에서 재사용된다.
- `menu_gui.dsc`: 하늘을 보고 웅크릴 때 여는 서버 메뉴 GUI. 규칙 확인, 자살, 야간투시, 사이드바, 위치 공유, 아이템 이름 변경/자랑, 랭킹, 낚시 포션 교환 등 메뉴 진입점 역할을 한다.
- `rule.dsc`: 서버 규칙 표시 task.
- `sidebar.dsc`: 접속자 수, 좌표, 방향, 인게임 시간, 플레이 시간을 사이드바에 표시한다. `sidebar_off` 플레이어 flag로 비활성화한다.
- `join_message.dsc`, `death_notify.dsc`, `kill_glow.dsc`, `show_health.dsc`: 접속/사망/전투 관련 표시와 효과를 담당한다.
- `auto_save.dsc`: 주기적으로 서버 저장을 수행한다.
- `discord.dsc`: `discord_webhook_send` task와 서버 시작/종료 알림. Discord URL은 `<secret[discord_webhook]>`을 사용한다.
- `auto_shutdown.dsc`: 접속자가 없을 때 24시간 후 서버를 자동 종료하는 흐름. `auto_shutdown_token`, `auto_shutdown_warned` server flag로 취소/경고 상태를 관리한다.
- `anti_explode.dsc`: 폭발 방지 구역 관리와 `/anti_explode` 명령어. `anti_explode_cuboid`, `anti_explode_disabled` 상태를 사용한다.
- `bedrock_patch.dsc`: 베드락 관련 보정 기능과 `/set_bedrock_teleport` 명령어.
- `ender_chest_extended.dsc`: 플레이어별 54칸 확장 엔더 상자. `ender_chest_extended_contents` 플레이어 flag에 내용물을 저장한다.
- `special_items.dsc`: Mythic 장비, 특수 아이템, 관련 이벤트와 명령어를 정의한다.
- `fishing.dsc`: 낚시 보상 데이터, Rare/Legendary/Mythic 보상 판정, 확률 배수, 낚시 포션, 낚시 관련 명령어를 관리한다.
- `missile.dsc`: 유도 미사일 명령어와 틱 단위 이동/추적 로직.

## 공통 상태와 연동

- 장기 상태는 주로 `flag`를 사용한다. 플레이어별 설정은 player flag, 서버 전체 상태는 server flag로 둔다.
- 여러 이벤트나 명령에서 재사용되는 동작은 `task`로 분리한다.
- 값만 계산해 반환하는 로직은 `procedure`로 둔다.
- 외부 연동은 현재 Discord webhook이 중심이며, webhook URL은 파일에 직접 쓰지 않고 Denizen secret을 사용한다.
- GUI나 아이템 기반 기능은 `menu_gui.dsc`에서 진입하고, 실제 동작은 각 기능 파일의 task/command로 넘기는 구조가 많다.
