# ANU Treasure Map Final Game Design Document

Document status: English version 
Reference date: 2026-05-07 AEST  
Purpose: This document defines the intended final form of ANU Treasure Map so that the next development and content team can extend the current Week 1 prototype into a coherent full game.

## 1. One-Line Definition

ANU Treasure Map is a single-player narrative exploration game where the player spends a 14-week ANU semester discovering friends, memories, places, and treasures, then receives a personalised recap of the campus story shaped by their choices.

## 2. Director's Vision

The goal of this game is not to force the player to collect every treasure. The goal is to let the player decide where to go, who to spend time with, and which moments to keep, while managing limited time, energy, and money.

At the beginning, the ANU campus feels like an unfamiliar map. By the end of 14 weeks, that same map has become a collection of places the player has touched: a court they played on, a bench where they spoke with someone, an animal they happened to see, an event they missed but remembered, and hints they left for future players. The final output is not a win or loss screen. It is a personalised memory of what kind of semester the player lived at ANU.

The intended emotional takeaways are:

- ANU campus feels more familiar.
- The player feels they made their own university life.
- There is a sense of discovering hidden places.
- There is warmth from connection with friends.
- The player feels another playthrough could open a different path.

## 3. Player Identity

The player is an ANU student. The primary audience is new ANU students, but the game should also make sense to current students, exchange students, prospective students, and people interested in ANU.

For new students, the game acts as a guide that makes an unfamiliar campus feel approachable. For current students, it reveals stories and meanings hidden inside places they may already pass every day. For people interested in ANU, it offers a way to imagine what kind of life and relationships can happen inside the campus.

## 4. Final Game Objective

The player explores ANU over 14 weeks, experiencing locations, friends, events, and treasures. In this design, 14 weeks represents one compressed ANU semester from the start of semester to the end of semester, including the teaching break around Weeks 7-8. At the end of the game, the system recaps where the player went, which choices they made, which treasures they collected or shared, and which friends they connected with.

Completing the collection book is a secondary goal. The final objective is not to collect every treasure. The final objective is to complete a distinct campus story through the player's choices.

## 5. Design Pillars

### 5.1 The Campus Is Both Map and Memory

Locations are not just movement nodes. Each place is a story unit that can hold student life, history, nature, facilities, people, rumours, events, and seasonal experiences.

### 5.2 Treasure Is Meaning, Not Just Object

A treasure does not have to be a physical object. It can be a place, an experience, a student culture moment, a historical trace, a natural phenomenon, an encounter with a friend, a club activity, or a story left by a player.

### 5.3 Choices Must Return in the Recap

Player choices must matter beyond immediate rewards. Collecting, sharing, missing, helping, detouring, and revisiting should all gain meaning again in the ending recap.

### 5.4 The Player Should Not See Everything in One Run

The game should be designed so that the player cannot see every treasure within 14 weeks. This makes each semester feel different and gives the player a reason to replay. An incomplete collection book is not a failure. It is the empty space that shows what kind of semester the player chose to live.

### 5.5 Sharing Is Not a Loss, It Is a Legacy

When the player shares a treasure, it does not enter their collection book in the current playthrough. Instead, it becomes a hint for other players. This choice should be framed in the ending as an altruistic legacy.

## 6. Current Implementation Baseline

The current Godot project is closer to a Week 1 vertical slice than to a full game. The next team should treat the current build as the implementation baseline, and treat this document as the target design for expansion.

Current verified implementation baseline:

- The game is implemented as a Godot project.
- The current implementation uses a maximum week value of 16. The final design should change this to 14 weeks.
- The current primary resource is time. Money exists in state and HUD.
- Current `Global.time` starts at 8, and movement costs 1 time per graph edge.
- Current `Global.money` starts at 50.
- A `stamina` value exists, but the final energy system is not yet complete.
- The current location data includes 19 location ids.
- The current event data includes 22 event records, with 20 enabled.
- Current events use location, time-of-day conditions, clue ownership, random trigger chance, choice outcome, treasure found, and re-trigger rules.
- A treasure popup UI exists with `Collect` and `Share` choices.
- Shared treasures are currently stored in local save data as `shared_treasure_records` and rebuilt into the in-game social media feed.
- External asynchronous sharing through Supabase is a final design target. The current local implementation is a prototype of that concept.

### 6.1 Confirmed Design Decisions

| Item | Decision |
| --- | --- |
| Final objective | The player completes a personalised campus story through 14 weeks of choices, rather than collecting every treasure. |
| Semester structure | The 14 weeks represent one compressed semester from start to finish, including the Weeks 7-8 teaching break. |
| Share state | The player experiences the treasure content and event, but the treasure does not enter the current playthrough collection book. |
| Collection limitation | The player should not be able to see every treasure in one playthrough. |
| Final time model | The current implementation uses 8 AP, but the final game represents one week as a free-time day from 08:00 to 24:00. |
| Time unit | The final game uses 1-hour time units. |
| Week transition | At 24:00, the player naturally returns home or to residence and proceeds to the next week. |
| Time-based content | Events and accessible areas can vary by morning, midday, afternoon, evening, late night, or anytime conditions. Access restrictions start at the location level. |
| Energy range | Final energy is managed as a small 0-10 value. |
| Money structure | Money is a weekly budget that resets each week. |
| Map expansion direction | Keep the current single-node graph for now. The next team can move to a region/location/sub-node hierarchy if event expansion requires it. |
| 24:00 transition | At 24:00, the game moves naturally to the next week preparation screen without a separate weekly recap. |
| Ending format | The next team may choose any suitable format, but it must use the Memory Ledger to recap the player's locations, friends, treasures, choices, and legacy. |
| Friend system | The baseline idea is hints and movement benefits. The next team can expand this into dialogue changes, ending changes, personal stories, or relationship changes. |
| Shared post authoring | MVP should use a Dark Souls/Elden Ring style keyword template. Free player text can be considered later if filtering is strong enough. |
| Moderation MVP | User-generated hints should start with banned word or keyword filtering. |
| Event state recording | Record `Seen` when the event appears on screen, and `Experienced` when the player chooses an option and reads the result. |
| Share state recording | If the player finds a treasure and shares it, record both `Found` and `Shared`, then mark it `Locked Out` for the current playthrough. |
| Personal progress storage | Personal progress such as event seen, experienced, shared, and locked states is stored in the personal save file. |
| Shared hint storage | Shared posts and hints that other players can see are stored on Supabase. |
| Ending recap data | The ending recap reads the player's choice history from the Memory Ledger in the personal save file. |

## 7. Final Game Flow

### 7.1 Full Flow

1. The player completes onboarding and sets name, major, and basic profile.
2. The player's major or starting choice gives an initial trait.
3. At the start of each week, the player chooses up to two friends to explore with.
4. Friends provide traits and clue sources.
5. The player chooses locations on the ANU map.
6. Movement and exploration consume time and energy.
7. Event choices can be locked or unlocked based on time, energy, money, traits, and selected friends.
8. Event outcomes can produce treasure discovery, clue gain, new friends, resource changes, missed memories, or revisit opportunities.
9. When a treasure is found, the player chooses whether to collect or share it.
10. At the end of 14 weeks, the game shows the Memory Recap and developer credits.

### 7.2 Core Loop

Start week -> choose friends -> check Instagram/clues -> travel on map -> explore location -> make event choice -> record outcome -> spend resources -> choose next location or next week -> ending recap after Week 14

## 8. Map and Location Structure

### 8.1 Current Map Structure

The current implementation represents ANU campus as location nodes connected by neighbour links. Each location id is a point on the map, and the player moves between connected nodes. This structure is clear and low-risk for the Week 1 vertical slice.

### 8.2 Final Map Expansion Direction

As the number of events and location-specific details grows, a single-node structure may become too flat. Long-term, the map should support a hierarchy of larger regions and smaller exploration points.

Example structure:

| Layer | Role | Example |
| --- | --- | --- |
| Region | Larger campus activity area | Central Campus, Residential Area, Sports Area, Arts Area |
| Location Node | Main map destination | Chifley & Marie Reay, Bruce Hall, Copland |
| Sub-node | Specific exploration point inside a location | notice board, rooftop garden, basketball court, cafe corner |
| Event Anchor | Exact point where an event triggers | bench, sign, court, building entrance |

This structure lets the same large location contain multiple events that depend on time, friends, clues, and previous choices. For example, Bruce Hall could contain grassland, entrance, rooftop garden, and nearby path sub-nodes.

### 8.3 Time-Based Access

Final gameplay can make locations and events available or unavailable depending on time.

Access restrictions should start at the location level. For example, if a building or facility is closed after evening, the whole location can be marked inaccessible at that time. If sub-nodes are added later, the same location could remain open while only certain sub-nodes open or close by time.

Examples:

- Morning can support cafes, free breakfast, pre-class encounters, and quiet campus moments.
- Midday can support central campus, food areas, club promotion, and friend encounters.
- Evening can support residences, sport, clubs, night walks, and performance events.
- Some administrative buildings or facilities can close after certain hours.
- Nature, public art, and outdoor places can stay accessible, but their descriptions can change by time.

Rules:

- Time limits should make the campus feel different over the day, not simply block the player.
- Event data must not conflict with location access time. If a location cannot be accessed at a certain time, do not place an event there that only occurs during that time.
- If too many places close, exploration becomes frustrating. There should always be fallback places and low-cost actions.

## 9. Resource System

The final game uses three resources: time, energy, and money.

### 9.1 Time

Time is the most irreversible weekly resource. It is spent on movement, exploration, and event choices. Time cannot be restored by events. When time runs out, the current week ends.

The current implementation uses a simple 8 AP model. The final game should instead compress the whole week into one representative free-time day. This representative day runs from 08:00 to 24:00, and actions consume time in 1-hour units. Current time affects event eligibility and location access.

In this model, one round represents how the player spent their meaningful free time at ANU during that week. The game does not simulate every class, assignment, or daily routine. It gameifies the key free-time window where the player can explore the campus.

Recommended time phases:

| Phase | Range | Design role |
| --- | --- | --- |
| Morning | 08:00-11:00 | Arrival, breakfast, quiet campus, preparation events |
| Midday | 12:00-13:00 | Lunch, student support, friend encounters, club promotion |
| Afternoon | 14:00-17:00 | Post-class exploration, library, outdoor activity, discovery events |
| Evening | 18:00-21:00 | Clubs, sports, performances, residence-area events |
| Late Night | 22:00-24:00 | Limited late events, return home, closing mood, quiet reflection |

Event time conditions:

| Condition | Meaning |
| --- | --- |
| morning_only | Occurs only in the morning |
| midday_only | Occurs only at midday |
| afternoon_only | Occurs only in the afternoon |
| evening_only | Occurs only in the evening |
| late_night_only | Occurs only late at night |
| daytime | Occurs from 08:00 to 17:59 |
| after_dark | Occurs after 18:00 |
| anytime | Occurs regardless of time |

Example action time costs:

| Action | Time cost |
| --- | --- |
| Move to adjacent location | 1 hour |
| Move within same region to sub-node | Usually no separate time cost, included in exploration/event cost |
| Move to another region | 1 hour, or 2 hours for long-distance movement |
| Short exploration | 1 hour |
| Standard event | 1 hour |
| Long event or club activity | 2 hours |
| Rest | 1 hour |

At 24:00, the current week ends automatically. To avoid feeling abrupt, the UI should show a short transition such as "It is getting late, so you return to your residence" and then move directly to the next week preparation screen. There is no separate weekly recap at this point. The accumulated recap appears at the end of the full 14 weeks.

### 9.2 Energy

Energy represents the player's physical and emotional capacity. It is spent on movement fatigue, athletic events, long exploration, and socially demanding activities. It can be restored through rest, food, or quiet recovery events.

Final energy is managed as a small 0-10 value. This is easy for the player to understand and easy for designers to attach to event choices.

Recommended usage:

| Situation | Energy cost/effect example |
| --- | --- |
| Light conversation, short observation | 0-1 |
| Standard exploration, light movement fatigue | 1 |
| Sport, long walk, active participation | 2-3 |
| Exhausting activity or long event | 3+ |
| Rest, meal, quiet recovery event | +1 to +3 |

Energy can be restored, unlike time. However, restoration should usually cost time or money. For example, resting at a cafe may cost 1 hour and money but restore more energy. Sitting on a bench may cost no money but restore less energy.

Open tuning items:

- Starting energy and weekly reset/recovery rules should be adjusted by the next team through event design and playtesting.
- When energy is 0, choices that require energy are locked. Events that require only time can still be chosen.

### 9.3 Money

Money is used for cafes, transport, event fees, food, club activities, rental gear, and similar choices. Money can unlock convenient or stronger options, but no-cost choices must still feel meaningful.

Money is a weekly budget resource. Each week, the player receives a limited budget and decides which experiences are worth spending on. This matches the feeling of student life. Money creates pressure within the week, then resets to a new budget the next week.

Recommended usage:

| Situation | Money cost/effect example |
| --- | --- |
| Free activities, public place exploration | $0 |
| Cheap snack, transport, simple supplies | Low cost |
| Cafe, event entry, rental gear | Medium cost |
| Special event, larger outing, group activity | High cost |

Paid choices can offer faster solutions, stronger energy recovery, access to information, or social convenience. However, players without money should still have meaningful options. Free choices can be slower or cost more energy, but they should not feel narratively inferior.

Open tuning items:

- Weekly budget amount and event prices should be adjusted by the next team based on content quantity, average movement, and recovery event frequency.
- Free and low-cost choice design must remain important so the player is not locked out of meaningful play.

## 10. Treasure System

### 10.1 Philosophical Definition

A treasure is a discovery unit that communicates meaning inside ANU campus. It can be an object, place, experience, connection with people, historical story, natural phenomenon, student culture moment, or player-created memory.

### 10.2 Production Categories

For content production, treasures should be categorised as follows:

| Type | Description | Example |
| --- | --- | --- |
| Place Treasure | Meaning discovered through a place itself | library, court, hidden garden |
| History Treasure | Campus history, heritage, or records | building, memorial, old facility |
| Seasonal Treasure | Season, time, weather, or nature-linked discovery | flowers, animals, leaves, seasonal event |
| Social Treasure | People, friends, clubs, or community activity | board game night, sport activity |
| Support Treasure | Student support, survival knowledge, life information | free food, counselling, study support |
| Personal Memory | A personal memory created by player choice | helping a friend, shared moment |
| Legacy Treasure | Treasure discovered through another player's shared hint | previous player's social media clue |

### 10.3 Treasure and Event State Definitions

Treasure and event are not the same thing. The final game should store the following states separately:

| State | Meaning |
| --- | --- |
| Seen | The event appeared on screen and the player saw it |
| Experienced | The player chose an option and read the outcome text to the end |
| Resolved | The player reached an event ending |
| Found | The player discovered a treasure through the event outcome |
| Collected | The player added the treasure to the collection book |
| Shared | The player left the treasure as a hint for other players instead of collecting it |
| Missed | The player missed the treasure opportunity, but revisit may be possible |
| Retry Available | The player can retry the missed event in the current playthrough |
| Locked Out | The treasure cannot be obtained again in the current playthrough |

Confirmed state recording rules:

- Record `Seen` when the event appears on screen.
- Record `Experienced` when the player chooses an option and reads the result text to the end.
- If the player found a treasure but shared it, record both `Found` and `Shared`.
- If the player chose a failed option but can revisit, record `Missed` and `Retry Available`.
- If the player shares a treasure, record it as `Locked Out` for the current playthrough.
- The ending should treat collected and shared treasures as equally important choices.

These states should not be stored as one mutually exclusive value only. One event record can have multiple states at once, such as `Seen + Experienced + Found + Shared + Locked Out`. This allows the ending to distinguish "treasures I kept" from "treasures I discovered and left for others."

## 11. Collect / Share System

### 11.1 Collect

Collect means the player keeps the treasure in their own collection book.

Results:

- The treasure is added to the Investigator Card or Collection Book.
- Treasure image, name, description, related location, and discovery week are stored.
- It appears in the ending recap as a treasure the player kept.

### 11.2 Share

Share means the player does not add the treasure to their collection book, and instead leaves it as a hint for other players.

Results:

- The treasure is not collected in the current playthrough.
- The event's meaning and scene remain in the Memory Ledger because the player already experienced it.
- The event is completed and the same treasure cannot be obtained again in the current playthrough.
- A share record is saved to Supabase.
- The shared post can appear in other players' in-game social media feeds.
- It appears in the ending recap as a legacy the player left behind.

### 11.3 Emotional Reward for Sharing

Share should feel like a legacy, not just a loss. The ending can use language like:

> You did not keep the Lemon Tree for yourself. Instead, you left a small hint on campus so that someone else would not have to walk through a hard day alone.

## 12. Clue System

A clue is an information unit that helps the player find a treasure or event. Clues can be obtained through:

- Friends' social media posts
- Shared posts left by previous players
- Clickable keywords in event text
- QR codes or real campus hints
- Conversation with friends
- Failed or hint-oriented event choices

Clue effects:

- A pin appears on the map.
- The related location hover information shows a clue marker.
- Related event trigger chance increases or becomes guaranteed.
- Certain choices may unlock.

Open design items:

- The next team should decide whether clues guarantee event triggering or only increase probability.
- The next team should decide whether clue pins show exact locations or broader regions.

## 13. Friend / Trait System

### 13.1 Friend Role

Friends are not just bonuses. They change how the player reads the campus.

In the MVP, friends can remain weekly trait providers and clue sources. In this version, their purpose is to let the player choose different exploration strategies each week.

In an expanded version, friends can have short personal stories, relationship changes, recurring events, and ending recap lines. In that version, friends help the campus feel like a network of people, not only a map of places.

Shared functions:

- The player can choose up to two friends at the start of each week.
- Friends provide traits.
- Friends can unlock certain event choices.
- Friends provide social media clue posts.
- Friends appear in the ending recap.
- Friends can provide different perspectives on specific treasures.

### 13.2 Trait Role

Traits represent exploration tendencies or expertise owned by the player and friends. Treasures and events have tags, and matching traits can improve efficiency or unlock choices.

Example traits:

| Trait | Example effect |
| --- | --- |
| History Enthusiast | Better interpretation or success chance for History Treasures |
| Athlete | Reduced energy cost for movement or sport events |
| Social Connector | Unlocks friend or club-related event choices |
| Nature Observer | Higher chance to discover Seasonal Treasures |
| Budget Planner | Reduces cost or reveals free alternatives |
| Night Owl | Can discover late-time events |

Open design items:

- The next team should decide how player major maps to traits.
- The next team should choose between MVP friend system and expanded friend system based on scope.

## 14. Event System

### 14.1 Event Role

Events are the main narrative unit for delivering treasures. They should not feel like simple quizzes. Each event should be a small scene that asks how the player reads a place.

### 14.2 Basic Event Structure

Each event should include:

- event_id
- title
- location_id
- location availability compatibility
- week availability
- time-of-day availability
- treasure_id
- treasure_type
- tags
- source type
- evidence note
- narrative intro
- choices
- choice costs
- choice requirements
- outcome texts
- result state
- collect/share availability
- re-trigger rule
- ending memory text
- asset references

When adding an event, the team must check that the event's `time-of-day availability` does not conflict with the location's access hours. For example, if a location closes in the evening, do not place an `evening_only` event in that location.

### 14.3 Choice Principles

Each event should usually have at least three choices.

- A: Observe deeply or participate actively, leading to treasure discovery.
- B: Pass over the opportunity or rush, causing the player to miss it.
- C: Does not fully succeed, but gives clue, revisit chance, relationship change, or trigger boost.

Rules:

- B choices must not mock the player.
- Failure should feel like a different semester story, not punishment.
- C choices can connect well with the share and clue systems.

## 15. Social Media System

The in-game social media system is accessed through the phone UI. It is not just a menu. It is where clues, friends, and legacy meet.

Functions:

- Shows friends' weekly posts.
- Provides clues through clickable keywords.
- Shows treasure hint posts shared by previous players.
- Creates posts when the player shares a treasure.
- Can support QR codes or external campus activity connections.

Final implementation:

- The feed combines local base posts and shared posts loaded from Supabase.
- Shared posts appear through random probability or conditional recommendation.
- A post contains author_name, avatar, text, image, clue annotation, and shared_treasure_id.
- MVP does not let players write completely free text. Instead, it combines prepared keywords and sentence templates into shared posts. This gives expression while reducing inappropriate content risk, similar to the message systems in Dark Souls or Elden Ring.
- Expanded implementation can consider free player text only if filtering, reporting, or review flows are ready.

Open design items:

- Decide how often other players' shared posts appear.
- Decide how to choose among multiple shared posts for the same treasure.
- MVP moderation should use banned word or keyword filtering.

## 16. Memory Ledger

The Memory Ledger is the player's semester journal inside the personal save file. The game writes down which events the player saw, which choices they made, and which treasures they collected or shared. At the end of 14 weeks, the ending recap reads this journal and shows the player's campus story.

The Memory Ledger is not a public server record. Personal progress and ending recap data are stored in the personal save file. When the player shares a treasure, only the shared post or hint that other players can see is stored on Supabase.

Example:

- Record that the `Lemon Tree` event appeared on screen: personal save file
- Record that `Lemon Tree` was shared and cannot be obtained again this run: personal save file
- Hint text for other players to see: Supabase server
- Ending line such as "You left Lemon Tree for another student": Memory Ledger in personal save file

The game must record all important experiences in the Memory Ledger so the ending recap has real source material.

Recommended fields:

| Field | Description |
| --- | --- |
| memory_id | Unique memory id |
| week | Week when it occurred |
| location_id | Location |
| event_id | Event |
| treasure_id | Related treasure |
| states | Multiple states such as Seen, Experienced, Found, Collected, Shared, Missed, Retry Available, Locked Out |
| choice_key | Choice key |
| choice_label | Choice text |
| result_state | collected/shared/missed/clue/friend, etc. |
| resource_spent | Time, energy, and money spent |
| friends_present | Friends who were present |
| traits_used | Traits used |
| emotional_tags | wonder, warmth, curiosity, generosity, etc. |
| recap_text | Text for ending recap |
| legacy_record_id | External record id connected to sharing |

## 17. Ending Recap

At the end of 14 weeks, the game shows the player's semester as a memory recap.

The final presentation format can be chosen by the next team depending on production scope and UI capacity. Photo album, SNS timeline, map route replay, letter, and credit roll can all work. The important point is not the format itself. The recap must be built from the player's actual choice records.

Recommended structure:

1. Semester ending message
2. Map route or major location highlights
3. Treasures the player collected
4. Legacy the player shared
5. Friends the player met
6. Missed but memorable moments
7. Play style summary
8. Developer credits

### 17.1 Play Style Summary

Instead of a score, the ending interprets the player's tendencies.

Example profiles:

| Profile | Example condition | Meaning |
| --- | --- | --- |
| The Explorer | High number of visited locations and followed clues | The player explored the campus broadly |
| The Archivist | High proportion of History or Place treasures | The player held onto records and heritage of places |
| The Connector | High proportion of friend and social treasure events | The player understood campus through people |
| The Caretaker | High proportion of share and legacy choices | The player left their experience for the next person |
| The Local | High repeat visits and retry events | The player slowly made a place their own |

## 18. Content Expansion Principles

Treasures can be added without a fixed upper limit. To maintain quality, every treasure should satisfy the following:

- It clearly connects to ANU campus or ANU life.
- It communicates meaningful emotion or information.
- It connects to at least one of location, time, people, or choice.
- It has event, clue, asset, and ending text support.
- If fact-based, it includes a source or evidence note.
- If personal or user-generated, it is marked as personal story or community contribution.

There is no fixed minimum number of treasures for launch. However, because the game runs for 14 weeks, each active location node should have at least one experienceable event remaining for each week. For locations with time-based access limits, coverage should be judged within accessible time windows. This prevents the map from feeling empty in later weeks.

## 19. Factuality and Content Trust Policy

The game can mix real campus information, personal stories, and fictionalised narrative. The next team should include content trust classification in the data.

Recommended `source_type` values:

| source_type | Meaning |
| --- | --- |
| official | Based on ANU official information or official institutional source |
| observed | Directly observed by the team or contributor |
| community_story | Personal story from student, staff, or player |
| fictionalised | Game adaptation based on a real location |
| legacy_user_generated | Hint generated by a previous player's share |

Rules:

- History, policy, support services, and safety information need official or verified sources.
- Personal stories and fictionalised content should not appear to be factual claims.
- User-generated hints need moderation and reporting flow.

## 20. Confirmed Decisions and Remaining Questions

### 20.1 Confirmed Decisions

| Item | Decision |
| --- | --- |
| Time-based access restriction | Start at the location level. Extend to sub-node level after sub-nodes exist. |
| Event/access conflict prevention | Do not place an event in a location during a time when that location is inaccessible. |
| 24:00 transition | No weekly recap. The player naturally returns home or to residence and moves to the next week preparation screen. |
| Map hierarchy transition | Convert to region/location/sub-node only when future event expansion requires it. |
| Ending UI | The next team can choose photo album, SNS timeline, map route replay, letter, credit roll, or another fitting form. |
| Friend system scope | Baseline is hints and movement benefit. Expanded version may include dialogue changes, ending changes, personal story, or relationship changes. |
| Energy 0 handling | Time-only events remain available. Choices requiring energy are locked. |
| Money balancing | Weekly budget and prices are tuned by the next team based on event design. |
| Shared post input | MVP uses keyword templates. Free text can be considered if filtering/review capacity exists. |
| Moderation MVP | Start with banned word or keyword filtering. |
| Content minimum | No fixed number. Each active location node should have at least one experienceable event remaining per week, judged within accessible time windows. |
| Event state recording | Record `Seen` when the event appears. Record `Experienced` when the player chooses an option and reads the result. |
| Treasure discovery/share recording | If the player shares a found treasure, record both `Found` and `Shared`. |
| Miss/retry recording | If a failed choice can be revisited, record `Missed` and `Retry Available`. |
| Share lockout | A shared treasure becomes `Locked Out` for the current playthrough. |
| Personal progress storage | Event Seen/Experienced and treasure Found/Collected/Shared/Locked Out states are stored in the personal save file. |
| Supabase storage scope | Only shared posts or hints visible to other players are stored on Supabase. |
| Ending recap data | The ending recap is built from the Memory Ledger in the personal save file. |

### 20.2 Remaining Implementation Question

The high-level direction is now decided. The remaining work is implementation detail. The next team must translate these decisions into concrete data fields and storage structures. For example, they must decide what array or dictionary structure the personal save file uses for the Memory Ledger, which columns the Supabase shared post table needs, and in what order the ending screen reads the records.

## 21. Implementation Priorities for the Next Team

1. Add a Memory Ledger data structure inside the personal save file.
2. Store event and treasure states as multiple separate states.
3. Implement a 08:00-24:00 time engine using 1-hour units.
4. Add time-based access conditions at the location level.
5. Design event cost tables using 0-10 energy and weekly budget money.
6. Add validation so event time conditions do not conflict with location access hours.
7. Extend friend and trait data structures.
8. Implement Supabase storage and retrieval for shared posts and hints.
9. Implement keyword-based shared post templates and MVP banned-word filtering.
10. Implement the ending recap screen.
11. Add content `source_type` and moderation policy fields.
12. Document the treasure and event production template.
13. Add coverage validation for weekly active location node events.

