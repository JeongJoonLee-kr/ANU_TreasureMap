# ANU Event Dialogue Drafts (Korean)

These drafts are structured for later conversion into `data/events.json`.
Each event follows a light side-quest shape: rumour, request, investigation,
choice, and positive resolution.

## Visual Asset Guidelines

- **Scene image format**: 16:9 event scene image, recommended 1920x1080 or 1600x900.
- **Scene image path pattern**: `/ANU_TreasureMap/Godot_Game/anu-treasure-map/resources/event/event_<id>_<stage>.png`.
- **Scene stages per event**: `intro`, `investigation`, `choice_a_success`, `choice_b_miss`, `choice_c_hint`.
- **Display timing**: show `intro` during rumour/request lines, switch to `investigation` during clue-gathering and choice display, then switch to the selected choice image for that outcome.
- **Scene style**: warm pixel-art campus illustration matching the main map page mood: soft green campus grounds, cream paths, muted blue shadows, clean silhouettes, friendly daylight, no UI overlay, no speech bubbles, no readable text unless the event depends on a tiny sign.
- **Treasure image format**: 1:1 collectible image, recommended 1024x1024, matching `treasure_yuki.png` and `treasure_kangaroo.png`.
- **Treasure image path pattern**: `/ANU_TreasureMap/Godot_Game/anu-treasure-map/resources/treasure/treasure_<id>.png`.
- **Treasure display timing**: show only after the success choice confirms treasure collection, usually after `choice_a_success`.
- **Treasure style**: square pixel-art vignette with one clear collectible focus in the center, gentle campus background, bright readable shape, no watermark, no photorealism.
- **Generation owner**: Dialogue drafts include prompts only; image generation is handled in a separate asset pass before playable integration.

## Student Accommodation -- Basketball Court

- **ID draft**: `student_accommodation_basketball_court`
- **Location ID**: `student_accommodation`
- **Treasure**: Basketball Court
- **Evidence note**: Yukeembruk lists outdoor exercise equipment including a half basketball court. This story treats it as part of the broader student accommodation area.

### Image Assets

- **Treasure image path**: `/ANU_TreasureMap/Godot_Game/anu-treasure-map/resources/treasure/treasure_basketball_court.png`
- **Treasure image prompt**: 1:1 pixel-art collectible image of a basketball resting on a painted half-court line beside a small water bottle and student orientation paper, soft ANU campus greenery behind it, bright friendly colors, centered object, matching the Yuki and kangaroo treasure image style.
- **Event image sequence**
  - `intro`: `/ANU_TreasureMap/Godot_Game/anu-treasure-map/resources/event/event_student_accommodation_basketball_court_intro.png`
    - **Show during**: Narrative 1-4.
    - **Prompt**: 16:9 warm pixel-art ANU student accommodation courtyard at golden hour, half basketball court visible, three students waiting beside the hoop with one student holding a ball, soft campus buildings and trees behind, cream walking paths, friendly first-week mood, no UI, no speech bubbles.
  - `investigation`: `/ANU_TreasureMap/Godot_Game/anu-treasure-map/resources/event/event_student_accommodation_basketball_court_investigation.png`
    - **Show during**: Narrative 5-12 and choice display.
    - **Prompt**: 16:9 pixel-art close view of the half basketball court, chalk team names on the ground, water bottles and orientation paper on a bench, the ball rolling toward the viewer, students waiting hopefully, warm green campus palette, no UI.
  - `choice_a_success`: `/ANU_TreasureMap/Godot_Game/anu-treasure-map/resources/event/event_student_accommodation_basketball_court_choice_a_success.png`
    - **Show during**: Choice A outcome before treasure image.
    - **Prompt**: 16:9 pixel-art casual 3-on-3 basketball moment, new students laughing and high-fiving after a shot, evening sunlight, half court and residence courtyard, welcoming teamwork feeling, no readable text.
  - `choice_b_miss`: `/ANU_TreasureMap/Godot_Game/anu-treasure-map/resources/event/event_student_accommodation_basketball_court_choice_b_miss.png`
    - **Show during**: Choice B outcome.
    - **Prompt**: 16:9 pixel-art view from the path as the player walks away from the half court, students still playing in the distance, warm but slightly wistful campus mood, no UI.
  - `choice_c_hint`: `/ANU_TreasureMap/Godot_Game/anu-treasure-map/resources/event/event_student_accommodation_basketball_court_choice_c_hint.png`
    - **Show during**: Choice C outcome.
    - **Prompt**: 16:9 pixel-art student sitting on the bench keeping score on a phone while others play, friendly invitation to join next time, half court, water bottles, soft campus greenery, no UI.

### Narrative

1. Student Accommodation 쪽 길을 지나가는데, 공이 림을 맞고 튀는 소리가 저녁 공기 사이로 또렷하게 들린다.
2. 코트 옆에는 처음 보는 학생 셋이 서 있다. 한 명은 공을 안고 있고, 다른 한 명은 휴대폰으로 시간을 확인한다.
3. "딱 한 명만 더 있으면 3대3이 되는데."
4. 공을 든 학생이 당신을 발견하고 손을 든다.
5. "혹시 잠깐만 뛰어줄 수 있어? 잘하지 않아도 돼. 우리도 사실 방금 만났어."
6. 코트 바닥에는 누군가 분필로 작은 팀 이름을 적어 두었다. 아직 어색한 글씨라서 더 신입생답다.
7. 옆 벤치에는 물병 네 개와 반쯤 열린 오리엔테이션 안내지가 놓여 있다.
8. 한 학생이 낮게 웃으며 말한다. "오늘 목표는 이기는 게 아니라, 서로 이름 외우기."
9. 바람이 지나가자 공이 당신 쪽으로 천천히 굴러온다.
10. 코트는 그냥 운동 시설처럼 보였는데, 지금은 누군가에게 말을 걸 수 있는 가장 쉬운 문처럼 보인다.
11. 당신은 공을 집어 든다.
12. 모두의 시선이 당신의 첫 패스를 기다린다.

### Choices

#### A. "좋아. 대신 내 이름부터 외워 줘."

- **Treasure found**: true
- **Outcome**
  1. 당신은 어설픈 첫 패스를 던지고, 모두가 동시에 웃음을 터뜨린다.
  2. 경기는 점수보다 이름으로 흘러간다. "민준, 오른쪽!" "레이첼, 슛!"
  3. 마지막 슛이 림을 통과하자, 처음 만난 네 사람이 자연스럽게 하이파이브를 나눈다.
  4. 당신은 Basketball Court를 발견했다. 이곳의 보물은 코트가 아니라, 어색함이 팀워크로 바뀌는 순간이다.

#### B. "미안, 오늘은 지나갈게."

- **Treasure found**: false
- **Re-trigger**: true
- **Outcome**
  1. 당신은 손을 흔들고 길을 계속 간다.
  2. 뒤에서 공 튀는 소리와 웃음소리가 조금씩 멀어진다.
  3. 나쁜 선택은 아니었다. 다만 오늘의 코트는 당신 없이도 작은 팀을 만들었을 뿐이다.

#### C. "나는 잘 못 뛰지만, 점수판은 봐줄 수 있어."

- **Treasure found**: false
- **Re-trigger**: true
- **Boost trigger chance**: true
- **Outcome**
  1. 당신은 벤치에 앉아 휴대폰 메모장으로 점수를 적는다.
  2. 학생들은 당신에게 다음 경기에는 꼭 뛰어 보라고 말한다.
  3. 당신은 이 코트에 다시 와도 어색하지 않을 이유를 얻었다.

## Chifley & Marie Reay -- Free Food

- **ID draft**: `wamburun_ursula_free_food`
- **Location ID**: `chifley_marie_reay`
- **Treasure**: Free Food
- **Evidence note**: ANU's free food guide describes ANUSA free breakfasts at the Brian Kenyon Student Space (BKSS), food vouchers, Student Bites with OzHarvest pickups on Friday afternoons at BKSS, residence food recovery to BKSS, Community Connect Food Relief, and the habit of planning ahead, bringing reusable containers, and staying connected with ANUSA updates. This event is located at Chifley & Marie Reay so the player can discover BKSS/ANUSA food support through a central campus student route.

### Image Assets

- **Treasure image path**: `/ANU_TreasureMap/Godot_Game/anu-treasure-map/resources/treasure/treasure_free_food.png`
- **Treasure image prompt**: 1:1 pixel-art collectible image of a reusable meal container with toast, fruit, a warm drink, and a small Student Bites-style pickup token on a campus bench, gentle green background, caring student support feeling, centered composition, bright but soft colors, no official logo.
- **Event image sequence**
  - `intro`: `/ANU_TreasureMap/Godot_Game/anu-treasure-map/resources/event/event_wamburun_ursula_free_food_intro.png`
    - **Show during**: Narrative 1-4.
    - **Prompt**: 16:9 warm pixel-art scene near Chifley Library and Marie Reay, ANUSA food support flyer on a noticeboard, two student volunteers with reusable containers and a campus map pointing toward BKSS, busy but caring central campus mood, no UI, no readable text.
  - `investigation`: `/ANU_TreasureMap/Godot_Game/anu-treasure-map/resources/event/event_wamburun_ursula_free_food_investigation.png`
    - **Show during**: Narrative 5-11 and choice display.
    - **Prompt**: 16:9 pixel-art close view of organized ANUSA food support materials near a campus noticeboard: reusable containers, fruit, toast, warm drink, simple icon-like notes for free breakfast, Student Bites, grocery vouchers, food recovery, and Community Connect support, Chifley and Marie Reay campus backdrop, no official logos, no UI.
  - `choice_a_success`: `/ANU_TreasureMap/Godot_Game/anu-treasure-map/resources/event/event_wamburun_ursula_free_food_choice_a_success.png`
    - **Show during**: Choice A outcome before treasure image.
    - **Prompt**: 16:9 pixel-art BKSS-style student space entrance atmosphere, students gently placing clear food support flyers, another student arriving with a reusable container, warm safe community support mood, no readable large text, no UI.
  - `choice_b_miss`: `/ANU_TreasureMap/Godot_Game/anu-treasure-map/resources/event/event_wamburun_ursula_free_food_choice_b_miss.png`
    - **Show during**: Choice B outcome.
    - **Prompt**: 16:9 pixel-art central campus path near Chifley and Marie Reay where the player has walked ahead and stopped, two ANUSA volunteers behind carefully checking food support flyers, BKSS direction, and program timing, gentle reminder mood, no UI.
  - `choice_c_hint`: `/ANU_TreasureMap/Godot_Game/anu-treasure-map/resources/event/event_wamburun_ursula_free_food_choice_c_hint.png`
    - **Show during**: Choice C outcome.
    - **Prompt**: 16:9 pixel-art student saving ANUSA food support reminders on a phone near Chifley and Marie Reay while two volunteers smile with reusable containers, hopeful next-time feeling, no UI, no readable text.

### Narrative

1. Chifley와 Marie Reay 근처를 지나는데, 한 학생이 ANUSA food support 안내지를 게시판에 붙이고 있다.
2. 맨 위에는 Brian Kenyon Student Space, 즉 BKSS에서 진행되는 free breakfast 시간이 적혀 있고, 아래에는 Student Bites와 food vouchers 안내가 이어진다.
3. 다른 학생은 재사용 용기를 든 채 휴대폰 캘린더를 확인한다.
4. "BKSS가 시작점이라는 걸 더 잘 보이게 만들고 싶어. 아침 식사, 금요일 오후 Student Bites, food recovery가 다 같은 방향으로 연결되거든."
5. 안내지에는 경제적 어려움을 겪는 학생이 학기마다 grocery voucher를 신청할 수 있다는 내용도 조심스럽게 적혀 있다.
6. 또 다른 줄은 food insecurity를 겪는 학생을 위한 Community Connect Food Relief와 캠퍼스 지원 서비스로 이어진다.
7. residence food recovery 설명에는 surplus catered food가 조심스럽게 portioning되어 BKSS를 통해 필요한 학생에게 다시 닿는다고 적혀 있다.
8. 재사용 용기를 든 학생은 말한다. "이건 그냥 공짜 음식을 찾는 이야기가 아니야. 한 끼를 건너뛰기 전에 도움을 발견하는 이야기야."
9. 안내지 아래에는 "계획하기, 용기 챙기기, ANUSA 업데이트 확인하기"라는 세 문장이 작게 정리되어 있다.
10. 도서관, Marie Reay, student space 사이로 사람들이 각자의 보이지 않는 시간표를 들고 지나간다.
11. 이 소문은 먹을 것을 찾는 이야기가 아니라, 캠퍼스가 돌봄의 방향표를 세우는 방법에 관한 이야기일지도 모른다.

### Choices

#### A. "ANUSA 안내가 더 잘 보이게 정리하고, BKSS 방향도 함께 확인하자."

- **Treasure found**: true
- **Outcome**
  1. 당신은 안내를 free breakfast, Student Bites, grocery vouchers, residence food recovery, Community Connect Food Relief로 나누어 정리한다.
  2. 학생들은 그 아래에 계획하기, 재사용 용기 챙기기, ANUSA 업데이트 확인하기를 덧붙인다.
  3. 지나가던 학생 하나가 안내지를 사진으로 찍으며 "식비 걱정하는 게 나뿐인 줄 알았어"라고 말한다.
  4. 당신은 Free Food를 발견했다. 오늘의 보물은 한 끼보다 더 오래 남는 안도감, 그리고 이미 준비된 도움을 이용해도 된다는 허락이다.

#### B. "공짜 음식이면 일단 BKSS로 빨리 가야지."

- **Treasure found**: false
- **Re-trigger**: true
- **Outcome**
  1. 당신은 서둘러 걸어가지만, free breakfast, Student Bites, voucher, food recovery, Community Connect의 차이가 머릿속에서 흐려진다.
  2. 뒤돌아보니 두 학생은 BKSS 위치와 각 프로그램의 시간, 신청 방법을 다시 확인하고 있다.
  3. 배고픔은 이해받을 수 있다. 하지만 이 보물은 빠른 발보다 정확한 안내를 기다린다.

#### C. "안내를 공유하고, food program 시간을 캘린더에 표시해 둘게."

- **Treasure found**: false
- **Re-trigger**: true
- **Boost trigger chance**: true
- **Outcome**
  1. 당신은 안내지를 사진으로 남기고, free breakfast 시간과 금요일 오후 Student Bites를 캘린더에 표시한다.
  2. ANUSA volunteer들은 staying connected가 이 지원을 놓치지 않는 방법이라고 말한다.
  3. 아직 보물을 발견한 것은 아니지만, BKSS와 food support로 향하는 첫 좌표를 손에 넣었다.

## Bruce Hall -- Lemon Tree

- **ID draft**: `bruce_hall_lemon_tree`
- **Location ID**: `bruce_hall`
- **Treasure**: Lemon Tree
- **Evidence note**: Bruce Hall officially lists a roof-top garden. The lemon tree is treated as a student rumour inside the story, not as an official campus claim.

### Image Assets

- **Treasure image path**: `/ANU_TreasureMap/Godot_Game/anu-treasure-map/resources/treasure/treasure_lemon_tree.png`
- **Treasure image prompt**: 1:1 pixel-art collectible image of a small potted lemon tree with a few bright yellow lemons and a tiny folded note tied to the branch, rooftop garden tiles and soft sky behind it, centered magical-but-real student rumour feeling.
- **Event image sequence**
  - `intro`: `/ANU_TreasureMap/Godot_Game/anu-treasure-map/resources/event/event_bruce_hall_lemon_tree_intro.png`
    - **Show during**: Narrative 1-4.
    - **Prompt**: 16:9 gentle pixel-art Bruce Hall entrance scene, a student holding a small yellow sticky note and looking uncertain, warm afternoon light, campus trees and modern residence facade, hopeful calm mood, no UI, no speech bubbles.
  - `investigation`: `/ANU_TreasureMap/Godot_Game/anu-treasure-map/resources/event/event_bruce_hall_lemon_tree_investigation.png`
    - **Show during**: Narrative 5-11 and choice display.
    - **Prompt**: 16:9 pixel-art rooftop garden at Bruce Hall, potted plants and herbs, a tiny yellow note near leafy plants, campus treetops and distant hills beyond the roof edge, quiet student-rumour mystery, no official signage, no UI.
  - `choice_a_success`: `/ANU_TreasureMap/Godot_Game/anu-treasure-map/resources/event/event_bruce_hall_lemon_tree_choice_a_success.png`
    - **Show during**: Choice A outcome before treasure image.
    - **Prompt**: 16:9 pixel-art two students in a rooftop garden discovering a small yellow marker among plants, soft sunlight, relieved smiles, theme of not being alone, gentle campus sky, no readable text, no UI.
  - `choice_b_miss`: `/ANU_TreasureMap/Godot_Game/anu-treasure-map/resources/event/event_bruce_hall_lemon_tree_choice_b_miss.png`
    - **Show during**: Choice B outcome.
    - **Prompt**: 16:9 pixel-art Bruce Hall path with the student folding a yellow note while the player walks away, quiet thoughtful mood, warm but slightly distant afternoon light, no UI.
  - `choice_c_hint`: `/ANU_TreasureMap/Godot_Game/anu-treasure-map/resources/event/event_bruce_hall_lemon_tree_choice_c_hint.png`
    - **Show during**: Choice C outcome.
    - **Prompt**: 16:9 pixel-art two students sitting on a bench near Bruce Hall, yellow note tucked into a laptop, calm supportive conversation, soft residence garden background, no UI.

### Narrative

1. Bruce Hall 앞을 지나는데, 누군가 노란색 포스트잇을 손에 쥔 채 건물 입구를 바라보고 있다.
2. 포스트잇에는 "레몬나무를 찾으면 오늘은 괜찮아진다"라고 적혀 있다.
3. 학생은 민망하게 웃는다. "선배가 남긴 말인데, 정확히 무슨 뜻인지 모르겠어."
4. 그는 Bruce Hall에 roof-top garden이 있다는 이야기를 들었다고 한다.
5. 하지만 레몬나무가 실제로 있는지, 아니면 그냥 학생들 사이의 작은 농담인지는 아무도 확실히 말하지 못했다.
6. 당신은 안내 표지, 엘리베이터 앞의 조용한 공지, 그리고 학생이 들고 있는 포스트잇을 차례로 본다.
7. 포스트잇 뒷면에는 아주 작은 글씨로 "혼자 찾지 말 것"이라고 적혀 있다.
8. 학생은 어깨를 으쓱한다. "아마 진짜 보물은 식물 이름이 아닐지도 몰라."
9. 위층으로 향하는 사람들의 발소리가 차분하게 울린다.
10. Bruce Hall은 오래된 전통과 새 건물이 함께 서 있는 곳처럼 느껴진다.
11. 당신은 이 소문을 그냥 웃어넘길 수도 있고, 누군가의 하루를 조금 가볍게 만들 수도 있다.

### Choices

#### A. "같이 올라가 보자. 진짜 나무보다 그 문장을 확인하고 싶어."

- **Treasure found**: true
- **Outcome**
  1. roof-top garden의 식물들 사이에서 당신은 작은 노란 표식을 발견한다.
  2. 표식에는 "힘든 날엔 햇빛이 드는 곳까지 같이 올라오기"라고 적혀 있다.
  3. 레몬나무가 공식 표지판처럼 서 있지는 않았지만, 소문의 뜻은 선명해진다.
  4. 당신은 Lemon Tree를 발견했다. 오늘의 보물은 누군가를 혼자 두지 않는 약속이다.

#### B. "그냥 장난 같은데? 다른 사람에게 물어봐."

- **Treasure found**: false
- **Re-trigger**: true
- **Outcome**
  1. 학생은 고개를 끄덕이며 포스트잇을 접는다.
  2. 당신은 길을 계속 가지만, 노란 종이의 문장이 자꾸 떠오른다.
  3. 장난일 수도 있다. 하지만 어떤 장난은 누군가에게 필요한 신호일 수도 있다.

#### C. "나무는 모르겠지만, 오늘 괜찮아질 방법은 같이 찾아보자."

- **Treasure found**: false
- **Re-trigger**: true
- **Boost trigger chance**: true
- **Outcome**
  1. 두 사람은 입구 근처 벤치에 앉아 잠시 쉬어 간다.
  2. 학생은 포스트잇을 버리지 않고 노트북 안쪽에 붙인다.
  3. 아직 소문의 장소는 찾지 못했지만, 다음에 다시 찾아볼 이유는 충분해졌다.

## Central Studying Area -- Board Games Society

- **ID draft**: `central_studying_area_board_games_society`
- **Location ID**: `central_studying_area`
- **Treasure**: Board Games Society
- **Evidence note**: ANU and the society describe regular Friday game nights and board game activity on campus.

### Image Assets

- **Treasure image path**: `/ANU_TreasureMap/Godot_Game/anu-treasure-map/resources/treasure/treasure_board_games_society.png`
- **Treasure image prompt**: 1:1 pixel-art collectible image of colorful dice, meeples, cards, and a folded game board on a wooden table, tiny pizza slice and pencil nearby, warm friendly lighting, centered object cluster, matching square treasure art style.
- **Event image sequence**
  - `intro`: `/ANU_TreasureMap/Godot_Game/anu-treasure-map/resources/event/event_central_studying_area_board_games_society_intro.png`
    - **Show during**: Narrative 1-4.
    - **Prompt**: 16:9 pixel-art central study area with notebooks, laptop, coffee cup, and a small game night invitation on a desk, tired student looking up, soft green campus visible through windows, quiet study pressure, no UI, no readable text.
  - `investigation`: `/ANU_TreasureMap/Godot_Game/anu-treasure-map/resources/event/event_central_studying_area_board_games_society_investigation.png`
    - **Show during**: Narrative 5-11 and choice display.
    - **Prompt**: 16:9 pixel-art transition from study tables to a warm board game table, colorful dice, cards, and board pieces visible, students gathering kindly, inviting social atmosphere, no game branding, no UI.
  - `choice_a_success`: `/ANU_TreasureMap/Godot_Game/anu-treasure-map/resources/event/event_central_studying_area_board_games_society_choice_a_success.png`
    - **Show during**: Choice A outcome before treasure image.
    - **Prompt**: 16:9 pixel-art friendly board game night, a newcomer learning rules at the edge of the table, students smiling and explaining, warm indoor light, pizza slice on table, no readable text, no UI.
  - `choice_b_miss`: `/ANU_TreasureMap/Godot_Game/anu-treasure-map/resources/event/event_central_studying_area_board_games_society_choice_b_miss.png`
    - **Show during**: Choice B outcome.
    - **Prompt**: 16:9 pixel-art student returning to laptop with a game night invitation tucked in a notebook, study area still calm but heavy, distant warm game table glow in background, no UI.
  - `choice_c_hint`: `/ANU_TreasureMap/Godot_Game/anu-treasure-map/resources/event/event_central_studying_area_board_games_society_choice_c_hint.png`
    - **Show during**: Choice C outcome.
    - **Prompt**: 16:9 pixel-art student adding next Friday game night to a calendar on a phone, invitation card and dice on desk, hopeful next-time feeling, study area with soft campus window light, no UI.

### Narrative

1. Central Studying Area의 책상 위에 버려진 초대장 한 장이 보인다.
2. 초대장에는 "Friday game night"라는 문구와 함께 주사위 그림이 그려져 있다.
3. 옆자리 학생이 머리를 감싸 쥐고 있다가 당신을 본다.
4. "혹시 이거 어디서 하는지 알아? 과제 때문에 사람 만나는 법을 잊어버린 것 같아."
5. 초대장 아래에는 작은 글씨로 "처음 와도 괜찮음. 룰 설명 가능."이라고 적혀 있다.
6. 책상 위 노트에는 미완성 에세이, 커피 얼룩, 그리고 할 일 목록이 뒤섞여 있다.
7. 학생은 초대장을 들었다가 내려놓는다. "게임은 좋아하는데, 이미 친한 사람들끼리만 있으면 어쩌지?"
8. 멀리서 누군가 웃으며 카드 셔플하는 소리가 들리는 것 같다.
9. 공부 공간의 조용한 압박 속에서, 이 작은 종이는 바깥으로 난 비밀 통로처럼 보인다.
10. 당신은 초대장의 위치, 시간, 그리고 학생의 망설임을 함께 읽는다.
11. 게임의 첫 규칙은 어쩌면 보드판 위가 아니라 문 앞에서 시작된다.

### Choices

#### A. "같이 가자. 모르면 배우면 되고, 지면 웃으면 되지."

- **Treasure found**: true
- **Outcome**
  1. 당신과 학생은 게임 테이블 끝에 조심스럽게 앉는다.
  2. 동아리원이 박스를 열며 말한다. "처음이면 이 게임부터 해요. 같이 설명해 드릴게요."
  3. 몇 턴 뒤, 학생은 자기 차례를 기다리며 더 이상 초대장을 구기지 않는다.
  4. 당신은 Board Games Society를 발견했다. 보물은 규칙서가 아니라, 낯선 사람도 한 턴 안에 동료가 되는 환대다.

#### B. "과제 먼저 끝내는 게 낫지 않을까?"

- **Treasure found**: false
- **Re-trigger**: true
- **Outcome**
  1. 학생은 초대장을 노트 사이에 끼우고 다시 화면을 바라본다.
  2. 과제는 조금 더 진행되지만, 책상 주변의 공기는 여전히 무겁다.
  3. 틀린 선택은 아니다. 다만 오늘 밤의 주사위는 다른 사람의 손에서 굴러갔다.

#### C. "오늘은 못 가도, 다음 Friday game night 위치를 같이 확인하자."

- **Treasure found**: false
- **Re-trigger**: true
- **Boost trigger chance**: true
- **Outcome**
  1. 당신은 초대장 정보를 정리해 학생의 캘린더에 적어 준다.
  2. 학생은 안심한 듯 말한다. "다음 주에는 진짜 가 볼게."
  3. 아직 테이블에 앉지는 못했지만, 첫 주사위는 마음속에서 이미 굴러갔다.

## CSIT&ENGN Area -- Escape Room

- **ID draft**: `csit_engn_escape_room`
- **Location ID**: `csit_engn_area`
- **Treasure**: Escape Room
- **Evidence note**: ANU School of Computing describes an educational escape room housed in the Computer Science & Information Technology building, with 60 minutes and five computing puzzles.

### Image Assets

- **Treasure image path**: `/ANU_TreasureMap/Godot_Game/anu-treasure-map/resources/treasure/treasure_escape_room.png`
- **Treasure image prompt**: 1:1 pixel-art collectible image of an open puzzle lock beside a keyboard key, circuit board, UV flashlight, and small clue card, neon teal and warm yellow highlights, centered on a desk, friendly computing escape-room mood.
- **Event image sequence**
  - `intro`: `/ANU_TreasureMap/Godot_Game/anu-treasure-map/resources/event/event_csit_engn_escape_room_intro.png`
    - **Show during**: Narrative 1-4.
    - **Prompt**: 16:9 pixel-art educational escape room entrance inside an ANU computing building, glowing timer shape, tutor explaining rules to students, old keyboards and circuit boards visible, bright mystery mood, not scary, no readable numbers, no UI.
  - `investigation`: `/ANU_TreasureMap/Godot_Game/anu-treasure-map/resources/event/event_csit_engn_escape_room_investigation.png`
    - **Show during**: Narrative 5-11 and choice display.
    - **Prompt**: 16:9 pixel-art team stuck around puzzle stations with encoded notes, UML-like diagram pieces, test case cards, UV clue light, whiteboard, students looking at different clues, collaborative tension, no UI.
  - `choice_a_success`: `/ANU_TreasureMap/Godot_Game/anu-treasure-map/resources/event/event_csit_engn_escape_room_choice_a_success.png`
    - **Show during**: Choice A outcome before treasure image.
    - **Prompt**: 16:9 pixel-art escape room team dividing roles and solving connected computing puzzles, door opening with warm light, tutor applauding, students excited, bright educational teamwork mood, no UI.
  - `choice_b_miss`: `/ANU_TreasureMap/Godot_Game/anu-treasure-map/resources/event/event_csit_engn_escape_room_choice_b_miss.png`
    - **Show during**: Choice B outcome.
    - **Prompt**: 16:9 pixel-art one student focused alone on a difficult puzzle while teammates wait nearby, timer glow fading, good experiment but missed connection mood, not negative or scary, no UI.
  - `choice_c_hint`: `/ANU_TreasureMap/Godot_Game/anu-treasure-map/resources/event/event_csit_engn_escape_room_choice_c_hint.png`
    - **Show during**: Choice C outcome.
    - **Prompt**: 16:9 pixel-art students gathered around a whiteboard sharing where they got stuck, puzzle cards arranged into groups, door still closed but conversation open, constructive next-try mood, no UI.

### Narrative

1. CSIT&ENGN Area에 들어서자, 문 옆 모니터에 "60:00"이라는 숫자가 깜빡인다.
2. 한 튜터가 학생 네 명에게 규칙을 설명하고 있다.
3. "다섯 개의 퍼즐을 풀어야 합니다. 중요한 건 정답보다 과정이에요."
4. 방 안에는 오래된 키보드, 회로판, 자외선 표시, 그리고 이상하게 깔끔한 단서 카드들이 놓여 있다.
5. 팀원 한 명이 당신을 보며 속삭인다. "우리 한 명이 못 와서 역할이 비었어. 도와줄래?"
6. 첫 번째 퍼즐은 암호문, 두 번째는 테스트 케이스, 세 번째는 UML 조각처럼 보인다.
7. 제한 시간은 줄어들고 있지만, 모두가 같은 단서만 바라보고 있어 진도가 막혀 있다.
8. 튜터는 아무 말 없이 화이트보드 옆 모래시계를 뒤집는다.
9. 이 방은 도망치는 곳이 아니라, 혼자 풀던 머리를 팀으로 바꾸는 실험실이다.
10. 당신의 선택에 따라 팀은 한 덩어리로 굳을 수도, 작은 역할들로 살아날 수도 있다.
11. 모니터의 숫자가 59:12로 떨어진다.

### Choices

#### A. "역할을 나누자. 나는 테스트 케이스를 볼게, 너희는 암호와 UML을 맡아."

- **Treasure found**: true
- **Outcome**
  1. 팀은 처음으로 서로 다른 단서를 동시에 보기 시작한다.
  2. 암호문은 테스트 결과와 연결되고, UML 조각은 마지막 잠금장치의 순서가 된다.
  3. 시간이 02:18 남았을 때 문이 열리고, 튜터가 박수를 친다.
  4. 당신은 Escape Room을 발견했다. 보물은 탈출이 아니라, 각자의 생각이 하나의 해답으로 맞물리는 순간이다.

#### B. "내가 빨리 풀어 볼게. 다들 잠깐만 기다려."

- **Treasure found**: false
- **Re-trigger**: true
- **Outcome**
  1. 당신은 가장 어려워 보이는 퍼즐에 집중하지만, 다른 단서와 연결되지 않아 막힌다.
  2. 남은 시간 동안 팀원들은 기다리다 다시 흩어진다.
  3. 실패라기보다 좋은 실험이었다. 이 방은 가장 빠른 한 명보다 함께 움직이는 팀을 좋아한다.

#### C. "지금 막힌 이유부터 말해 보자. 어디서 멈췄는지 공유하자."

- **Treasure found**: false
- **Re-trigger**: true
- **Boost trigger chance**: true
- **Outcome**
  1. 팀원들은 각자 붙잡고 있던 단서를 설명한다.
  2. 이번에는 시간이 부족했지만, 다음 시도에서는 무엇을 먼저 나눠야 하는지 알게 됐다.
  3. 문은 열리지 않았지만, 팀의 대화는 열렸다.

## ANU Sport & North Oval -- ANU Sport

- **ID draft**: `anu_sport_north_oval_anu_sport`
- **Location ID**: `anu_sports_north_oval`
- **Treasure**: ANU Sport
- **Evidence note**: ANU Sport's Sport page frames sport as open to high-level athletes, casual players, ANU students, and the general public, with year-round opportunities including UniSport Nationals, Social Sport, and Interhall Sport.

### Image Assets

- **Treasure image path**: `/ANU_TreasureMap/Godot_Game/anu-treasure-map/resources/treasure/treasure_anu_sport.png`
- **Treasure image prompt**: 1:1 pixel-art collectible image of an ANU Sport starter kit: soccer ball, volleyball, training cone, team wristband, online sign-up card without readable text, and student water bottle on green grass, soft campus trees behind, centered bright readable shapes.
- **Event image sequence**
  - `intro`: `/ANU_TreasureMap/Godot_Game/anu-treasure-map/resources/event/event_anu_sport_north_oval_anu_sport_intro.png`
    - **Show during**: Narrative 1-4.
    - **Prompt**: 16:9 bright pixel-art ANU Sport scene near North Oval, friendly sign-up table with three pathway cards suggested by icons, grass field, ANU Sport building in distance, students unsure where to stand, inclusive year-round sport mood, no readable text, no UI.
  - `investigation`: `/ANU_TreasureMap/Godot_Game/anu-treasure-map/resources/event/event_anu_sport_north_oval_anu_sport_investigation.png`
    - **Show during**: Narrative 5-11 and choice display.
    - **Prompt**: 16:9 pixel-art view of three sport pathways at ANU: casual students kicking a ball, interhall-style group warming up, serious athletes stretching for competition, ANU Sport sign-up table in foreground, bright energetic campus mood, no UI.
  - `choice_a_success`: `/ANU_TreasureMap/Godot_Game/anu-treasure-map/resources/event/event_anu_sport_north_oval_anu_sport_choice_a_success.png`
    - **Show during**: Choice A outcome before treasure image.
    - **Prompt**: 16:9 pixel-art Social Sport first session, newcomers joining a casual kick on North Oval, staff helping with an online sign-up card, students laughing after a missed kick, welcoming motion, no UI.
  - `choice_b_miss`: `/ANU_TreasureMap/Godot_Game/anu-treasure-map/resources/event/event_anu_sport_north_oval_anu_sport_choice_b_miss.png`
    - **Show during**: Choice B outcome.
    - **Prompt**: 16:9 pixel-art player watching from the edge of North Oval, social sport and serious training happening in the distance, thoughtful but positive mood, three pathway cards still visible on a table, no UI.
  - `choice_c_hint`: `/ANU_TreasureMap/Godot_Game/anu-treasure-map/resources/event/event_anu_sport_north_oval_anu_sport_choice_c_hint.png`
    - **Show during**: Choice C outcome.
    - **Prompt**: 16:9 pixel-art ANU Sport staff explaining three pathway cards to a student: university competition, social sport, interhall sport represented by simple icons, green field and campus trees behind, clear next-step mood, no readable text, no UI.

### Narrative

1. North Oval 가장자리에 서자, ANU Sport 안내 테이블 위에서 세 장의 작은 카드가 바람에 흔들린다.
2. 한 장에는 UniSport Nationals, 다른 한 장에는 Social Sport, 마지막 한 장에는 Interhall Sport라고 적혀 있다.
3. ANU Sport 스태프가 카드들을 붙잡다가 당신을 보고 웃는다.
4. "도와줄래요? 처음 온 학생들이 자꾸 어디에 서야 할지 몰라서 그냥 돌아가요."
5. 클립보드에는 이름 대신 "high-level athlete", "casual kick", "just want to have fun" 같은 메모가 적혀 있다.
6. 멀리서는 누군가 공을 너무 세게 차고, 다른 쪽에서는 진지하게 스트레칭하는 팀이 호흡을 맞춘다.
7. 스태프는 말한다. "ANU Sport는 한 종류의 사람만을 위한 곳이 아니에요. 경쟁하고 싶은 사람도, 그냥 학생들과 뛰어 보고 싶은 사람도 길이 있어요."
8. 그는 온라인 sign-up 화면을 보여 주며 덧붙인다. "중요한 건 지금 실력이 아니라, 어떤 방식으로 참여하고 싶은지예요."
9. North Oval의 잔디, ANU Sport 건물, 그리고 안내 카드 세 장이 하나의 작은 갈림길처럼 보인다.
10. 오늘의 문제는 승패가 아니다.
11. 문제는 자기에게 맞는 스포츠의 문을 고르는 것이다.

### Choices

#### A. "Social Sport부터 안내하자. 나도 casual kick으로 시작할게."

- **Treasure found**: true
- **Outcome**
  1. 당신이 Social Sport 카드 옆에 서자, 가장자리의 학생 둘이 조용히 따라온다.
  2. 스태프는 온라인 sign-up 방법을 보여 주고, 모두가 부담 없는 첫 세션을 고른다.
  3. 경기는 서툴지만 활기차다. 공은 자주 빗나가고, 웃음은 더 자주 맞아 들어간다.
  4. 당신은 ANU Sport를 발견했다. 보물은 잘하는 몸이 아니라, 자기 속도에 맞는 참여의 문을 찾는 일이다.

#### B. "나는 아직 고를 자신이 없어서 구경만 할게."

- **Treasure found**: false
- **Re-trigger**: true
- **Outcome**
  1. 당신은 잔디 옆에서 Social Sport 팀과 더 진지한 훈련 팀을 번갈아 본다.
  2. 누군가는 경쟁을 준비하고, 누군가는 친구들과 웃으며 뛰고 있다.
  3. 보는 것만으로도 선택지가 있다는 건 알 수 있었다. 다음에는 어느 카드 앞에 설지 정할 수 있을 것 같다.

#### C. "UniSport, Social Sport, Interhall Sport 차이를 먼저 알려 줄 수 있어?"

- **Treasure found**: false
- **Re-trigger**: true
- **Boost trigger chance**: true
- **Outcome**
  1. 스태프는 UniSport Nationals는 더 큰 대회로 이어지는 길, Social Sport는 부담 없이 즐기는 길, Interhall Sport는 거주 커뮤니티와 함께 뛰는 길이라고 설명한다.
  2. 당신은 오늘 뛰지는 않았지만, 온라인으로 어디서 시작해야 할지 알게 된다.
  3. 보물은 아직 잔디 위에 있지만, ANU Sport로 들어가는 세 개의 문은 손에 들어왔다.

## Chifley & Marie Reay -- Chifley Library

- **ID draft**: `chifley_marie_reay_chifley_library`
- **Location ID**: `chifley_marie_reay`
- **Treasure**: Chifley Library
- **Evidence note**: Chifley Library supports social sciences, humanities, business, and economics, with study spaces, group study rooms, lockers, computers, and learning facilities.

### Image Assets

- **Treasure image path**: `/ANU_TreasureMap/Godot_Game/anu-treasure-map/resources/treasure/treasure_chifley_library.png`
- **Treasure image prompt**: 1:1 pixel-art collectible image of a research notebook, library card, pencil, and small stack of books with subtle humanities and economics color tabs, warm reading light, centered on a study desk, soft library background.
- **Event image sequence**
  - `intro`: `/ANU_TreasureMap/Godot_Game/anu-treasure-map/resources/event/event_chifley_marie_reay_chifley_library_intro.png`
    - **Show during**: Narrative 1-4.
    - **Prompt**: 16:9 calm pixel-art Chifley Library steps near Chifley and Marie Reay, a research notebook lying on the path, a worried student approaching, warm study windows, soft trees and campus path, quiet academic mood, no UI.
  - `investigation`: `/ANU_TreasureMap/Godot_Game/anu-treasure-map/resources/event/event_chifley_marie_reay_chifley_library_investigation.png`
    - **Show during**: Narrative 5-10 and choice display.
    - **Prompt**: 16:9 pixel-art library interior clue scene, open research notebook with call number-like marks, group study room card, small digital hub symbol, bookshelves, computers, soft reading lights, calm knowledge-map feeling, no readable text, no UI.
  - `choice_a_success`: `/ANU_TreasureMap/Godot_Game/anu-treasure-map/resources/event/event_chifley_marie_reay_chifley_library_choice_a_success.png`
    - **Show during**: Choice A outcome before treasure image.
    - **Prompt**: 16:9 pixel-art student and player successfully connecting library clues: books found, group study room open, presentation screen glowing softly, Chifley Library warm study atmosphere, satisfying research discovery, no UI.
  - `choice_b_miss`: `/ANU_TreasureMap/Godot_Game/anu-treasure-map/resources/event/event_chifley_marie_reay_chifley_library_choice_b_miss.png`
    - **Show during**: Choice B outcome.
    - **Prompt**: 16:9 pixel-art student standing near an information desk with the notebook, player leaving toward library exit, library still calm and open, opportunity not fully explored, gentle mood, no UI.
  - `choice_c_hint`: `/ANU_TreasureMap/Godot_Game/anu-treasure-map/resources/event/event_chifley_marie_reay_chifley_library_choice_c_hint.png`
    - **Show during**: Choice C outcome.
    - **Prompt**: 16:9 pixel-art group study room doorway at Chifley Library, student relieved to arrive on time while notebook clues remain visible, warm room light, bookshelves and quiet corridor, next-step hint mood, no UI.

### Narrative

1. Chifley & Marie Reay 근처를 지나는데, 도서관 계단 옆에 얇은 연구 노트가 떨어져 있다.
2. 표지에는 "SS&H sources -- do not lose"라고 적혀 있다.
3. 노트를 주워 들자, 한 학생이 급하게 주변을 살피며 다가온다.
4. "그거 혹시 제 노트인가요? 발표 자료 찾다가 길을 완전히 잃었어요."
5. 노트 안에는 call number처럼 보이는 숫자, group study room 예약 시간, 그리고 "The Deck?"이라는 물음표가 적혀 있다.
6. 학생은 Chifley Library가 익숙하지 않다고 한다. 자료도 많고 층도 많아, 어디서 시작해야 할지 모르겠다는 표정이다.
7. 도서관 안에서는 페이지 넘기는 소리, 키보드 소리, 낮은 속삭임이 층층이 쌓여 있다.
8. 이곳은 조용하지만 멈춰 있는 곳은 아니다.
9. 누군가는 책을 찾고, 누군가는 화면을 연결하고, 누군가는 흩어진 생각을 방 하나에 모은다.
10. 당신은 노트의 세 단서를 따라가면, 학생의 발표뿐 아니라 도서관의 숨은 지도를 찾을 수 있을 것 같다.

### Choices

#### A. "노트의 단서를 순서대로 따라가 보자. 자료, 방, 디지털 허브까지."

- **Treasure found**: true
- **Outcome**
  1. 당신은 먼저 자료 위치를 확인하고, 학생과 함께 필요한 책을 찾는다.
  2. 다음으로 group study room 예약을 확인해 발표 팀이 모일 자리를 찾아 준다.
  3. 마지막 물음표는 The Deck으로 이어지고, 학생의 발표 자료는 훨씬 선명해진다.
  4. 당신은 Chifley Library를 발견했다. 보물은 책장이 아니라, 질문이 길을 찾는 방식이다.

#### B. "정보 데스크에 물어보면 되지 않을까? 나는 갈게."

- **Treasure found**: false
- **Re-trigger**: true
- **Outcome**
  1. 학생은 고맙다고 말하고 노트를 받아 든다.
  2. 당신의 조언은 틀리지 않았지만, 노트 속 단서들이 어떻게 이어지는지는 보지 못했다.
  3. 도서관은 여전히 조용히 열려 있다. 다음 질문을 가진 사람을 기다리며.

#### C. "일단 group study room 시간부터 놓치지 말자."

- **Treasure found**: false
- **Re-trigger**: true
- **Boost trigger chance**: true
- **Outcome**
  1. 당신은 학생을 예약된 방 앞까지 데려다준다.
  2. 발표 팀은 안도하지만, 노트의 다른 단서는 아직 남아 있다.
  3. 오늘은 방을 찾았다. 다음에는 도서관 전체가 보일지도 모른다.

## Copland -- Subway

- **ID draft**: `copland_subway`
- **Location ID**: `copland`
- **Treasure**: Subway
- **Evidence note**: ANU maps list Subway at 20 Union Court. This event starts at Copland and sends the player through a campus lunch route rather than placing Subway inside Copland.

### Image Assets

- **Treasure image path**: `/ANU_TreasureMap/Godot_Game/anu-treasure-map/resources/treasure/treasure_subway.png`
- **Treasure image prompt**: 1:1 pixel-art collectible image of a wrapped sandwich lunch with a drink and campus map corner on a bench, green and yellow fresh-food palette, friendly shared-lunch mood, no official logo or brand text, centered composition.
- **Event image sequence**
  - `intro`: `/ANU_TreasureMap/Godot_Game/anu-treasure-map/resources/event/event_copland_subway_intro.png`
    - **Show during**: Narrative 1-4.
    - **Prompt**: 16:9 cheerful pixel-art Copland area at lunchtime, three students pointing in different directions, one checking a phone map, campus buildings, cream paths, trees, soft crowd flow, warm midday light, no readable brand signage, no UI.
  - `investigation`: `/ANU_TreasureMap/Godot_Game/anu-treasure-map/resources/event/event_copland_subway_investigation.png`
    - **Show during**: Narrative 5-10 and choice display.
    - **Prompt**: 16:9 pixel-art ANU campus lunch route from Copland toward Union Court, students studying a map together, paths and buildings forming a friendly mini quest route, warm busy campus atmosphere, no official logos, no UI.
  - `choice_a_success`: `/ANU_TreasureMap/Godot_Game/anu-treasure-map/resources/event/event_copland_subway_choice_a_success.png`
    - **Show during**: Choice A outcome before treasure image.
    - **Prompt**: 16:9 pixel-art three students walking together toward a sandwich lunch spot near Union Court, relaxed smiles, one holding a phone with route, campus lunch crowd, shared meal mood, no readable brand text, no UI.
  - `choice_b_miss`: `/ANU_TreasureMap/Godot_Game/anu-treasure-map/resources/event/event_copland_subway_choice_b_miss.png`
    - **Show during**: Choice B outcome.
    - **Prompt**: 16:9 pixel-art Copland path where students split in different directions for lunch, friendly but missed-togetherness mood, campus buildings and trees, warm midday light, no UI.
  - `choice_c_hint`: `/ANU_TreasureMap/Godot_Game/anu-treasure-map/resources/event/event_copland_subway_choice_c_hint.png`
    - **Show during**: Choice C outcome.
    - **Prompt**: 16:9 pixel-art students marking a lunch location on a phone map near Copland, deciding next time's meeting point, campus bench and paths, hopeful shared-lunch planning mood, no readable brand text, no UI.

### Narrative

1. Copland 근처에서 점심시간의 기운이 갑자기 짙어진다.
2. 세 학생이 건물 앞에서 서로 다른 방향을 가리키고 있다.
3. 한 학생은 말한다. "수업까지 25분 남았어. 빨리 먹고 돌아와야 해."
4. 다른 학생은 휴대폰 지도를 보며 말한다. "Subway가 Union Court 쪽이라는데, 여기서 어느 길이 제일 낫지?"
5. 세 번째 학생은 웃으며 배를 문지른다. "중요한 건 길보다 같이 먹을 사람을 잃지 않는 거야."
6. 당신에게도 익숙한 캠퍼스의 점심 문제다.
7. 모두 바쁘고, 모두 배고프고, 아무도 먼저 "같이 가자"고 말하지 못한다.
8. Copland의 계단, 이어지는 보행로, Union Court 방향의 사람 흐름이 하나의 짧은 퀘스트처럼 펼쳐진다.
9. 이 보물은 특정 메뉴가 아니라, 바쁜 날에도 누군가와 한 끼를 맞추는 기술일지 모른다.
10. 학생들은 당신의 판단을 기다린다.

### Choices

#### A. "다 같이 가자. 빠른 길로 가되, 주문은 미리 정하면서 움직이자."

- **Treasure found**: true
- **Outcome**
  1. 당신은 학생들과 함께 Union Court 쪽으로 걷기 시작한다.
  2. 걸어가는 동안 각자 주문을 정하고, 마지막 신호등 앞에서는 자연스럽게 웃음이 난다.
  3. Subway 앞에 도착했을 때, 세 사람은 더 이상 흩어진 점들이 아니라 한 줄의 파티가 되어 있다.
  4. 당신은 Subway를 발견했다. 보물은 샌드위치보다, 바쁜 캠퍼스에서 같이 먹자고 말하는 용기다.

#### B. "나는 모르겠어. 각자 가고 싶은 데로 가면 되지 않을까?"

- **Treasure found**: false
- **Re-trigger**: true
- **Outcome**
  1. 학생들은 잠시 서로를 보다가 각자 다른 방향으로 흩어진다.
  2. 모두 점심은 먹었겠지만, 함께 먹을 기회는 사라졌다.
  3. 캠퍼스는 넓고 선택지는 많다. 그래서 때로는 한 방향을 같이 고르는 일이 필요하다.

#### C. "Subway 위치부터 정확히 확인하자. 오늘 못 가도 다음엔 헤매지 않게."

- **Treasure found**: false
- **Re-trigger**: true
- **Boost trigger chance**: true
- **Outcome**
  1. 당신은 지도로 20 Union Court 위치를 확인해 준다.
  2. 학생들은 오늘은 가까운 곳에서 먹기로 하지만, 다음 점심 약속 장소를 정한다.
  3. 아직 보물을 발견한 것은 아니지만, 다음 한 끼의 좌표는 분명해졌다.

## Medical & Physics School -- Anatomical Model

- **ID draft**: `medical_physics_school_anatomical_model`
- **Location ID**: `medical_physics_school`
- **Treasure**: Anatomical Model
- **Evidence note**: ANU's School of Medicine and Psychology explains that anatomy teaching and research access is regulated, that human remains must be treated with dignity and respect, and that access to the Medical Science & Anatomy Facility is limited to authorised people. ANU's Anatomy and Physiology 1 course also describes practical sessions where students examine histology, prosected human cadaveric specimens, and models of the human body. The player-provided photo shows an anatomical torso/skull teaching display in an ANU medical-school context; this event treats the visible anatomical model as a respectful public-facing learning clue, not as access to restricted specimens or facilities.

### Image Generation Manifest

- **Batch group**: `medical_physics_school_anatomical_model`
- **Reference image**: user-provided anatomical model photo; use only as visual inspiration for the torso model, skull poster, medical noticeboard, trophy/display-shelf atmosphere, and respectful teaching tone.
- **Generation order**: generate all prompts in this event group independently; save final outputs to the listed paths before JSON integration.
- **Shared negative prompt**: no gore, no blood, no horror mood, no cadaver depiction, no readable text, no real student faces, no official logos, no watermark, no UI overlay, no speech bubbles.

### Image Assets

- **Treasure image path**: `/ANU_TreasureMap/Godot_Game/anu-treasure-map/resources/treasure/treasure_anatomical_model.png`
- **Treasure image prompt**: 1:1 pixel-art collectible image of a respectful anatomical teaching torso model on a small white base, with simplified visible organs and a small skull-study card beside it, warm medical-school display shelf background, gentle educational mood, centered object, bright readable shape, no gore, no blood, no readable text, no official logo.
- **Event image sequence**
  - `intro`: `/ANU_TreasureMap/Godot_Game/anu-treasure-map/resources/event/event_medical_physics_school_anatomical_model_intro.png`
    - **Show during**: Narrative 1-4.
    - **Prompt**: 16:9 warm pixel-art ANU Medical & Physics School corridor display inspired by the provided photo, anatomical torso model on a shelf, skull anatomy poster shapes, trophy silhouettes, dark noticeboard and timber wall tones, a student guide holding a clipboard, respectful curious mood, no readable text, no UI.
  - `investigation`: `/ANU_TreasureMap/Godot_Game/anu-treasure-map/resources/event/event_medical_physics_school_anatomical_model_investigation.png`
    - **Show during**: Narrative 5-11 and choice display.
    - **Prompt**: 16:9 pixel-art close view of a medical teaching display: anatomical torso model, simplified skull diagram poster, small ethics/access reminder card, student notebook with three icon-like clues for model, terminology, and respect, clean educational atmosphere, no gore, no readable text, no UI.
  - `choice_a_success`: `/ANU_TreasureMap/Godot_Game/anu-treasure-map/resources/event/event_medical_physics_school_anatomical_model_choice_a_success.png`
    - **Show during**: Choice A outcome before treasure image.
    - **Prompt**: 16:9 pixel-art scene of two students respectfully studying the anatomical torso model from outside the display, one pointing to a simplified organ shape while the other writes careful notes, warm medical-school hallway, learning and respect theme, no gore, no readable text, no UI.
  - `choice_b_miss`: `/ANU_TreasureMap/Godot_Game/anu-treasure-map/resources/event/event_medical_physics_school_anatomical_model_choice_b_miss.png`
    - **Show during**: Choice B outcome.
    - **Prompt**: 16:9 pixel-art scene near a closed authorised-access door beyond the display area, a student hesitates while another gently points back toward the public teaching model and noticeboard, calm boundary-respecting mood, no warning text, no gore, no UI.
  - `choice_c_hint`: `/ANU_TreasureMap/Godot_Game/anu-treasure-map/resources/event/event_medical_physics_school_anatomical_model_choice_c_hint.png`
    - **Show during**: Choice C outcome.
    - **Prompt**: 16:9 pixel-art scene of a student guide helping the player write down proper anatomy terminology beside the anatomical model display, icons for study, ethics, and asking permission, hopeful next-time learning mood, no readable text, no UI.

### Narrative

1. Medical & Physics School의 복도를 지나가는데, 어두운 게시판 앞 진열대에서 인체 모형 하나가 조용히 서 있다.
2. 모형의 한쪽은 얼굴과 몸의 표면을, 다른 한쪽은 장기와 혈관의 색을 보여 준다.
3. 옆에는 skull anatomy poster처럼 보이는 큰 해부학 도표와 오래된 트로피들이 함께 놓여 있다.
4. 클립보드를 든 학생 가이드가 당신을 보고 안도의 숨을 쉰다.
5. "신입생 투어를 돕고 있는데, 이 모형 앞에서 어디까지 설명해도 되는지 헷갈려."
6. 그는 ANU에서 anatomy learning이 단순한 암기가 아니라 terminology, observation, 그리고 respect를 함께 배우는 일이라고 들었다고 한다.
7. 안내 카드 한 장에는 human remains와 anatomy facility 접근이 허가된 사람에게만 열리며, dignity and respect가 가장 먼저라는 내용이 정리되어 있다.
8. 다른 카드에는 anatomy and physiology practical에서 histology, anatomical specimens, and models of the human body를 다룬다는 문장이 보인다.
9. 하지만 지금 당신 앞에 있는 것은 restricted specimen이 아니라, 모두가 볼 수 있는 teaching model이다.
10. 학생 가이드는 조심스럽게 말한다. "이걸 보물처럼 만들려면, 신기함보다 먼저 태도를 보여 줘야 할 것 같아."
11. 모형은 말이 없지만, 몸 안쪽의 질서와 배움의 예의를 동시에 가리키고 있다.

### Choices

#### A. "보이는 모형만 관찰하고, 존중과 접근 규칙부터 설명하자."

- **Treasure found**: true
- **Outcome**
  1. 당신은 모형의 장기를 하나씩 맞히려 하기보다, 먼저 이 전시가 왜 조심스럽게 다뤄져야 하는지 설명한다.
  2. 학생 가이드는 terminology, observation, respect를 세 단어로 정리해 투어 노트 맨 위에 적는다.
  3. 지나가던 학생이 멈춰 서서 "그래서 anatomy가 외우는 과목만은 아니구나"라고 말한다.
  4. 당신은 Anatomical Model을 발견했다. 오늘의 보물은 몸의 구조를 보는 눈과, 배움 앞에서 몸을 낮추는 태도다.

#### B. "진짜 자료가 있는 안쪽 시설을 찾아보자."

- **Treasure found**: false
- **Re-trigger**: true
- **Outcome**
  1. 당신은 복도 안쪽의 제한 구역 표지 쪽으로 걸음을 옮기지만, 곧 멈춰 선다.
  2. 학생 가이드는 고개를 저으며 말한다. "거기는 authorised access가 필요한 곳이야. 오늘 우리가 볼 수 있는 건 이 teaching model까지야."
  3. 호기심은 좋은 시작이지만, 이 보물은 허락된 경계 안에서 더 선명해진다.

#### C. "먼저 정확한 용어와 설명 순서를 같이 정리하자."

- **Treasure found**: false
- **Re-trigger**: true
- **Boost trigger chance**: true
- **Outcome**
  1. 당신은 학생 가이드와 함께 skull, torso, organ, model, respect 같은 기본 단어를 노트에 정리한다.
  2. 그는 다음 투어 때는 모형을 더 차분히 설명할 수 있겠다며 웃는다.
  3. 아직 보물을 발견한 것은 아니지만, 다음에 이 모형을 볼 때 무엇을 먼저 말해야 하는지는 알게 되었다.

## Southwest -- Aboriginal Land Management

- **ID draft**: `southwest_aboriginal_land_management`
- **Location ID**: `southwest`
- **Treasure**: Aboriginal Land Management
- **Evidence note**: ANU's Aboriginal and Torres Strait Islander Heritage Trail explores the historical significance of Acton campus and continuing culture and connection to Country. ANU says the trail was developed by ANU Heritage in partnership with Canberra region Representative Aboriginal Organisations and funded by ACT Heritage. The official trail page explains that Aboriginal people used creeks and rivers to navigate the landscape, and that a clearing near today's South Oval was maintained through periodic burning to promote new growth and attract kangaroos. The user-provided photos show an Aboriginal Land Management sign and nearby eucalyptus woodland; this event treats the sign and surrounding Country as a respectful learning encounter, not as a claim that the player can perform cultural land management.

### Image Generation Manifest

- **Batch group**: `southwest_aboriginal_land_management`
- **Reference images**: user-provided sign and woodland photos; use only as visual inspiration for the angled interpretive sign, eucalyptus trees, dry grass, shrubs, bark textures, blue sky, and quiet trail atmosphere.
- **Generation order**: generate all prompts in this event group independently; save final outputs to the listed paths before JSON integration.
- **Shared negative prompt**: no sacred-site depiction, no ceremonial imagery, no invented Aboriginal symbols, no readable text, no logos, no tokenistic motifs, no UI overlay, no speech bubbles, no wildfire danger, no people performing cultural practices without context.

### Image Assets

- **Treasure image path**: `/ANU_TreasureMap/Godot_Game/anu-treasure-map/resources/treasure/treasure_aboriginal_land_management.png`
- **Treasure image prompt**: 1:1 pixel-art collectible image of a respectful campus heritage trail marker beside eucalyptus leaves, dry grass, small stones, and a curled strip of bark, warm Australian woodland palette, gentle educational mood, centered readable object, no readable text, no logos, no invented Aboriginal motifs.
- **Event image sequence**
  - `intro`: `/ANU_TreasureMap/Godot_Game/anu-treasure-map/resources/event/event_southwest_aboriginal_land_management_intro.png`
    - **Show during**: Narrative 1-4.
    - **Prompt**: 16:9 warm pixel-art ANU Southwest woodland path inspired by the provided photos, angled black interpretive sign in the foreground, dense green shrubs, eucalyptus trees, dry leaf litter, bright blue sky, two students pausing respectfully at the sign, no readable text, no UI.
  - `investigation`: `/ANU_TreasureMap/Godot_Game/anu-treasure-map/resources/event/event_southwest_aboriginal_land_management_investigation.png`
    - **Show during**: Narrative 5-12 and choice display.
    - **Prompt**: 16:9 pixel-art close study of a heritage trail sign and surrounding Country: eucalyptus bark, grass clearing, creek-path clue represented by a small map line, careful student notes with icon-like marks for water, fire, grass, and respect, no readable text, no logos, no UI.
  - `choice_a_success`: `/ANU_TreasureMap/Godot_Game/anu-treasure-map/resources/event/event_southwest_aboriginal_land_management_choice_a_success.png`
    - **Show during**: Choice A outcome before treasure image.
    - **Prompt**: 16:9 pixel-art scene of students standing on the path and reading the Aboriginal land management sign carefully without stepping off trail, eucalyptus woodland opening around them, quiet learning and respect for Country, no readable text, no UI.
  - `choice_b_miss`: `/ANU_TreasureMap/Godot_Game/anu-treasure-map/resources/event/event_southwest_aboriginal_land_management_choice_b_miss.png`
    - **Show during**: Choice B outcome.
    - **Prompt**: 16:9 pixel-art view of a student walking past the sign too quickly toward a shortcut, the woodland still beautiful but the interpretive sign left behind, gentle missed-learning mood, no readable text, no UI.
  - `choice_c_hint`: `/ANU_TreasureMap/Godot_Game/anu-treasure-map/resources/event/event_southwest_aboriginal_land_management_choice_c_hint.png`
    - **Show during**: Choice C outcome.
    - **Prompt**: 16:9 pixel-art scene of students sitting near the path, not on sensitive ground, saving the ANU heritage trail route on a phone and sketching eucalyptus leaves and creek lines in a notebook, hopeful next-time learning mood, no readable text, no UI.

### Narrative

1. Southwest 쪽 길은 캠퍼스라기보다 잠깐 숲의 가장자리에 들어선 것처럼 조용하다.
2. 키 큰 eucalyptus 사이로 햇빛이 잘게 부서지고, 낮은 관목 사이에 검은색 안내판 하나가 서 있다.
3. 안내판의 제목은 Aboriginal Land Management다.
4. 옆에서 사진을 찍던 학생이 휴대폰을 내리고 말한다. "처음엔 그냥 산책로인 줄 알았는데, 여기는 읽는 방법이 필요한 것 같아."
5. 안내판은 이 풍경이 비어 있던 자연이 아니라, 오래 전부터 사람의 지식과 돌봄이 깃든 Country였음을 말해 준다.
6. ANU Heritage Trail 설명에는 Acton campus가 Aboriginal and Torres Strait Islander history, continuing culture, and connection to Country를 품고 있다고 적혀 있다.
7. 또 Sullivans Creek과 Molonglo로 이어지는 물길이 이동과 자원의 길이었고, 물은 사람과 동물을 함께 불러 모았다고 한다.
8. 학생은 작은 노트에 water, grass, fire, kangaroo, respect를 적는다.
9. South Oval 근처의 clearing이 periodic burning을 통해 새 풀을 돋게 하고 kangaroo를 끌어들이는 방식으로 관리되었다는 이야기도 이어진다.
10. 하지만 이 지식은 플레이어가 따라 해 볼 기술이 아니라, 먼저 듣고, 인정하고, 조심히 걸어야 하는 안내다.
11. 당신은 표지판, 나무껍질, 낮은 풀, 그리고 길의 방향을 함께 본다.
12. 숲은 조용하지만, 아무 말도 하지 않는 것은 아니다.

### Choices

#### A. "표지판을 끝까지 읽고, 길 위에서 풍경의 단서를 같이 정리하자."

- **Treasure found**: true
- **Outcome**
  1. 당신은 학생과 함께 안내판의 단서를 물길, 풀, 불, 동물, 존중이라는 순서로 정리한다.
  2. 길 밖으로 들어가지 않고도, 풍경은 조금씩 다른 문장으로 읽히기 시작한다.
  3. 학생은 "이제 여기가 그냥 숲처럼만 보이지 않아"라고 조용히 말한다.
  4. 당신은 Aboriginal Land Management를 발견했다. 오늘의 보물은 땅을 소유하는 지식이 아니라, Country를 돌봄의 관계로 읽는 태도다.

#### B. "사진은 찍었으니 이제 지름길로 가자."

- **Treasure found**: false
- **Re-trigger**: true
- **Outcome**
  1. 당신은 안내판을 빠르게 지나쳐 더 짧아 보이는 길을 찾는다.
  2. 나무와 바람은 여전히 아름답지만, 표지판이 열어 주려던 이야기의 순서는 뒤에 남는다.
  3. 사진은 남았지만, 오늘의 장소가 왜 여기서 멈춰 서라고 했는지는 아직 읽지 못했다.

#### C. "오늘은 여기까지만 읽고, ANU Heritage Trail을 다음 산책으로 저장하자."

- **Treasure found**: false
- **Re-trigger**: true
- **Boost trigger chance**: true
- **Outcome**
  1. 당신은 학생과 함께 ANU Walks의 Heritage Trail 경로를 찾아 다음에 걸을 지점들을 표시한다.
  2. 노트에는 creek, clearing, burning, Country라는 단어가 남는다.
  3. 아직 보물을 발견한 것은 아니지만, 다음번에는 이 길이 산책로가 아니라 질문으로 시작될 것이다.

## Houses -- Canberra Traditional Bus Stop

- **ID draft**: `houses_canberra_traditional_bus_stop`
- **Location ID**: `houses`
- **Treasure**: Canberra Traditional Bus Stop
- **Evidence note**: ACT Government heritage material describes Canberra's pre-cast concrete bus shelters as distinctive objects of architectural, historical, and cultural significance across the ACT. The statement attributes the design to architect Clement Cummings, selected by the National Capital Development Commission in 1975, and notes their brutalist simplicity, modular construction, relocatable purpose, and strong Canberra identity. Transport Canberra's official bus guidance also tells passengers to find the stop ID, check timetables, arrive early, check the bus number, and signal the driver safely by raising an arm. The user-provided photo shows a concrete shelter with circular cut-outs, a Transport Canberra stop sign, and a bicycle-lane sign near the Houses node; this event treats the shelter as an everyday piece of Canberra design and public-transport literacy.

### Image Generation Manifest

- **Batch group**: `houses_canberra_traditional_bus_stop`
- **Reference image**: user-provided concrete bus stop photo; use only as visual inspiration for the beige concrete shelter, round window/door shapes, roadside bus stop pole, bicycle-lane sign silhouette, spring trees, and residential campus edge.
- **Generation order**: generate all prompts in this event group independently; save final outputs to the listed paths before JSON integration.
- **Shared negative prompt**: no readable route numbers, no real ACT logo, no legible graffiti, no cars hitting road users, no unsafe road crossing, no UI overlay, no speech bubbles, no watermark.

### Image Assets

- **Treasure image path**: `/ANU_TreasureMap/Godot_Game/anu-treasure-map/resources/treasure/treasure_canberra_traditional_bus_stop.png`
- **Treasure image prompt**: 1:1 pixel-art collectible image of a small Canberra-style pre-cast concrete bus shelter with rounded circular cut-outs, a tiny bus stop pole, a folded timetable card without readable text, green grass and spring trees behind, warm everyday-city mood, centered readable silhouette, no logos, no readable numbers.
- **Event image sequence**
  - `intro`: `/ANU_TreasureMap/Godot_Game/anu-treasure-map/resources/event/event_houses_canberra_traditional_bus_stop_intro.png`
    - **Show during**: Narrative 1-4.
    - **Prompt**: 16:9 warm pixel-art scene near ANU Houses, beige Canberra concrete bus shelter with round window cut-outs inspired by the provided photo, bus stop pole and bike-lane sign silhouette beside a quiet road, spring trees and residential buildings, two students noticing the shelter, no readable text, no UI.
  - `investigation`: `/ANU_TreasureMap/Godot_Game/anu-treasure-map/resources/event/event_houses_canberra_traditional_bus_stop_investigation.png`
    - **Show during**: Narrative 5-11 and choice display.
    - **Prompt**: 16:9 pixel-art close study of the concrete bus shelter: rounded openings, weathered concrete texture, tiny timetable panel, stop ID plate shown as non-readable blocks, student notebook with icon clues for shelter design, stop ID, timetable, signal arm, safe kerb distance, no readable text, no UI.
  - `choice_a_success`: `/ANU_TreasureMap/Godot_Game/anu-treasure-map/resources/event/event_houses_canberra_traditional_bus_stop_choice_a_success.png`
    - **Show during**: Choice A outcome before treasure image.
    - **Prompt**: 16:9 pixel-art scene of two students waiting safely at a Canberra concrete bus shelter, one checking a phone timetable and the other raising an arm from a safe distance as a bus approaches in the background, calm public-transport confidence, no readable text, no UI.
  - `choice_b_miss`: `/ANU_TreasureMap/Godot_Game/anu-treasure-map/resources/event/event_houses_canberra_traditional_bus_stop_choice_b_miss.png`
    - **Show during**: Choice B outcome.
    - **Prompt**: 16:9 pixel-art scene of a student walking past the concrete shelter without checking the stop sign while a bus is already leaving in the distance, gentle missed-timing mood, safe footpath, no readable text, no UI.
  - `choice_c_hint`: `/ANU_TreasureMap/Godot_Game/anu-treasure-map/resources/event/event_houses_canberra_traditional_bus_stop_choice_c_hint.png`
    - **Show during**: Choice C outcome.
    - **Prompt**: 16:9 pixel-art scene of students sitting inside a Canberra concrete bus shelter, saving the stop ID and timetable on a phone, sketching the round shelter shape in a notebook, hopeful next-trip mood, soft spring light, no readable text, no UI.

### Narrative

1. Houses 근처의 조용한 길가에서, 둥근 구멍이 난 낮은 콘크리트 구조물이 햇빛을 받고 있다.
2. 처음 보면 작은 벙커 같고, 두 번째로 보면 버스정류장이고, 세 번째로 보면 Canberra가 오래 들고 다닌 도시의 습관처럼 보인다.
3. 정류장 기둥 옆에는 버스 표지와 timetable panel, 그리고 bike lane 표지가 함께 서 있다.
4. 한 학생이 shelter 안쪽의 둥근 벽을 바라보다가 말한다. "이게 Canberra traditional bus stop이라는 거야?"
5. 그는 막 이사 온 학생에게 버스 타는 법을 알려줘야 하는데, stop ID와 timetable을 어디서부터 설명해야 할지 모르겠다고 한다.
6. ACT heritage 자료는 Canberra의 pre-cast concrete bus shelters가 ACT 전역에 남아 있는 독특한 도시 물건이며, Clement Cummings의 설계와 1975년 NCDC 선택을 통해 퍼졌다고 설명한다.
7. 단순한 콘크리트, 둥근 opening, 옮겨 설치할 수 있는 modular form은 기능을 위해 만들어졌지만, 시간이 지나 Canberra의 얼굴이 되었다.
8. Transport Canberra 안내는 stop ID를 찾고, timetable을 확인하고, 출발 5분 전쯤 도착하고, 접근하는 버스의 번호를 확인하라고 말한다.
9. 버스가 오면 kerb에서 안전한 거리를 두고 팔을 들어 driver에게 signal해야 한다.
10. 학생은 오래된 shelter와 새 phone timetable을 번갈아 본다. "건물은 옛날인데, 쓰는 법은 아직 살아 있네."
11. 이 보물은 버스를 기다리는 기술이자, 도시가 매일 반복해서 자신을 가르치는 방식일지도 모른다.

### Choices

#### A. "stop ID, timetable, bus number, signal 순서로 같이 연습하자."

- **Treasure found**: true
- **Outcome**
  1. 당신은 먼저 stop ID를 확인하고, 학생과 함께 phone timetable에서 다음 버스를 찾는다.
  2. 버스가 가까워지자 둘은 번호를 확인하고, kerb에서 떨어진 자리에서 팔을 들어 signal한다.
  3. shelter의 둥근 그림자가 발밑에 머무는 동안, 오래된 콘크리트 구조물은 아주 현재적인 사용법을 되찾는다.
  4. 당신은 Canberra Traditional Bus Stop을 발견했다. 오늘의 보물은 정류장 자체가 아니라, 도시의 오래된 모양을 오늘의 이동으로 읽는 감각이다.

#### B. "버스는 오면 그냥 타면 되지. 먼저 걸어가 보자."

- **Treasure found**: false
- **Re-trigger**: true
- **Outcome**
  1. 당신은 stop ID도 timetable도 확인하지 않고 길을 따라 걷기 시작한다.
  2. 뒤에서 버스가 잠깐 멈췄다가, 아무도 signal하지 않자 조용히 떠난다.
  3. 길을 잃은 것은 아니지만, 이 도시의 작은 예절 하나는 다음 정류장으로 넘어갔다.

#### C. "오늘은 타지 말고, 이 shelter 모양과 stop 정보를 기록해 두자."

- **Treasure found**: false
- **Re-trigger**: true
- **Boost trigger chance**: true
- **Outcome**
  1. 학생은 phone에 stop ID와 timetable 확인법을 저장하고, 노트에는 둥근 opening이 있는 shelter 모양을 그린다.
  2. 그는 "다음엔 버스가 오기 전에 이미 준비돼 있겠다"며 웃는다.
  3. 아직 보물을 발견한 것은 아니지만, 다음번에는 기다림이 막연하지 않을 것이다.

## Houses -- Spiral Floor Tile (Chantale Delrue)

- **ID draft**: `houses_spiral_floor_tile`
- **Location ID**: `houses`
- **Treasure**: Spiral Floor Tile
- **Evidence note**: ANU Sculpture Walk material identifies Chantale Delrue's `Involution/evolution` as a 2002 unglazed ceramic tile mosaic, commissioned in 2002 on the grounds of the Centre for European Studies. The same source says Delrue was born in Belgium in 1951, arrived in Australia in 1974, trained in Belgium and Launceston, and works with public art and site-specific commissions. It describes the pavement mosaic as a strong focal point at the meeting area of three buildings, where a blue coil of sea bringing European creatures and plants folds into a native ochre circle representing Australia; the spiral's cyclical movement embodies continuity, energy, and change. This draft maps the encounter to the Houses node as a game location assignment, while keeping the official artwork facts tied to the ANU Sculpture Walk source and the user-provided photo.

### Image Generation Manifest

- **Batch group**: `houses_spiral_floor_tile`
- **Reference image**: user-provided spiral tile mosaic photo; use only as visual inspiration for a circular pavement mosaic, spiral movement, ochre and blue tile fields, stylized animals and plants, brick rim, timber/deck edge, and sunny campus courtyard setting.
- **Generation order**: generate all prompts in this event group independently; save final outputs to the listed paths before JSON integration.
- **Shared negative prompt**: no exact reproduction of Chantale Delrue's mosaic, no artist-name text, no readable labels, no official logos, no photorealism, no people standing on delicate artwork, no vandalism, no UI overlay, no speech bubbles, no watermark.

### Image Assets

- **Treasure image path**: `/ANU_TreasureMap/Godot_Game/anu-treasure-map/resources/treasure/treasure_spiral_floor_tile.png`
- **Treasure image prompt**: 1:1 original pixel-art collectible inspired by a circular ceramic floor mosaic, a clear spiral of blue and ochre tiles with simplified native leaves, sea-creature silhouettes, and tiny animal shapes arranged around a warm brick rim, centered readable object, sunny campus-courtyard mood, no exact copy of the real artwork, no readable text, no logos.
- **Event image sequence**
  - `intro`: `/ANU_TreasureMap/Godot_Game/anu-treasure-map/resources/event/event_houses_spiral_floor_tile_intro.png`
    - **Show during**: Narrative 1-4.
    - **Prompt**: 16:9 warm pixel-art ANU Houses courtyard scene inspired by the provided photo, circular spiral floor mosaic set into paving, blue and ochre tile fields, leafy garden edge, low campus buildings, one student noticing the artwork from the path, bright midday light, no exact reproduction, no readable text, no UI.
  - `investigation`: `/ANU_TreasureMap/Godot_Game/anu-treasure-map/resources/event/event_houses_spiral_floor_tile_investigation.png`
    - **Show during**: Narrative 5-11 and choice display.
    - **Prompt**: 16:9 pixel-art close study of an original spiral pavement mosaic: blue coil, ochre circle, stylized plants, European sea-creature hints, Australian animal silhouettes, small non-readable sculpture-walk card, notebook icons for title, artist, meeting place, continuity, energy, change, respectful viewing from the edge, no UI.
  - `choice_a_success`: `/ANU_TreasureMap/Godot_Game/anu-treasure-map/resources/event/event_houses_spiral_floor_tile_choice_a_success.png`
    - **Show during**: Choice A outcome before treasure image.
    - **Prompt**: 16:9 pixel-art scene of two students tracing the spiral mosaic with their eyes from the edge of the pavement, not stepping on the artwork, sunlight revealing blue and ochre tile movement, campus buildings meeting around the courtyard, calm discovery mood, no readable text, no UI.
  - `choice_b_miss`: `/ANU_TreasureMap/Godot_Game/anu-treasure-map/resources/event/event_houses_spiral_floor_tile_choice_b_miss.png`
    - **Show during**: Choice B outcome.
    - **Prompt**: 16:9 pixel-art scene of a student hurrying across a courtyard path while the circular spiral mosaic remains partly cropped behind them, beautiful artwork overlooked, gentle missed-clue mood, safe campus walkway, no readable text, no UI.
  - `choice_c_hint`: `/ANU_TreasureMap/Godot_Game/anu-treasure-map/resources/event/event_houses_spiral_floor_tile_choice_c_hint.png`
    - **Show during**: Choice C outcome.
    - **Prompt**: 16:9 pixel-art scene of students sitting near the circular mosaic edge, comparing a phone sculpture-walk map with a sketch of a spiral and animal/plant tile shapes in a notebook, hopeful next-visit mood, warm courtyard light, no readable text, no UI.

### Narrative

1. Houses 근처의 작은 courtyard를 지나가는데, 바닥이 갑자기 그림처럼 열려 있다.
2. 둥근 tile mosaic 안에서 파란 선은 물결처럼 말려 들어가고, ochre 색의 원은 햇빛을 오래 품은 땅처럼 퍼져 있다.
3. 잎, 동물, 바다 생물 같은 작은 형태들이 spiral을 따라 서로의 자리로 흘러간다.
4. 한 학생이 가장자리에서 발을 멈추고 말한다. "이거 그냥 장식 타일이 아니지?"
5. 그는 Sculpture Walk 자료를 들고 있지만, 작품 설명의 순서를 잃어버렸다.
6. 카드에는 Chantale Delrue의 `Involution/evolution`, 2002, unglazed ceramic tile mosaic이라고 적혀 있다.
7. 안내는 이 pavement mosaic이 세 건물이 만나는 지점의 focal point가 되도록 만들어졌다고 설명한다.
8. blue coil of sea는 European creatures and plants를 데려오고, 그것이 native ochre circle, 즉 Australia의 원 안으로 접혀 들어간다.
9. spiral의 cyclical movement는 continuity를 뜻하지만, 동시에 energy와 change가 지나는 통로이기도 하다.
10. 학생은 mosaic을 내려다보며 말한다. "그러니까 이건 한 방향으로만 걷는 길이 아니라, 서로 다른 것들이 계속 돌아와 만나는 지도네."
11. 바닥은 움직이지 않지만, 그 안의 선들은 캠퍼스의 발걸음보다 오래된 리듬으로 계속 돌고 있다.

### Choices

#### A. "가장자리에서 spiral을 따라 읽고, blue coil과 ochre circle의 만남을 정리하자."

- **Treasure found**: true
- **Outcome**
  1. 당신은 학생과 함께 바닥을 밟지 않고 가장자리에서 spiral의 흐름을 눈으로 따라간다.
  2. blue coil, European plants and creatures, native ochre circle, continuity, energy, change가 하나의 문장처럼 이어진다.
  3. 학생은 "이제 이 바닥이 지나가는 길이 아니라, 만나는 장소로 보여"라고 말한다.
  4. 당신은 Spiral Floor Tile을 발견했다. 오늘의 보물은 발밑의 장식이 아니라, 서로 다른 세계가 한 원 안에서 계속 움직이는 감각이다.

#### B. "예쁜 타일이네. 지름길로 가면서 대충 보자."

- **Treasure found**: false
- **Re-trigger**: true
- **Outcome**
  1. 당신은 mosaic을 한눈에 보고 길을 재촉한다.
  2. 파란 선과 ochre 원은 잠깐 반짝였지만, 작품이 열어 주려던 연결의 순서는 뒤에 남는다.
  3. 아무것도 망친 것은 아니지만, 오늘의 spiral은 아직 당신에게 돌아오지 않았다.

#### C. "작품명과 artist name을 저장하고, 다음엔 Sculpture Walk 순서대로 찾아보자."

- **Treasure found**: false
- **Re-trigger**: true
- **Boost trigger chance**: true
- **Outcome**
  1. 학생은 `Involution/evolution`, Chantale Delrue, 2002를 phone note에 저장한다.
  2. 노트 한쪽에는 blue coil, ochre circle, continuity, change라는 단어가 작게 남는다.
  3. 아직 보물을 발견한 것은 아니지만, 다음번에는 바닥의 spiral이 어디서 시작되는지 알 수 있을 것이다.

## Blocks -- Metal Frames Sculpture (Six fixed)

- **ID draft**: `blocks_metal_frames_sculpture_six_fixed`
- **Location ID**: `blocks`
- **Treasure**: Metal Frames Sculpture
- **Evidence note**: ANU Sculpture Walk material identifies Angela Dufty's `Six fixed` as a 2004 painted steel sculpture, commissioned in 2003 for the Chemistry Building grounds on Science Road. The same source says Dufty is a graduate of the ANU School of Art and was Artist in Residence at the Sculpture Workshop in 2003. It describes her sculptures as inspired by geometric forms in architecture and other built structures; their linearity and openness can feel like drawings in space, while regular intervals, right angles, and shifting light and shadow make the work read like a playful optical illusion. This draft maps the encounter to the Blocks node as a game location assignment, while keeping official artwork facts tied to the ANU Sculpture Walk source and the user-provided photo.

### Image Generation Manifest

- **Batch group**: `blocks_metal_frames_sculpture_six_fixed`
- **Reference image**: user-provided metal frame sculpture photo; use only as visual inspiration for tilted painted-steel rectangular frames, open linear geometry, eucalypt backdrop, rock bed, grass, blue sky, and shifting shadows.
- **Generation order**: generate all prompts in this event group independently; save final outputs to the listed paths before JSON integration.
- **Shared negative prompt**: no exact reproduction of Angela Dufty's sculpture, no readable labels, no official logos, no climbing, no touching the artwork, no unsafe interaction, no photorealism, no UI overlay, no speech bubbles, no watermark.

### Image Assets

- **Treasure image path**: `/ANU_TreasureMap/Godot_Game/anu-treasure-map/resources/treasure/treasure_metal_frames_sculpture.png`
- **Treasure image prompt**: 1:1 original pixel-art collectible inspired by a painted-steel public sculpture made of six tilted rectangular metal frames, open right-angle geometry, small rocks and grass at the base, eucalyptus leaves behind, strong light-and-shadow pattern, centered readable silhouette, no exact copy, no readable text, no logos.
- **Event image sequence**
  - `intro`: `/ANU_TreasureMap/Godot_Game/anu-treasure-map/resources/event/event_blocks_metal_frames_sculpture_six_fixed_intro.png`
    - **Show during**: Narrative 1-4.
    - **Prompt**: 16:9 warm pixel-art ANU Blocks green space inspired by the provided photo, tilted painted-steel rectangular frame sculpture near eucalyptus trees, grass and small rock bed, blue sky with soft clouds, one student stopping at a strange angle, no exact reproduction, no readable text, no UI.
  - `investigation`: `/ANU_TreasureMap/Godot_Game/anu-treasure-map/resources/event/event_blocks_metal_frames_sculpture_six_fixed_investigation.png`
    - **Show during**: Narrative 5-11 and choice display.
    - **Prompt**: 16:9 pixel-art close study of an original open metal-frame sculpture, six nested rectangular frames, right angles, repeated intervals, shadows falling across grass and rocks, student notebook icons for artist, painted steel, architecture, drawing in space, optical illusion, respectful distance, no readable text, no UI.
  - `choice_a_success`: `/ANU_TreasureMap/Godot_Game/anu-treasure-map/resources/event/event_blocks_metal_frames_sculpture_six_fixed_choice_a_success.png`
    - **Show during**: Choice A outcome before treasure image.
    - **Prompt**: 16:9 pixel-art scene of two students viewing an open metal-frame sculpture from a respectful distance, moving around the path to align the frames with tree branches and shadows, playful optical illusion feeling, warm campus light, no readable text, no UI.
  - `choice_b_miss`: `/ANU_TreasureMap/Godot_Game/anu-treasure-map/resources/event/event_blocks_metal_frames_sculpture_six_fixed_choice_b_miss.png`
    - **Show during**: Choice B outcome.
    - **Prompt**: 16:9 pixel-art scene of a student walking straight past the tilted metal frames while the shadows form a hidden geometric pattern behind them, gentle missed-clue mood, safe grass path, eucalyptus backdrop, no readable text, no UI.
  - `choice_c_hint`: `/ANU_TreasureMap/Godot_Game/anu-treasure-map/resources/event/event_blocks_metal_frames_sculpture_six_fixed_choice_c_hint.png`
    - **Show during**: Choice C outcome.
    - **Prompt**: 16:9 pixel-art scene of students sketching six rectangular frames and shadow lines in a notebook beside a campus path, phone sculpture-walk map shown as non-readable blocks, metal sculpture in background, hopeful next-visit mood, no readable text, no UI.

### Narrative

1. Blocks 근처 잔디밭에서, 금속으로 된 직사각형들이 한쪽으로 기울어진 채 나무 사이에 걸려 있다.
2. 처음에는 무너진 울타리처럼 보이지만, 가까이서 보면 선들이 너무 정확해서 오히려 공중에 그린 도면 같다.
3. 햇빛이 바뀔 때마다 steel bars의 그림자는 잔디와 돌 위에 또 다른 frame을 만든다.
4. 한 학생이 조형물 앞에서 눈을 가늘게 뜬다. "이건 어디서 봐야 제대로 보이는 거야?"
5. 그는 Sculpture Walk 자료에서 Angela Dufty의 `Six fixed`를 찾았지만, 설명의 핵심을 아직 붙잡지 못했다.
6. 자료에는 이 작품이 2004년 painted steel sculpture이고, 2003년에 Chemistry Building grounds, Science Road를 위해 commissioned되었다고 적혀 있다.
7. Dufty는 ANU School of Art graduate이며, 2003년에 Sculpture Workshop의 Artist in Residence였다.
8. 설명은 그녀의 sculpture가 built environment의 architectural geometry에서 영감을 받았다고 말한다.
9. open lines와 right angles는 공중에 그린 drawing처럼 보이고, regular intervals는 질서를 만든다.
10. 그런데 빛과 그림자가 bars 위에서 엇갈리면, 그 질서는 장난스러운 optical illusion처럼 흔들린다.
11. 학생은 한 발 뒤로 물러서며 말한다. "정답 위치가 있는 게 아니라, 움직일수록 작품이 새로 고정되는 거네."

### Choices

#### A. "조형물은 건드리지 말고, 가장자리에서 각도와 그림자를 같이 맞춰 보자."

- **Treasure found**: true
- **Outcome**
  1. 당신은 학생과 함께 path 위에서 천천히 위치를 바꾸며 six frames가 겹치는 순간을 찾는다.
  2. bars, right angles, tree branches, shadows가 한 장의 공중 drawing처럼 맞물린다.
  3. 학생은 "fixed라는 말이 이상하네. 움직이는 건 우리인데, 작품이 계속 새로 고정돼"라고 웃는다.
  4. 당신은 Metal Frames Sculpture를 발견했다. 오늘의 보물은 철의 무게가 아니라, 빛이 선을 흔들 때 공간이 살아나는 순간이다.

#### B. "그냥 철제 구조물이네. 가까이 가서 만져 보면 알겠지."

- **Treasure found**: false
- **Re-trigger**: true
- **Outcome**
  1. 당신은 조형물 쪽으로 너무 가까이 다가가려다, 학생의 손짓에 멈춘다.
  2. 공공 조형물은 만지는 물건이 아니라, 거리와 각도를 두고 읽는 물건일 때가 있다.
  3. 오늘의 frame은 아직 열리지 않았지만, 다음에는 그림자부터 보면 될 것 같다.

#### C. "작품명과 artist note를 저장하고, 다른 시간대의 그림자를 다시 보자."

- **Treasure found**: false
- **Re-trigger**: true
- **Boost trigger chance**: true
- **Outcome**
  1. 학생은 `Six fixed`, Angela Dufty, painted steel, optical illusion을 phone note에 저장한다.
  2. 노트 한쪽에는 여섯 개의 frame과 오후 그림자 방향이 간단한 선으로 남는다.
  3. 아직 보물을 발견한 것은 아니지만, 다음번에는 빛이 바뀌는 순간을 기다릴 이유가 생겼다.

## Southwest -- Winged harvest

- **ID draft**: `southwest_winged_harvest`
- **Location ID**: `southwest`
- **Treasure**: Winged harvest
- **Evidence note**: ANU Sculpture Walk material identifies Fiona Foley's `Winged harvest` as a 2001 work made from wood, aluminium, ochre, and stainless steel, commissioned in 2000 for the WEH Stanner Building courtyard. The same source says Foley studied at Sydney College of the Arts, East Sydney Technical College, and in London, won the Lloyd Rees Award for Outstanding Urban Design in 1995, and has work in major Australian collections. For this work, the source says Foley chose materials and imagery meaningful for the Indigenous inhabitants of the ACT: the poles contain historical recordings of Bogong moth collection and ceremony or ochre pit sites around Canberra; the seven wooden poles use traditional pigments, Bogong moth decoration, and notching to recall climbing techniques; the surrounding plantings are part of the installation. This draft maps the encounter to the Southwest node as a game location assignment, while keeping official artwork facts tied to the ANU Sculpture Walk source and avoiding invented cultural detail.

### Image Generation Manifest

- **Batch group**: `southwest_winged_harvest`
- **Reference image**: user-provided ANU Sculpture Walk page for `Winged harvest`; use only as visual inspiration for seven tall vertical poles in a courtyard, pale wood forms, ochre accents, stainless/aluminium details, eucalyptus tree canopy, surrounding plantings, and respectful campus-art atmosphere.
- **Generation order**: generate all prompts in this event group independently; save final outputs to the listed paths before JSON integration.
- **Shared negative prompt**: no exact reproduction of Fiona Foley's artwork, no sacred or ceremonial reenactment, no invented Indigenous symbols, no people touching or climbing poles, no readable labels, no official logos, no photorealism, no UI overlay, no speech bubbles, no watermark.

### Image Assets

- **Treasure image path**: `/ANU_TreasureMap/Godot_Game/anu-treasure-map/resources/treasure/treasure_winged_harvest.png`
- **Treasure image prompt**: 1:1 original pixel-art collectible inspired by a respectful public artwork of seven upright wooden poles with subtle ochre bands, tiny abstract Bogong moth wing shapes, aluminium and stainless steel glints, eucalyptus leaves and low plantings behind, centered readable silhouette, no exact copy, no sacred motifs, no readable text, no logos.
- **Event image sequence**
  - `intro`: `/ANU_TreasureMap/Godot_Game/anu-treasure-map/resources/event/event_southwest_winged_harvest_intro.png`
    - **Show during**: Narrative 1-4.
    - **Prompt**: 16:9 warm pixel-art Southwest campus courtyard inspired by the ANU Sculpture Walk page, seven tall pale wooden poles around a eucalyptus tree, low surrounding plantings, ochre accents, evening-gold windows in the background, two students pausing at the edge of the installation, respectful quiet mood, no exact reproduction, no readable text, no UI.
  - `investigation`: `/ANU_TreasureMap/Godot_Game/anu-treasure-map/resources/event/event_southwest_winged_harvest_investigation.png`
    - **Show during**: Narrative 5-12 and choice display.
    - **Prompt**: 16:9 pixel-art close study of an original seven-pole courtyard installation, wood grain, ochre bands, abstract moth-wing marks, notched pole surfaces, plantings at the base, student notebook icons for seven poles, Bogong moth, ochre, plantings, respect, and historical recording, no readable text, no UI.
  - `choice_a_success`: `/ANU_TreasureMap/Godot_Game/anu-treasure-map/resources/event/event_southwest_winged_harvest_choice_a_success.png`
    - **Show during**: Choice A outcome before treasure image.
    - **Prompt**: 16:9 pixel-art scene of two students standing respectfully outside a seven-pole installation, reading from a sculpture-walk note and observing plantings without touching, moth-wing silhouettes suggested by light between poles, eucalyptus courtyard, calm learning mood, no readable text, no UI.
  - `choice_b_miss`: `/ANU_TreasureMap/Godot_Game/anu-treasure-map/resources/event/event_southwest_winged_harvest_choice_b_miss.png`
    - **Show during**: Choice B outcome.
    - **Prompt**: 16:9 pixel-art scene of a student about to step too close to a public artwork of seven poles, another student gently indicating the viewing edge, installation remains dignified in background, missed-reading mood without danger, no readable text, no UI.
  - `choice_c_hint`: `/ANU_TreasureMap/Godot_Game/anu-treasure-map/resources/event/event_southwest_winged_harvest_choice_c_hint.png`
    - **Show during**: Choice C outcome.
    - **Prompt**: 16:9 pixel-art scene of students sitting nearby with a phone sculpture-walk map and notebook, sketching seven vertical lines, moth-wing shapes, ochre color swatches, and plantings as non-readable icons, WEH Stanner courtyard mood, hopeful next-visit feeling, no readable text, no UI.

### Narrative

1. Southwest 쪽 courtyard에 들어서자, 나무 사이로 일곱 개의 긴 poles가 조용히 서 있다.
2. 어떤 것은 창백한 줄기처럼 보이고, 어떤 것은 ochre 빛을 품은 표식처럼 보인다.
3. 주변 plantings는 장식처럼 바닥을 채우는 것이 아니라, 작품의 바깥 문장처럼 poles를 감싸고 있다.
4. Sculpture Walk 안내를 들고 있던 학생이 낮게 말한다. "이건 그냥 설치물이 아니라, 조심히 읽어야 하는 기록 같아."
5. 그는 Fiona Foley의 `Winged harvest` 페이지를 펼치지만, 어느 단서부터 말해야 할지 망설인다.
6. 안내에는 이 작품이 2001년에 완성된 wood, aluminium, ochre and stainless steel work이며, 2000년에 WEH Stanner Building courtyard를 위해 commissioned되었다고 적혀 있다.
7. Foley는 이 작품에서 ACT의 Indigenous inhabitants에게 의미 있는 materials and imagery를 선택했다.
8. poles는 Canberra 주변의 Bogong moth collection, ceremony sites, ochre pit sites에 관한 historical recordings를 품고 있다고 설명된다.
9. 일곱 wooden poles에는 traditional pigments, Bogong moth decoration, 그리고 climbing techniques를 떠올리게 하는 notching이 포함되어 있다.
10. 학생은 손을 뻗으려다 멈춘다. "만져서 아는 게 아니라, 남겨진 방식 그대로 봐야 하는 거지?"
11. 바람이 eucalyptus 잎을 흔들자, poles 사이의 빛이 잠깐 날개처럼 갈라진다.
12. 작품은 크게 말하지 않는다. 대신, harvest라는 단어가 땅과 기억과 이동의 무게를 천천히 드러낸다.

### Choices

#### A. "작품을 만지지 말고, 일곱 poles와 plantings를 차례로 읽어 보자."

- **Treasure found**: true
- **Outcome**
  1. 당신은 학생과 함께 가장자리에서 일곱 poles, ochre, moth imagery, notching, surrounding plantings를 순서대로 확인한다.
  2. 작품은 조형물 하나가 아니라, material, memory, place가 함께 세운 courtyard의 기록으로 보이기 시작한다.
  3. 학생은 "이제 harvest가 가져가는 말이 아니라, 기억을 다시 모으는 말처럼 들려"라고 조용히 말한다.
  4. 당신은 Winged harvest를 발견했다. 오늘의 보물은 보는 사람이 중심이 되는 순간이 아니라, 작품이 가리키는 Country와 history 앞에서 한 걸음 물러서는 태도다.

#### B. "가까이 가서 notch와 장식을 직접 만져 보면 더 잘 알 수 있겠지."

- **Treasure found**: false
- **Re-trigger**: true
- **Outcome**
  1. 당신이 한 발 가까이 다가가자, 학생이 조심스럽게 고개를 젓는다.
  2. 이 작품의 단서는 손끝보다 거리, 설명, 그리고 존중 안에서 더 분명해진다.
  3. 오늘의 poles는 아직 열리지 않았지만, 다음에는 먼저 가장자리에서 읽어야 한다는 것을 알게 되었다.

#### C. "작품명과 단어들을 저장하고, 다음엔 Sculpture Walk route로 다시 오자."

- **Treasure found**: false
- **Re-trigger**: true
- **Boost trigger chance**: true
- **Outcome**
  1. 학생은 `Winged harvest`, Fiona Foley, Bogong moth, ochre, seven poles, surrounding plantings를 phone note에 저장한다.
  2. 노트에는 손대지 않기, 흉내 내지 않기, 설명을 끝까지 읽기라는 세 문장이 함께 남는다.
  3. 아직 보물을 발견한 것은 아니지만, 다음번에는 이 courtyard가 더 천천히 말을 걸 것이다.

## Central -- Dragon Art Installation

- **ID draft**: `central_dragon_art_installation`
- **Location ID**: `central`
- **Treasure**: Dragon Art Installation
- **Evidence note**: The user-provided photo shows a suspended dragon art installation inside an ANU-like atrium with stairs, railings, doors, wall lights, and a hanging sculptural form. No official ANU source confirming the installation's title, artist, or permanent location was found in this pass, so this draft does not state those as official facts. For cultural context, ANU College of Asia & the Pacific material explains that Lunar New Year is widely celebrated across Asian cultures, that 2024 was the Year of the Wood Dragon, that the Chinese dragon is the only mythical creature in the 12 zodiac signs, and that it is associated with water, clouds, rain-making power, prosperity, auspiciousness, and change rather than Western fire-breathing danger. ANU Orientation also lists an ANUSA Lunar New Year Celebration at the Kambri Amphitheatre with a traditional dragon dance and student performances. The Australian Centre on China in the World is an ANU hub for Chinese studies; this event uses that broader ANU learning context without claiming the pictured dragon belongs to CIW.

### Image Generation Manifest

- **Batch group**: `central_dragon_art_installation`
- **Reference image**: user-provided indoor dragon installation photo; use only as visual inspiration for a suspended paper/fabric dragon, yellow body, green mane, red nose, white horns, atrium stairs, dark railings, warm wall lights, and a central-campus interior.
- **Generation order**: generate all prompts in this event group independently; save final outputs to the listed paths before JSON integration.
- **Shared negative prompt**: no exact reproduction of the photo, no readable emergency signs, no real logos, no fire-breathing Western dragon, no horror mood, no cultural caricature, no people climbing railings, no unsafe interaction, no photorealism, no UI overlay, no speech bubbles, no watermark.

### Image Assets

- **Treasure image path**: `/ANU_TreasureMap/Godot_Game/anu-treasure-map/resources/treasure/treasure_dragon_art_installation.png`
- **Treasure image prompt**: 1:1 original pixel-art collectible inspired by a suspended festive dragon art installation, yellow paper/fabric body, green mane, white horns, red nose, tiny hanging strings, warm atrium lights and staircase shapes behind, centered readable silhouette, auspicious and welcoming mood, no exact copy, no readable text, no logos.
- **Event image sequence**
  - `intro`: `/ANU_TreasureMap/Godot_Game/anu-treasure-map/resources/event/event_central_dragon_art_installation_intro.png`
    - **Show during**: Narrative 1-4.
    - **Prompt**: 16:9 warm pixel-art Central campus atrium inspired by the provided photo, suspended yellow and green dragon art installation above stairs and dark railings, soft wall lights, modern doors, a student pausing below and looking upward, festive but calm atmosphere, no exact reproduction, no readable text, no UI.
  - `investigation`: `/ANU_TreasureMap/Godot_Game/anu-treasure-map/resources/event/event_central_dragon_art_installation_investigation.png`
    - **Show during**: Narrative 5-12 and choice display.
    - **Prompt**: 16:9 pixel-art close study of an original suspended dragon installation: paper/fabric scales, green mane, red nose, white horns, hanging cords, student notebook icons for Lunar New Year, water, clouds, rain, prosperity, dragon dance, and central campus, respectful viewing from the stair landing, no readable text, no UI.
  - `choice_a_success`: `/ANU_TreasureMap/Godot_Game/anu-treasure-map/resources/event/event_central_dragon_art_installation_choice_a_success.png`
    - **Show during**: Choice A outcome before treasure image.
    - **Prompt**: 16:9 pixel-art scene of students standing safely on an atrium landing, looking up at a suspended festive dragon while one student explains water, clouds, rain-making, prosperity, and Lunar New Year connection with small non-readable icon notes, warm welcoming campus light, no exact copy, no UI.
  - `choice_b_miss`: `/ANU_TreasureMap/Godot_Game/anu-treasure-map/resources/event/event_central_dragon_art_installation_choice_b_miss.png`
    - **Show during**: Choice B outcome.
    - **Prompt**: 16:9 pixel-art scene of a student hurrying down central atrium stairs while the suspended dragon remains above, partly cropped by the frame, warm lights and rails, gentle missed-clue mood, no unsafe behavior, no readable text, no UI.
  - `choice_c_hint`: `/ANU_TreasureMap/Godot_Game/anu-treasure-map/resources/event/event_central_dragon_art_installation_choice_c_hint.png`
    - **Show during**: Choice C outcome.
    - **Prompt**: 16:9 pixel-art scene of students near a central atrium noticeboard saving Lunar New Year and ANUSA event notes on a phone, sketching a small dragon silhouette with cloud and water icons in a notebook, suspended dragon visible softly above stairs, hopeful next-event mood, no readable text, no UI.

### Narrative

1. Central의 실내 계단을 올라가려는 순간, 천장 쪽에서 노란 몸체가 부드럽게 휘어져 내려온다.
2. 초록 갈기와 흰 뿔, 빨간 코를 가진 dragon installation이 공중에 매달려 있다.
3. 벽 조명은 비늘처럼 작은 점들을 반짝이게 만들고, 검은 railings는 dragon의 그림자를 계단 위에 얇게 나눈다.
4. 한 학생이 고개를 들고 말한다. "무서운 용이라기보다, 뭔가 축제의 길잡이 같아."
5. 그는 Lunar New Year 행사를 찾고 있었지만, dragon이 왜 이렇게 자주 등장하는지 설명할 자신이 없다고 한다.
6. ANU College of Asia & the Pacific 자료는 Lunar New Year가 여러 Asian cultures에서 기념되는 festival이며, Chinese lunisolar calendar와 zodiac animals의 흐름 속에 있다고 설명한다.
7. 그 자료에서 Chinese dragon은 12 zodiac signs 중 유일한 mythical creature로 소개된다.
8. ANU experts는 Chinese dragon이 Western legends의 fire-breathing danger와 달리 water bodies, clouds, rain-making power와 연결되고, prosperity와 auspiciousness의 상징으로 여겨진다고 설명한다.
9. ANU Orientation에는 Kambri Amphitheatre의 ANUSA Lunar New Year Celebration이 traditional dragon dance와 student performances를 포함한다고 안내되어 있다.
10. 학생은 installation을 올려다본다. "그러면 이 dragon은 겁주는 괴물이 아니라, 사람들이 새해와 변화를 함께 바라보게 하는 모양이네."
11. 사진으로만 남기면 색이 먼저 보이지만, 설명을 붙이면 물, 구름, 춤, 축제, 행운이 한 줄로 이어진다.
12. 공중의 dragon은 계단을 막지 않는다. 오히려 Central을 지나가는 사람들에게 잠깐 위를 보라고 말하는 것 같다.

### Choices

#### A. "설치물은 건드리지 말고, dragon의 문화적 단서를 함께 정리하자."

- **Treasure found**: true
- **Outcome**
  1. 당신은 학생과 함께 dragon, Lunar New Year, water, clouds, rain-making, prosperity, student performances를 차례로 정리한다.
  2. dragon은 갑자기 낯선 장식이 아니라, 사람들이 같은 계단 아래에서 계절과 변화를 나누는 상징처럼 보인다.
  3. 학생은 "위에 매달린 게 아니라, 캠퍼스 분위기를 살짝 들어 올리고 있었네"라고 웃는다.
  4. 당신은 Dragon Art Installation을 발견했다. 오늘의 보물은 화려한 색이 아니라, 다른 문화의 상징을 질문하고 배워 보려는 밝은 시선이다.

#### B. "멋있다. 사진만 찍고 바로 내려가자."

- **Treasure found**: false
- **Re-trigger**: true
- **Outcome**
  1. 당신은 빠르게 사진을 찍고 계단을 내려간다.
  2. dragon의 노란 몸체와 초록 갈기는 사진 속에 남았지만, 물과 구름과 축제의 단서는 공중에 그대로 매달려 있다.
  3. 나쁜 선택은 아니지만, 오늘의 dragon은 아직 장식 이상의 이름을 얻지 못했다.

#### C. "Lunar New Year event와 CIW/Chinese studies 자료를 저장해 두자."

- **Treasure found**: false
- **Re-trigger**: true
- **Boost trigger chance**: true
- **Outcome**
  1. 학생은 phone note에 ANUSA Lunar New Year Celebration, dragon dance, Chinese dragon, water, prosperity를 저장한다.
  2. 그는 다음번에는 공연이나 전시 안내까지 같이 확인해 보겠다고 말한다.
  3. 아직 보물을 발견한 것은 아니지만, Central을 지날 때 위를 올려다볼 이유가 생겼다.

## Fellows Oval -- Game On

- **ID draft**: `fellows_oval_game_on`
- **Location ID**: `fellows_oval`
- **Treasure**: Game On
- **Evidence note**: Kambri at ANU describes Game On as a free games arcade in Joplin Lane, Shop 156-B6, featuring pinball and arcade machines, air hockey, ping pong, and more. The page says it is free for ANU students, staff, and visitors, presented by Kambri at ANU, and surrounded by specially commissioned large-scale artworks by current and former ANU School of Art & Design students. ANU's self-guided campus tour also lists Joplin Lane businesses and services, including Game On as a free games arcade. The user-provided photo shows the Game On window and Joplin Lane frontage; this draft maps the encounter to Fellows Oval as a post-oval student route toward Joplin Lane, not as a claim that Game On is physically on Fellows Oval.

### Image Generation Manifest

- **Batch group**: `fellows_oval_game_on`
- **Reference image**: user-provided Game On storefront photo; use only as visual inspiration for a Joplin Lane wooden facade, large window glow, lightning-sign shape, open doorway, posters inside, and arcade/social hangout mood.
- **Generation order**: generate all prompts in this event group independently; save final outputs to the listed paths before JSON integration.
- **Shared negative prompt**: no exact storefront reproduction, no readable signs or route numbers, no real logos, no gambling/casino imagery, no aggressive competition, no unsafe street behavior, no photorealism, no UI overlay, no speech bubbles, no watermark.

### Image Assets

- **Treasure image path**: `/ANU_TreasureMap/Godot_Game/anu-treasure-map/resources/treasure/treasure_game_on.png`
- **Treasure image prompt**: 1:1 original pixel-art collectible inspired by a free campus arcade hangout, tiny pinball machine, air hockey puck, ping pong paddle, arcade joystick, and lightning-shaped window glow, warm Joplin Lane wood tones, centered playful object cluster, no readable text, no logos, no exact copy.
- **Event image sequence**
  - `intro`: `/ANU_TreasureMap/Godot_Game/anu-treasure-map/resources/event/event_fellows_oval_game_on_intro.png`
    - **Show during**: Narrative 1-4.
    - **Prompt**: 16:9 warm pixel-art route from Fellows Oval toward Joplin Lane, sweaty students carrying sports gear, wooden storefront with glowing arcade window in the distance, lightning-like sign shape without readable text, open doorway, relaxed after-game mood, no exact reproduction, no UI.
  - `investigation`: `/ANU_TreasureMap/Godot_Game/anu-treasure-map/resources/event/event_fellows_oval_game_on_investigation.png`
    - **Show during**: Narrative 5-11 and choice display.
    - **Prompt**: 16:9 pixel-art close view inside a free campus arcade hangout: pinball, arcade cabinet silhouettes, air hockey table, ping pong table, large student-made wall art, notebook icons for free entry, Joplin Lane, SOAD art, share turns, and relax, no readable text, no logos, no UI.
  - `choice_a_success`: `/ANU_TreasureMap/Godot_Game/anu-treasure-map/resources/event/event_fellows_oval_game_on_choice_a_success.png`
    - **Show during**: Choice A outcome before treasure image.
    - **Prompt**: 16:9 pixel-art students from Fellows Oval sharing turns at arcade machines and air hockey, one student admiring large wall art, friendly low-stakes competition, warm indoor glow, Joplin Lane doorway behind, no readable text, no UI.
  - `choice_b_miss`: `/ANU_TreasureMap/Godot_Game/anu-treasure-map/resources/event/event_fellows_oval_game_on_choice_b_miss.png`
    - **Show during**: Choice B outcome.
    - **Prompt**: 16:9 pixel-art student focused only on a high-score arcade screen while friends drift toward ping pong and wall art, gentle missed-social-clue mood, no readable numbers, no logos, no UI.
  - `choice_c_hint`: `/ANU_TreasureMap/Godot_Game/anu-treasure-map/resources/event/event_fellows_oval_game_on_choice_c_hint.png`
    - **Show during**: Choice C outcome.
    - **Prompt**: 16:9 pixel-art students outside a Joplin Lane arcade storefront saving opening hours and location on a phone, sports bag on the ground, arcade glow through the window, hopeful return-later mood, no readable text, no UI.

### Narrative

1. Fellows Oval에서 공을 차고 난 뒤, 한 학생이 신발 끈을 풀며 말한다. "오늘은 몸으로 뛰었으니까, 이제 손가락으로 뛰는 게임 어때?"
2. 누군가 Joplin Lane 쪽을 가리킨다. 창문 너머로 번개 모양의 빛과 어두운 arcade silhouette가 보인다.
3. 문 안쪽에는 pinball, arcade machines, air hockey, ping pong 같은 것들이 낮은 전기음처럼 서로 다른 리듬을 낸다.
4. 운동장에서 같은 팀이던 학생이 멋쩍게 웃는다. "근데 여기서도 이기려고만 하면 재미없겠지?"
5. Kambri at ANU 안내는 Game On을 Joplin Lane, Shop 156-B6의 free games arcade라고 소개한다.
6. ANU students, staff, and visitors가 무료로 들어와 게임하고, 쉬고, socialise할 수 있는 공간이라고 되어 있다.
7. 벽에는 ANU School of Art & Design 학생들의 large-scale artworks가 공간의 분위기를 더 밝게 만든다.
8. arcade cabinet의 불빛은 운동장의 scoreboard와 다르다. 여기서는 점수가 아니라 누구와 웃었는지가 더 오래 남는다.
9. 학생은 air hockey table과 wall art를 번갈아 보며 말한다. "이건 경기장이 아니라, 경기 후에 팀이 풀리는 장소네."
10. 당신은 아직 손에 땀이 남은 채 joystick 앞에 선다.
11. Game On이라는 말은 승부의 시작이 아니라, 하루의 긴장을 낮추는 신호처럼 들린다.

### Choices

#### A. "한 판씩 돌아가면서 하고, artwork도 같이 둘러보자."

- **Treasure found**: true
- **Outcome**
  1. 당신은 air hockey를 한 판 하고, 다음 사람에게 자리를 넘긴다.
  2. 누군가는 pinball을 하고, 누군가는 SOAD artwork 앞에서 좋아하는 색을 고른다.
  3. 운동장에서 이어진 팀의 박자는 경쟁보다 가벼운 웃음으로 바뀐다.
  4. 당신은 Game On을 발견했다. 오늘의 보물은 이기는 화면이 아니라, 같이 놀아도 된다는 캠퍼스의 허락이다.

#### B. "좋아, 최고 점수부터 깨고 올게."

- **Treasure found**: false
- **Re-trigger**: true
- **Outcome**
  1. 당신은 한 기계 앞에서 점수만 보고 집중한다.
  2. 친구들은 ping pong table과 artwork 쪽으로 흩어지고, 공간의 절반은 조용히 지나간다.
  3. 실력이 나쁜 것은 아니지만, 오늘의 Game On은 점수판보다 사람 사이에 숨어 있었다.

#### C. "오늘은 시간이 애매하니, Joplin Lane 위치와 opening hours를 저장하자."

- **Treasure found**: false
- **Re-trigger**: true
- **Boost trigger chance**: true
- **Outcome**
  1. 학생은 phone에 Joplin Lane과 Game On 위치를 저장한다.
  2. 그는 다음 운동 끝나고는 바로 여기서 팀을 풀자고 말한다.
  3. 아직 보물을 발견한 것은 아니지만, 다음번에는 경기 뒤의 웃음이 갈 곳을 알고 있다.

## Art & Music -- Cafe on 4th Floor

- **ID draft**: `art_and_music_cafe_on_4th_floor`
- **Location ID**: `art_and_music`
- **Treasure**: Cafe on 4th Floor
- **Evidence note**: The user-provided photo shows an upper-floor cafe/lounge environment in an ANU music-building context, with tables, windows, posters, beverage fridges, a milk bar cabinet, and students studying or talking. Official ANU School of Music visitor information says the School of Music Main Building houses a cafe on the 5th floor and has lift access to floors 4, 5, and 6. Because official material names the cafe as 5th-floor rather than 4th-floor, this draft treats "Cafe on 4th Floor" as the game treasure label/nickname from the supplied prompt while describing the setting as an upper-floor School of Music cafe without asserting the floor number as an official fact.

### Image Generation Manifest

- **Batch group**: `art_and_music_cafe_on_4th_floor`
- **Reference image**: user-provided cafe photo; use only as visual inspiration for an upper-level music-school cafe, long windows, concrete ceiling, exposed dark ducting, warm tube lights, posters, small round tables, milk bar cabinet, beverage fridge, and students with laptops.
- **Generation order**: generate all prompts in this event group independently; save final outputs to the listed paths before JSON integration.
- **Shared negative prompt**: no readable poster text, no real logos, no exact cafe reproduction, no identifiable real faces, no messy food waste, no alcohol focus, no photorealism, no UI overlay, no speech bubbles, no watermark.

### Image Assets

- **Treasure image path**: `/ANU_TreasureMap/Godot_Game/anu-treasure-map/resources/treasure/treasure_cafe_on_4th_floor.png`
- **Treasure image prompt**: 1:1 original pixel-art collectible of an upper-floor music-school cafe table with a coffee cup, small pastry, folded concert program, tiny treble-clef doodle, window light, and poster-covered wall shapes behind, warm study-break mood, centered object, no readable text, no logos.
- **Event image sequence**
  - `intro`: `/ANU_TreasureMap/Godot_Game/anu-treasure-map/resources/event/event_art_and_music_cafe_on_4th_floor_intro.png`
    - **Show during**: Narrative 1-4.
    - **Prompt**: 16:9 warm pixel-art upper-floor ANU music-school cafe inspired by the provided photo, long windows, concrete ceiling, dark duct, tube lights, small tables, poster wall, students with laptops, quiet creative break mood, no readable text, no UI.
  - `investigation`: `/ANU_TreasureMap/Godot_Game/anu-treasure-map/resources/event/event_art_and_music_cafe_on_4th_floor_investigation.png`
    - **Show during**: Narrative 5-11 and choice display.
    - **Prompt**: 16:9 pixel-art close view of a music-school cafe study table with coffee, notebook, concert calendar icons, lift/floor icon blocks, practice-room key shape, milk bar cabinet in background, students quietly planning a lunchtime concert, no readable text, no logos, no UI.
  - `choice_a_success`: `/ANU_TreasureMap/Godot_Game/anu-treasure-map/resources/event/event_art_and_music_cafe_on_4th_floor_choice_a_success.png`
    - **Show during**: Choice A outcome before treasure image.
    - **Prompt**: 16:9 pixel-art students sharing a cafe table after rehearsal, one quietly marking a concert calendar, another resting beside an instrument case, warm window light and poster wall, respectful music-school cafe atmosphere, no readable text, no UI.
  - `choice_b_miss`: `/ANU_TreasureMap/Godot_Game/anu-treasure-map/resources/event/event_art_and_music_cafe_on_4th_floor_choice_b_miss.png`
    - **Show during**: Choice B outcome.
    - **Prompt**: 16:9 pixel-art student rushing past a calm upper-floor cafe toward stairs while coffee steam and poster lights remain behind, gentle missed-break mood, no readable text, no UI.
  - `choice_c_hint`: `/ANU_TreasureMap/Godot_Game/anu-treasure-map/resources/event/event_art_and_music_cafe_on_4th_floor_choice_c_hint.png`
    - **Show during**: Choice C outcome.
    - **Prompt**: 16:9 pixel-art students near an upper-floor cafe window saving the School of Music cafe and concert calendar on a phone, notebook with music-note icons, instrument case beside table, hopeful return-later mood, no readable text, no UI.

### Narrative

1. Art & Music 건물 안쪽에서 계단을 오르자, 커피 냄새와 포스터의 색이 먼저 올라온다.
2. 긴 창가에는 노트북을 펴 둔 학생들이 앉아 있고, 천장의 tube lights는 악보의 긴 마디처럼 이어진다.
3. 누군가는 이곳을 4th floor cafe라고 부르지만, School of Music 안내는 main building의 cafe와 upper floors access를 함께 알려 준다.
4. 악기 케이스를 든 학생이 테이블 사이에서 멈춰 선다. "연습실과 공연장 사이에 숨 쉴 곳을 찾고 있었어."
5. School of Music 자료는 main building이 Llewellyn Hall, Larry Sitsky Recital Room, recording studio, teaching studios, practice rooms, 그리고 cafe를 품고 있다고 설명한다.
6. 또 lift access가 floors 4, 5, and 6까지 이어진다고 되어 있다.
7. 벽의 포스터들은 이 공간이 rehearsal, lecture, performance 사이를 오가는 학생들의 중간 기착지임을 보여 준다.
8. 학생은 포스터와 창밖을 번갈아 본다. "여긴 밥 먹는 곳이라기보다, rehearsal과 performance 사이의 쉼표 같아."
9. 주변 테이블에서는 누군가 악보를 접고, 누군가는 다음 concert 시간을 조용히 캘린더에 옮긴다.
10. 카페는 큰 무대가 아니지만, 무대로 가기 전 마음을 조율하는 작은 대기실처럼 느껴진다.
11. 당신은 빈 테이블 하나와 벽의 event poster, 그리고 막 식어 가는 커피 향 사이에서 선택해야 한다.

### Choices

#### A. "조용히 앉아서 concert calendar를 확인하고, 같이 쉬어 가자."

- **Treasure found**: true
- **Outcome**
  1. 당신은 학생과 창가 테이블에 앉아 다음 lunchtime concert와 practice break 시간을 맞춰 본다.
  2. 악기 케이스는 의자 옆에 놓이고, 커피 한 모금 사이로 긴장이 조금 풀린다.
  3. 학생은 "무대 밖에도 음악이 이어지는 곳이 있었네"라고 말한다.
  4. 당신은 Cafe on 4th Floor를 발견했다. 오늘의 보물은 커피가 아니라, 연습과 공연 사이에 숨을 고르는 자리다.

#### B. "카페니까 크게 떠들어도 괜찮겠지."

- **Treasure found**: false
- **Re-trigger**: true
- **Outcome**
  1. 당신이 목소리를 높이려 하자, 옆 테이블의 학생이 악보 위에 손을 얹고 잠깐 고개를 든다.
  2. 이곳은 쉬는 공간이지만, 동시에 누군가의 rehearsal 전 집중이 머무는 곳이다.
  3. 오늘의 카페는 놓쳤지만, 다음번에는 이 조용한 박자를 먼저 들으면 된다.

#### C. "오늘은 위치와 concert dates만 저장하고, 리허설 끝나고 오자."

- **Treasure found**: false
- **Re-trigger**: true
- **Boost trigger chance**: true
- **Outcome**
  1. 학생은 School of Music cafe와 concerts calendar를 phone에 저장한다.
  2. 그는 rehearsal이 끝난 뒤 여기서 다시 만나자고 말한다.
  3. 아직 보물을 발견한 것은 아니지만, 다음번에는 숨을 고를 테이블을 알고 있다.

## Copland -- Event Notice Board

- **ID draft**: `copland_event_notice_board`
- **Location ID**: `copland`
- **Treasure**: Event Notice Board
- **Evidence note**: ANU Maps identifies Copland Building at 24 Kingsley Place and lists teaching, research, accessibility, and room locations inside the building. ANU's Poster Policy says posters and notices should be displayed in appropriate designated locations, with internal noticeboards available for approved poster placement; it frames noticeboards as supporting communication and engagement within the ANU community. The Functions on Campus page says functions include staff, student, or external organised social, cultural, fundraising, or sporting events, and that the process also covers placement of posters and promotional material around campus. The user-provided photo shows crowded Copland noticeboards; this draft treats the board as a campus-information encounter and does not endorse or reproduce any specific poster content.

### Image Generation Manifest

- **Batch group**: `copland_event_notice_board`
- **Reference image**: user-provided notice board photo; use only as visual inspiration for dense layered posters on brown boards against brick walls, torn paper corners, QR-like blocks without readable codes, event colors, and campus corridor texture.
- **Generation order**: generate all prompts in this event group independently; save final outputs to the listed paths before JSON integration.
- **Shared negative prompt**: no readable political slogans, no real QR codes, no real people names, no logos, no hateful or explicit content, no tearing down posters, no vandalism emphasis, no photorealism, no UI overlay, no speech bubbles, no watermark.

### Image Assets

- **Treasure image path**: `/ANU_TreasureMap/Godot_Game/anu-treasure-map/resources/treasure/treasure_event_notice_board.png`
- **Treasure image prompt**: 1:1 original pixel-art collectible of a campus event notice board with colorful layered flyers, small calendar pins, tape corners, and non-readable QR-like squares, brick wall background, lively student-community mood, centered board silhouette, no readable text, no logos.
- **Event image sequence**
  - `intro`: `/ANU_TreasureMap/Godot_Game/anu-treasure-map/resources/event/event_copland_event_notice_board_intro.png`
    - **Show during**: Narrative 1-4.
    - **Prompt**: 16:9 warm pixel-art Copland corridor exterior with brick wall and crowded brown notice boards full of colorful non-readable posters, two students stopping in front of the board, afternoon campus light, lively but organized information mood, no readable text, no UI.
  - `investigation`: `/ANU_TreasureMap/Godot_Game/anu-treasure-map/resources/event/event_copland_event_notice_board_investigation.png`
    - **Show during**: Narrative 5-12 and choice display.
    - **Prompt**: 16:9 pixel-art close study of a campus notice board: layered flyers, tape, calendar icons, room-number icon blocks, category marks for talks, clubs, music, volunteering, support, student elections, student notebook sorting dates and locations, no readable text, no real QR codes, no UI.
  - `choice_a_success`: `/ANU_TreasureMap/Godot_Game/anu-treasure-map/resources/event/event_copland_event_notice_board_choice_a_success.png`
    - **Show during**: Choice A outcome before treasure image.
    - **Prompt**: 16:9 pixel-art students respectfully reading a crowded Copland notice board, pointing to date and location icons without touching posters, one saving a verified event to a phone calendar, bright campus-community feeling, no readable text, no UI.
  - `choice_b_miss`: `/ANU_TreasureMap/Godot_Game/anu-treasure-map/resources/event/event_copland_event_notice_board_choice_b_miss.png`
    - **Show during**: Choice B outcome.
    - **Prompt**: 16:9 pixel-art student overwhelmed by too many colorful flyers and walking away from Copland notice boards, posters still layered behind, gentle missed-opportunity mood, no readable text, no UI.
  - `choice_c_hint`: `/ANU_TreasureMap/Godot_Game/anu-treasure-map/resources/event/event_copland_event_notice_board_choice_c_hint.png`
    - **Show during**: Choice C outcome.
    - **Prompt**: 16:9 pixel-art students photographing a crowded notice board from a respectful distance and making a phone reminder to check event details later, brick wall, colorful flyer blocks, hopeful planning mood, no readable text, no real QR codes, no UI.

### Narrative

1. Copland 앞 벽에는 notice board가 거의 종이의 지층처럼 쌓여 있다.
2. lecture, club, music, support, election, market, protest, workshop 같은 색들이 서로 겹쳐 작은 도시를 만든다.
3. 한 학생이 게시판 앞에서 멈춰 선다. "여기서 오늘 갈 만한 걸 찾으려면, 먼저 길을 잃어야 하는 것 같아."
4. 그는 친구와 함께 갈 event를 찾고 있지만, 너무 많은 flyer 때문에 날짜와 장소를 놓치고 있었다.
5. ANU Maps는 Copland Building을 24 Kingsley Place에 있는 캠퍼스 건물로 안내한다.
6. ANU Poster Policy는 posters and notices가 designated noticeboards 같은 appropriate locations에 붙어야 하며, noticeboards가 ANU community의 communication and engagement를 돕는다고 설명한다.
7. Functions on Campus 안내는 staff, student, external organised social, cultural, fundraising, sporting events와 promotional material placement까지 다룬다.
8. 게시판은 단순히 종이가 붙은 벽이 아니라, 캠퍼스가 자기 목소리를 서로에게 건네는 오래된 인터페이스다.
9. 학생은 말한다. "그럼 아무거나 고르는 게 아니라, 날짜, 장소, 주최, 내가 갈 수 있는 이유를 읽어야겠네."
10. 찢긴 모서리와 새 포스터 사이에서, 어떤 정보는 지나갔고 어떤 정보는 오늘 밤까지 살아 있다.
11. 당신은 손을 대지 않고 눈으로 board를 정리한다.
12. Copland의 벽은 조용하지만, 오늘의 캠퍼스가 무슨 말을 하고 싶은지는 꽤 시끄럽게 적혀 있다.

### Choices

#### A. "포스터를 건드리지 말고, 날짜와 장소가 분명한 event를 같이 골라 보자."

- **Treasure found**: true
- **Outcome**
  1. 당신은 학생과 함께 flyer들을 club, talk, performance, support, volunteering으로 나누어 읽는다.
  2. 날짜와 장소가 분명한 event 하나를 골라 phone calendar에 저장하고, 친구에게 같이 가자고 보낸다.
  3. 학생은 "게시판이 그냥 소음이 아니라, 캠퍼스의 초대장이었네"라고 말한다.
  4. 당신은 Event Notice Board를 발견했다. 오늘의 보물은 종이 더미가 아니라, 낯선 하루에 들어갈 작은 문을 찾는 능력이다.

#### B. "너무 많다. 제일 눈에 띄는 것 하나만 보고 가자."

- **Treasure found**: false
- **Re-trigger**: true
- **Outcome**
  1. 당신은 가장 큰 색만 보고 돌아서지만, 날짜와 장소를 확인하지 못했다.
  2. 뒤돌아보니 학생은 아직 board 앞에서 주최와 시간을 맞춰 보고 있다.
  3. 눈에 띄는 것은 시작일 뿐이다. 오늘의 보물은 정보를 끝까지 읽는 사람에게 남아 있었다.

#### C. "오늘은 board를 사진으로 남기고, 나중에 event details를 확인하자."

- **Treasure found**: false
- **Re-trigger**: true
- **Boost trigger chance**: true
- **Outcome**
  1. 학생은 poster를 건드리지 않고 board 전체를 사진으로 남긴다.
  2. 그는 나중에 공식 event page나 organizer 정보를 확인한 뒤 고르겠다고 말한다.
  3. 아직 보물을 발견한 것은 아니지만, Copland notice board가 다음 약속의 출발점이 될 수 있다는 것을 알게 되었다.

## Source Notes

- Yukeembruk residence page: half basketball court and student accommodation context.
- ANU free food guide: ANUSA free breakfasts at BKSS, food vouchers, Student Bites with OzHarvest pickups on Friday afternoons at BKSS, residence food recovery to BKSS, Community Connect Food Relief, planning ahead, reusable containers, and staying connected with ANUSA updates.
- Bruce Hall Main Wing page: roof-top garden and Bruce Hall community context.
- ANU Board Games Society and ANU student bulletin: Friday game nights and board game community context.
- ANU School of Computing Escape Room article: 60-minute educational escape room with five computing puzzles in the CSIT building.
- ANU Sport Sport page: high-level athlete and casual player pathways, year-round opportunities, online sign-up, UniSport Nationals, Social Sport, Interhall Sport, and sport for ANU students plus the general public.
- Chifley Library page: SS&H collections, study spaces, group study rooms, The Deck, lockers, and library facilities.
- ANU map Subway entry: Subway location at 20 Union Court.
- ANU School of Medicine and Psychology Laboratory Health and Safety page: anatomy facility access is authorised and human remains must be treated with dignity and respect.
- ANU Anatomy and Physiology 1 course page: practical sessions include histology, prosected human cadaveric specimens, and models of the human body, with ethical and respectful behaviour expectations.
- ANU Aboriginal and Torres Strait Islander Heritage Trail page: Acton campus historical significance, continuing culture and connection to Country, Representative Aboriginal Organisations partnership, Sullivans Creek navigation, and Aboriginal land management through periodic burning near today's South Oval.
- ANU First Aboriginal Resource Garden article: campus cultural garden context, caring for Country as learning and growth, and encouragement to use the ANU Walks Aboriginal & Torres Strait Islander Heritage Trail.
- ACT Heritage/legislation heritage statement for Canberra's pre-cast concrete bus shelters: architectural, historical, cultural and community significance, Clement Cummings design, NCDC selection in 1975, relocatable modular construction, and Canberra identity.
- Transport Canberra bus guidance: find the stop ID, check timetables, arrive ahead of time, check the bus number, and signal the driver safely by raising an arm.
- ACT City Services solar lighting project page: Canberra's concrete shelters are treated as iconic concrete shelters whose design affects interior lighting and user experience.
- ANU Sculpture Walk brochure: Chantale Delrue's `Involution/evolution` is a 2002 unglazed ceramic tile mosaic commissioned in 2002 on the grounds of the Centre for European Studies; the brochure describes its blue coil, native ochre circle, meeting-area focal point, and themes of continuity, energy, and change.
- ANU Sculpture Walk brochure: Angela Dufty's `Six fixed` is a 2004 painted steel sculpture commissioned in 2003 for the Chemistry Building grounds on Science Road; the brochure describes Dufty as an ANU School of Art graduate and connects the work to architectural geometry, drawings in space, regular intervals, right angles, and playful light-and-shadow optical effects.
- ANU Sculpture Walk brochure: Fiona Foley's `Winged harvest` is a 2001 work in wood, aluminium, ochre, and stainless steel, commissioned in 2000 for the WEH Stanner Building courtyard; the brochure links the work to materials and imagery meaningful for the Indigenous inhabitants of the ACT, Bogong moth collection, ceremony or ochre pit sites around Canberra, seven wooden poles, traditional pigments, notching recalling climbing techniques, and surrounding plantings as part of the installation.
- ANU College of Asia & the Pacific Lunar New Year dragon article: Chinese dragon context, Chinese lunisolar calendar, Year of the Wood Dragon, dragon as the only mythical zodiac creature, water/cloud/rain-making associations, prosperity, auspiciousness, and change.
- ANU Orientation Lunar New Year Celebration page: ANUSA event at the Kambri Amphitheatre with traditional dragon dance and student performances.
- Australian Centre on China in the World About page: CIW is ANU's university-wide focal point for Chinese studies, research, education, and public outreach on China and the Chinese world.
- Kambri at ANU Game On page: free games arcade in Joplin Lane, Shop 156-B6, with pinball, arcade machines, air hockey, ping pong, free access for ANU students, staff, and visitors, and large-scale artworks by ANU School of Art & Design students.
- ANU self-guided campus tour: Joplin Lane businesses and services include Game On as a free games arcade.
- ANU School of Music facilities and visitor information: the main building includes performance venues, recording and teaching spaces, practice rooms, a cafe on the 5th floor, and lift access to floors 4, 5, and 6.
- ANU Maps Copland Building entry: Copland Building is located at 24 Kingsley Place and contains listed rooms, centres, accessibility information, and facilities.
- ANU Poster Policy: posters and notices should be placed in designated noticeboards and appropriate locations, supporting communication and engagement within the ANU community.
- ANU Functions on Campus page: campus functions include organised social, cultural, fundraising, and sporting events, and the process includes poster and promotional material placement around campus.
