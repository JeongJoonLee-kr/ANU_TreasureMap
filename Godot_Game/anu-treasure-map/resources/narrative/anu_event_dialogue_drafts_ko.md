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
- **Generation owner**: Codex generates these event and treasure images before the events are integrated into the playable build.

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

## Wamburun Halls & Ursula Hall -- Duck Drive Slow Sign

- **ID draft**: `wamburun_ursula_duck_drive_slow_sign`
- **Location ID**: `wamburun_halls_ursula_hall`
- **Treasure**: Duck Drive Slow Sign
- **Evidence note**: 사용자 제공 사진의 호주식 duck / drive slow warning sign을 기반으로 한다. 이 초안은 유학생이 캠퍼스에서 처음 보는 귀여운 오리 표지판에 호기심을 느끼고, Wamburun Halls와 Ursula Hall 주변 길이 사람뿐 아니라 작은 야생동물도 함께 쓰는 공간임을 알아가는 장면에 초점을 둔다.

### Image Assets

- **Treasure image path**: `/ANU_TreasureMap/Godot_Game/anu-treasure-map/resources/treasure/treasure_duck_drive_slow_sign.png`
- **Treasure image prompt**: 1:1 pixel-art collectible image of an Australian yellow diamond duck drive slow warning sign, a black duck with three ducklings icon on a bright yellow sign, simplified and cute like a game item, centered on a small grey pole with a few eucalyptus leaves behind it, clean readable silhouette, no text, no watermark.
- **Event image sequence**
  - `intro`: `/ANU_TreasureMap/Godot_Game/anu-treasure-map/resources/event/event_wamburun_ursula_duck_drive_slow_sign_intro.png`
    - **Show during**: Narrative 1-4.
    - **Prompt**: 16:9 warm pixel-art campus path near Wamburun Halls and Ursula Hall, an international student pausing with curious expression at a cute bright yellow Australian duck drive slow warning sign on a pole beside eucalyptus trees and shrubs, upper pedestrian sign present but secondary, afternoon light, quiet residential campus mood, no UI, no readable text.
  - `investigation`: `/ANU_TreasureMap/Godot_Game/anu-treasure-map/resources/event/event_wamburun_ursula_duck_drive_slow_sign_investigation.png`
    - **Show during**: Narrative 5-10 and choice display.
    - **Prompt**: 16:9 pixel-art close view of a cute Australian yellow diamond duck drive slow warning sign near campus shrubs, international student looking puzzled and delighted while checking the path where walkers, bikes, and scooters pass, eucalyptus shadows across the sign, curious field-note mood, no UI, no readable text.
  - `choice_a_success`: `/ANU_TreasureMap/Godot_Game/anu-treasure-map/resources/event/event_wamburun_ursula_duck_drive_slow_sign_choice_a_success.png`
    - **Show during**: Choice A outcome before treasure image.
    - **Prompt**: 16:9 gentle pixel-art campus path where students pause and a cyclist or scooter rider slows down while a small duck family crosses near the yellow duck drive slow sign, Wamburun and Ursula residential greenery, warm safe respectful mood, no UI, no readable text.
  - `choice_b_miss`: `/ANU_TreasureMap/Godot_Game/anu-treasure-map/resources/event/event_wamburun_ursula_duck_drive_slow_sign_choice_b_miss.png`
    - **Show during**: Choice B outcome.
    - **Prompt**: 16:9 pixel-art view of an international student walking past the cute yellow duck drive slow sign after only treating it as a funny campus detail, the sign left behind among eucalyptus trees and shrubs, ordinary path feeling slightly missed, soft wistful campus mood, no UI, no readable text.
  - `choice_c_hint`: `/ANU_TreasureMap/Godot_Game/anu-treasure-map/resources/event/event_wamburun_ursula_duck_drive_slow_sign_choice_c_hint.png`
    - **Show during**: Choice C outcome.
    - **Prompt**: 16:9 pixel-art international student marking the duck drive slow sign location on a phone or notebook, still curious about this unfamiliar Australian campus sign, yellow sign beside shrubs, bike and scooter path nearby, quiet next-time clue mood, Wamburun and Ursula campus greenery, no UI, no readable text.

### Narrative

1. Wamburun Halls와 Ursula Hall 사이의 나무 그늘길에서, 한 유학생이 노란 표지판 앞에 멈춰 선다.
2. 위쪽 표지보다 먼저 눈에 들어온 것은 아래쪽 다이아몬드 표지다. 오리 한 마리와 작은 새끼들이 줄지어 걷고 있다.
3. 학생은 조금 웃으며 말한다. "이거 뭐야? 캠퍼스에 오리 가족 표지판이 있어?"
4. 고향에서는 이런 표지판을 본 적이 없어서, 처음에는 기숙사 쪽 작은 농담이나 마스코트처럼 보인다.
5. 하지만 표지판은 생각보다 진지한 노란색이고, 뒤쪽에는 유칼립투스 잎과 낮은 덤불이 빽빽하게 이어진다.
6. 길 위로는 보행자와 자전거, 스쿠터가 가끔 지나가고, 표지판 아래의 오리 가족은 그 사이를 조용히 바라보는 것 같다.
7. 학생은 표지판을 다시 보며 묻는다. "혹시 진짜 오리가 지나가니까 천천히 가라는 뜻이야?"
8. 그때 덤불 쪽에서 잎이 아주 작게 흔들린다.
9. 실제 오리인지, 바람인지, 아니면 표지판을 보고 나서야 들리는 캠퍼스의 작은 소리인지는 아직 모른다.
10. 다만 조금 전까지 낯선 농담처럼 보였던 그림이, 이제는 이 길을 함께 쓰는 작은 주민들의 안내처럼 느껴진다.

### Choices

#### A. "잠깐 멈춰서, 이 오리 표지판이 뭘 말하는지 확인해 보자."

- **Treasure found**: true
- **Outcome**
  1. 당신과 학생은 길 가장자리에서 잠시 멈추고, 지나가는 자전거와 스쿠터가 천천히 지나갈 수 있도록 자연스럽게 공간을 비워 둔다.
  2. 덤불 사이에서 작은 오리 가족이 천천히 모습을 드러내고, 노란 표지판 아래를 지나 반대편 그늘로 향한다.
  3. 학생은 표지판을 다시 본다. "아, 귀여워서 있는 게 아니라 진짜 필요한 표지였구나."
  4. 당신은 Duck Drive Slow Sign을 발견했다. 오늘의 보물은 낯선 그림을 그냥 지나치지 않고, 그 그림이 지키는 작은 속도를 배운 순간이다.

#### B. "귀엽다. 사진만 찍고 계속 가자."

- **Treasure found**: false
- **Re-trigger**: true
- **Outcome**
  1. 학생은 표지판을 사진으로 남기고 웃으며 길을 계속 걷는다.
  2. 뒤쪽 덤불에서 작은 소리가 나지만, 이미 너무 멀어져 확인할 수 없다.
  3. 표지판은 귀여운 캠퍼스 디테일로 남는다. 아직 그 귀여움이 왜 필요한지는 알지 못한 채로.

#### C. "위치를 표시해 두고, 이 표지판이 무슨 뜻인지 더 알아보자."

- **Treasure found**: false
- **Re-trigger**: true
- **Boost trigger chance**: true
- **Outcome**
  1. 학생은 표지판 위치를 메모하고, "호주에는 이런 동물 표지가 많나?"라고 적어 둔다.
  2. 오리 그림, 주변 나무, 덤불의 위치까지 함께 기록하자 길이 조금 덜 낯설게 보인다.
  3. 아직 보물을 찾은 것은 아니지만, 다음번에는 이 노란 표지가 단순한 귀여운 그림처럼 지나가지는 않을 것이다.

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
- **Evidence note**: This is a fictionalised night-campus event draft for the Medical & Physics School location. The anatomical model should be treated as an educational plastic teaching model in the story, not as a verified public exhibit unless the team later confirms the real object.

### Image Assets

- **Treasure image path**: `/ANU_TreasureMap/Godot_Game/anu-treasure-map/resources/treasure/treasure_anatomical_model.png`
- **Treasure image prompt**: 1:1 pixel-art collectible image of a plastic anatomical teaching torso model on a small rolling stand, simplified colored organ panels, a folded anatomy note card, warm desk lamp glow, cool moonlit window behind, educational and slightly mysterious mood, centered object, no gore, no horror, no readable text, matching the square treasure art style.
- **Event image sequence**
  - `intro`: `/ANU_TreasureMap/Godot_Game/anu-treasure-map/resources/event/event_medical_physics_school_anatomical_model_intro.png`
    - **Show during**: Narrative 1-4.
    - **Prompt**: 16:9 night-time pixel-art exterior of the Medical & Physics School, cool blue campus path, one warm lit window, the soft silhouette of a plastic anatomical model visible through half-closed blinds, empty benches and trees, quiet first-person campus mystery, eerie but safe, no gore, no UI, no speech bubbles.
  - `investigation`: `/ANU_TreasureMap/Godot_Game/anu-treasure-map/resources/event/event_medical_physics_school_anatomical_model_investigation.png`
    - **Show during**: Narrative 5-11 and choice display.
    - **Prompt**: 16:9 pixel-art close view through a corridor window or display-room doorway at night, plastic anatomical teaching model standing under a flickering fluorescent light, anatomy posters as abstract shapes, reflection of campus trees in glass, student holding a phone flashlight low, tense but respectful educational mood, no gore, no readable text, no UI.
  - `choice_a_success`: `/ANU_TreasureMap/Godot_Game/anu-treasure-map/resources/event/event_medical_physics_school_anatomical_model_choice_a_success.png`
    - **Show during**: Choice A outcome before treasure image.
    - **Prompt**: 16:9 pixel-art scene where two students switch on a warmer study light and calmly identify the plastic anatomical teaching model, the scary silhouette now clearly educational, notes and model stand visible, relief and curiosity replacing fear, moonlit corridor outside, no gore, no UI.
  - `choice_b_miss`: `/ANU_TreasureMap/Godot_Game/anu-treasure-map/resources/event/event_medical_physics_school_anatomical_model_choice_b_miss.png`
    - **Show during**: Choice B outcome.
    - **Prompt**: 16:9 pixel-art night campus path outside Medical & Physics School as the player walks away quickly, the lit window and anatomical model silhouette still small in the background, cool blue shadows, uneasy missed-mystery mood, safe campus atmosphere, no gore, no UI.
  - `choice_c_hint`: `/ANU_TreasureMap/Godot_Game/anu-treasure-map/resources/event/event_medical_physics_school_anatomical_model_choice_c_hint.png`
    - **Show during**: Choice C outcome.
    - **Prompt**: 16:9 pixel-art student making a respectful note on a phone outside a night-lit Medical & Physics School window, anatomical model silhouette softened by blinds, small campus safety light and trees nearby, promise-to-check-in-daylight mood, eerie but gentle, no readable text, no UI.

### Narrative

1. 밤이 내려앉은 Medical & Physics School 앞을 지나가는데, 건물 안쪽 창문 하나만 아직 노랗게 켜져 있다.
2. 반쯤 내려간 블라인드 사이로 사람처럼 보이는 형체가 조용히 서 있다.
3. 처음에는 늦게 남은 학생인가 싶었지만, 그 형체는 너무 똑바로 서 있고 너무 움직이지 않는다.
4. 바람이 나뭇잎을 흔들자 창문에 비친 그림자가 잠깐 살아 움직인 것처럼 겹쳐진다.
5. 옆길에서 같은 창문을 보던 학생이 낮게 말한다. "저거 볼 때마다 심장이 한 번씩 내려앉아. 낮에는 분명 수업용 모형일 텐데."
6. 가까이 다가가 보니 창문 안쪽에는 플라스틱 anatomical model이 서 있고, 그 옆에는 닫힌 노트와 작은 스탠드 조명이 놓여 있다.
7. 유리에는 바깥 나무 그림자와 안쪽 형체가 겹쳐 보여, 모형의 어깨가 실제 사람처럼 보였다가 다시 교육용 도구처럼 돌아온다.
8. 학생은 웃으려다 실패한다. "해부학은 몸을 이해하는 공부인데, 밤에는 몸이 모르는 언어처럼 보여."
9. 복도 불빛이 한 번 깜빡이고, 모형의 반쪽 얼굴이 노란빛과 파란빛 사이에서 나뉜다.
10. 무서운 것은 모형 자체가 아니라, 낮의 지식이 밤의 그림자 속에서 다른 얼굴을 갖는 순간인지도 모른다.
11. 당신은 창문 앞에서 한 걸음 더 읽을 수도 있고, 그대로 지나칠 수도 있다.

### Choices

#### A. "가까이서 확인하자. 무서운 게 아니라 무엇인지 알아보자."

- **Treasure found**: true
- **Outcome**
  1. 당신은 학생과 함께 창문 가까이 다가가 조명과 그림자의 위치를 차분히 확인한다.
  2. 사람처럼 보였던 어깨는 플라스틱 torso의 단단한 곡선이고, 이상한 표정은 블라인드 그림자가 만든 선이었다.
  3. 학생은 길게 숨을 내쉬며 말한다. "낮에 배우는 것도 밤에는 다시 배워야 하네."
  4. 당신은 Anatomical Model을 발견했다. 오늘의 보물은 무서움을 지우는 것이 아니라, 모르는 형체에 이름을 붙이는 용기다.

#### B. "아니, 저건 그냥 못 본 걸로 하자."

- **Treasure found**: false
- **Re-trigger**: true
- **Outcome**
  1. 당신은 발걸음을 빠르게 하고, 학생도 잠시 뒤를 보다가 따라온다.
  2. 창문은 금방 멀어지지만, 움직이지 않는 형체는 머릿속에서 오히려 더 커진다.
  3. 도망친 것이 틀린 선택은 아니다. 다만 밤의 그림자는 확인하지 않으면 계속 자기 이야기를 덧붙인다.

#### C. "오늘은 밖에서 위치만 기억하자. 낮에 다시 확인하면 덜 무서울 거야."

- **Treasure found**: false
- **Re-trigger**: true
- **Boost trigger chance**: true
- **Outcome**
  1. 당신은 창문 안을 촬영하지 않고, 건물 바깥 위치와 불빛이 보였던 방향만 메모한다.
  2. 학생은 다음 날 밝을 때 같은 장소를 확인해 보겠다고 말한다.
  3. 아직 보물을 발견한 것은 아니지만, 밤의 불안은 낮의 질문으로 바뀌었다.

## Source Notes

- Yukeembruk residence page: half basketball court and student accommodation context.
- ANU free food guide: ANUSA free breakfasts at BKSS, food vouchers, Student Bites with OzHarvest pickups on Friday afternoons at BKSS, residence food recovery to BKSS, Community Connect Food Relief, planning ahead, reusable containers, and staying connected with ANUSA updates.
- Bruce Hall Main Wing page: roof-top garden and Bruce Hall community context.
- ANU Board Games Society and ANU student bulletin: Friday game nights and board game community context.
- ANU School of Computing Escape Room article: 60-minute educational escape room with five computing puzzles in the CSIT building.
- ANU Sport Sport page: high-level athlete and casual player pathways, year-round opportunities, online sign-up, UniSport Nationals, Social Sport, Interhall Sport, and sport for ANU students plus the general public.
- Chifley Library page: SS&H collections, study spaces, group study rooms, The Deck, lockers, and library facilities.
- ANU map Subway entry: Subway location at 20 Union Court.
- Medical & Physics School anatomical model draft: fictionalised night-campus story seed; confirm any real model or display before treating it as factual campus evidence.
