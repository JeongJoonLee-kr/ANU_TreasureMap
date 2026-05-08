# ANU TreasureMap - Sprint 6 External Testing Final Closure

**Project:** ANU TreasureMap Game  
**Sprint:** SCRUM Sprint 6, 28 Apr - 10 May  
**Closure status:** **Closed for Sprint 6 at lightweight formative / proof-of-concept level**  
**Primary Jira evidence:** SCRUM-108 and SCRUM-116 marked Done in the final Sprint 6 Jira screenshots.  
**Project-folder location:** `item/testing/`

## 1. Final close-out statement

External proof-of-concept testing is closed for Sprint 6 at a lightweight formative level. Three external users tested or reviewed the Sprint 6 playable slice. The testing was casual and qualitative rather than a formal UX study, but the feedback was consistent and useful: the slice functioned as a playable proof path, yet the first impression did not feel game-like enough and some players did not immediately know what to do. The team treated this as a real product risk rather than a cosmetic comment. The response was recorded through Jira and sprint documentation: SCRUM-108 closed the external testing summary, SCRUM-116 closed the testing reflection and handover, SCRUM-105 closed onboarding validation, and supporting UI/event/treasure/sound tasks were completed or handed over. Therefore, the external testing evidence gap is closed for Sprint 6, with richer RPG mechanics, deeper randomness, and fuller clue systems documented as future work rather than blockers for the final playable Week 1 slice.

## 2. Why this is a valid Sprint 6 close-out

The TechLauncher Sprint Checklist expects teams to conduct relevant testing, keep PBIs up to date, respond to feedback, and create/action PBIs from review and retrospective outcomes. The Sprint 6 Jira screenshots now show that testing and feedback-response work has moved from "waiting for external testing" into visible Done evidence.

This closure is deliberately framed as **formative testing**, not formal user research. The external notes were casual, collected by a teammate, and did not include a structured survey, recordings, or quantitative scoring. That limitation is not hidden; it is the reason this document describes the activity as proof-of-concept validation rather than final usability validation.

## 3. Evidence source

- 3 external user tests/reviews were completed informally.
- Feedback was consistent across testers: the slice did not yet feel game-like enough, and players did not always know what to do.
- The latest tester expected a more RPG-style treasure-hunting experience.
- Final Sprint 6 Jira screenshots show the external-testing summary, reflection/handover, onboarding validation, and relevant feedback-response implementation tasks marked Done.

## 4. Final Jira close-out evidence

| Jira item | Title | Category | Status | Closure relevance |
|---|---|---|---|---|
| SCRUM-45 | External Testing Follow-up from Sprint 5 | Testing & Validation | Done | Shows that previous external-testing concern was followed up in Sprint 6. |
| SCRUM-105 | Validate Starting Page and Onboarding Flow | Testing & Validation | Done | Addresses testers not knowing what to do. |
| SCRUM-108 | Run External Testing and Summarise Final Playable-Slice Results | Testing & Validation | Done | Primary external testing close-out item. |
| SCRUM-116 | Document External Testing Reflection and Final-Version Handover | Testing & Validation | Done | Turns testing outcome into reflection and handover evidence. |
| SCRUM-130 | Prioritise Onboarding First-Impression Polish Over Extra Node Events | UI / UX / Visuals | Done | Direct response to first-impression and player-guidance feedback. |
| SCRUM-136 | Increase Game Font Size and Add Text Background Labels | UI / UX / Visuals | Done | Improves readability after player/visual feedback. |
| SCRUM-138 | Implement Treasure Book UI and Collection System Evidence | UI / UX / Visuals | Done | Strengthens reward/collection feedback. |
| SCRUM-142 | Implement Event Animations and Image Transitions | Core Systems | Done | Direct response to animation/transition feedback. |
| SCRUM-143 | Implement Treasure Choice Pick-One-of-Two Interaction | Core Systems | Done | Adds clearer gameplay interaction in the treasure loop. |
| SCRUM-145 | Add Event Character Sprites to the Playable Event System | Art / Audio | Done | Moves event presentation away from static utility UI. |
| SCRUM-146 | Update Phone, Profile, and Map Icons for Final UI | Art / Audio | Done | Preserves strong phone/profile direction and improves final UI identity. |
| SCRUM-147 | Create Tutorial Bear Illustrations and Dialog Box Assets | Art / Audio | Done | Supports onboarding and game personality. |
| SCRUM-148 | Implement Go Button, Phone Click, and Event Sound Effects | Art / Audio | Done | Adds action feedback and game feel. |

## 5. Feedback-to-response register

| Theme | External feedback | Team interpretation | Sprint 6 response / Jira evidence | Status |
|---|---|---|---|---|
| Game identity / first impression | The interface looked more like an open-week campus guide than a game; testers expected a stronger RPG or treasure-hunting feel. | The playable slice needed stronger game framing, not only functional map navigation. | Closed as a formative finding and reflected through SCRUM-130, SCRUM-136, SCRUM-145, SCRUM-146, SCRUM-147, SCRUM-148, and final presentation/handover work. Broader RPG depth remains future work. | Closed for Sprint 6; future enhancement recorded. |
| Player guidance / onboarding clarity | Players did not always know what to do. | The game needed clearer first-action guidance and a more readable tutorial path. | SCRUM-105 Validate Starting Page and Onboarding Flow marked Done; SCRUM-97 Finalize Starting Page, Onboarding, and Tutorial Flow marked Done; SCRUM-148 Go Button, Phone Click, and Event Sound Effects marked Done. | Closed. |
| Map and HUD personality | Map felt monotonous; top menu felt like a mobile app; location photos felt less game-like. | Visual styling needed to shift from utility interface toward game interface. | SCRUM-123 Finalize Map Alignment, Readability, Boundary Lines, and HUD Layout marked Done; SCRUM-136 font/background readability marked Done; SCRUM-146 phone/profile/map icon update marked Done. Full map stylisation remains a future art direction. | Partly implemented; future art polish handed over. |
| Event feedback and transitions | Events should use animations or image transitions; players could not always tell what had happened. | Event outcomes needed clearer feedback loops so players understand cause, outcome, and reward/no-reward state. | SCRUM-142 Implement Event Animations and Image Transitions marked Done; SCRUM-140 Integrate Week 1 Playable Event Set into Final Build marked Done; SCRUM-144 Game Ending and Credits Flow marked Done. | Closed for the slice; deeper outcome explanations remain future work. |
| Treasure interaction and reward clarity | Random exploration was engaging, but treasure collection could use deeper mechanics, descriptions, and clearer luck/treasure explanation. | The treasure loop worked as a hook but needed a more explicit choice/reward structure. | SCRUM-94 Implement Treasure Choice and Collect/Hint Outcome Logic Done; SCRUM-138 Treasure Book UI and Collection System Evidence Done; SCRUM-143 Pick-One-of-Two Interaction Done; SCRUM-120 Collection Board/Treasure Book/Treasure Display Support Done. | Closed for proof-of-concept; richer mechanics handed over. |
| Phone and character UI strengths | In-game phone/Instagram-style design was immersive; character card design was good. | The phone and character-card direction should be preserved as a successful design anchor. | SCRUM-119 Integrate Mobile Phone System and Demo-Support Flow Done; SCRUM-146 update phone/profile/map icons Done; event-character sprites and tutorial assets Done. | Closed as positive validation. |
| Scope boundary / deferred complexity | Testers wanted more complex mechanics, movement, randomness, and deeper clues. | These improvements point to a richer future version, but they exceed the protected Sprint 6 Week 1 proof-of-concept scope. | The final backlog screenshot shows older/deferred items remaining outside Sprint 6 closure. These are not blockers for external testing evidence; they are future-work/handover candidates. | Deferred, not a Sprint 6 blocker. |

## 6. Jira screenshot evidence index

| Screenshot | What it shows | Why it matters |
|---|---|---|
| `jira-closeout-screenshots/01_sprint6_goal_and_initial_done_items.png` | Sprint 6 goal and initial Done items | Shows the Sprint 6 goal: playable Week 1 slice including external proof-of-concept testing evidence, with early Sprint 6 tasks marked Done including SCRUM-45 External Testing Follow-up from Sprint 5. |
| `jira-closeout-screenshots/02_sprint6_full_top_closeout_view.png` | Sprint 6 top close-out view | Shows the Sprint 6 backlog section expanded with completed project-management, game-design, and core-system work items. |
| `jira-closeout-screenshots/03_testing_validation_and_external_testing_done.png` | Testing and validation closure view | Shows SCRUM-105 Validate Starting Page and Onboarding Flow, SCRUM-108 Run External Testing and Summarise Final Playable-Slice Results, and SCRUM-116 Document External Testing Reflection and Final-Version Handover marked Done. |
| `jira-closeout-screenshots/04_final_delivery_response_items_done.png` | Final delivery and response items | Shows final delivery work marked Done, including collection/treasure display, final map/HUD layout, documentation, and handover tasks that support the tested playable slice. |
| `jira-closeout-screenshots/05_event_visual_ui_and_audio_response_items_done.png` | Event, UI, and audio response items | Shows late Sprint 6 polish and feedback response items marked Done, including font/readability changes, treasure-book evidence, Week 1 event integration, event animations/image transitions, choice interaction, character sprites, icons, tutorial assets, and sound effects. |
| `jira-closeout-screenshots/06_deferred_backlog_not_sprint6_closure_blockers.png` | Deferred backlog evidence | Shows the separate backlog with non-Sprint-6 or deferred work items. This supports the closure boundary: broader mechanics and older open tasks remain future/backlog work, not blockers for Sprint 6 external proof-of-concept testing closure. |

## 7. Sprint review paragraph

Use this paragraph directly in the Sprint 6 review report:

> External proof-of-concept testing is closed for Sprint 6 at a lightweight formative level. Three external users tested or reviewed the Sprint 6 playable slice. The testing was casual and qualitative rather than a formal UX study, but the feedback was consistent and useful: the slice functioned as a playable proof path, yet the first impression did not feel game-like enough and some players did not immediately know what to do. The team treated this as a real product risk rather than a cosmetic comment. The response was recorded through Jira and sprint documentation: SCRUM-108 closed the external testing summary, SCRUM-116 closed the testing reflection and handover, SCRUM-105 closed onboarding validation, and supporting UI/event/treasure/sound tasks were completed or handed over. Therefore, the external testing evidence gap is closed for Sprint 6, with richer RPG mechanics, deeper randomness, and fuller clue systems documented as future work rather than blockers for the final playable Week 1 slice.

## 8. Suggested Jira close-out comments

### SCRUM-108 comment

```text
Closed. Three external formative tests/reviews were completed for the Sprint 6 playable slice. Feedback was consistent: the slice did not initially feel game-like enough and some players did not know what to do; main themes were game identity, onboarding clarity, event feedback, treasure reward clarity, map/HUD styling, and richer future mechanics. Summary and response register are now stored in item/testing/. Response items are complete or handed over through SCRUM-105, SCRUM-116, SCRUM-130, SCRUM-136, SCRUM-138, SCRUM-142, SCRUM-143, SCRUM-145, SCRUM-146, SCRUM-147, and SCRUM-148. Limitation: casual qualitative testing, no formal survey or quantitative metrics. This closes Sprint 6 external proof-of-concept testing evidence.
```

### SCRUM-116 comment

```text
Closed. External testing reflection and handover completed. The key lesson is that the final slice should be framed as an onboarding-first proof of concept: the map/phone/event/treasure loop works as a demonstrable path, but future development should deepen game feel through stronger RPG framing, clearer event outcomes, richer treasure descriptions, improved map stylisation, and a more developed clue/keyword system. Remaining complex mechanics are future-work backlog items, not blockers for Sprint 6 closure.
```

## 9. Boundary and future work

External testing is closed as Sprint 6 evidence because the team has:
1. gathered external formative feedback from three users;
2. summarised the feedback themes;
3. converted the themes into Jira response items and handover decisions;
4. shown the testing summary and reflection/handover items as Done; and
5. preserved larger gameplay improvements as future/backlog scope.

The separate backlog screenshot shows that broader or older tasks remain outside the final Sprint 6 closure. These do not invalidate the external testing close-out because the sprint goal was a playable Week 1 slice with external proof-of-concept testing evidence, not a complete twelve-week RPG system.
