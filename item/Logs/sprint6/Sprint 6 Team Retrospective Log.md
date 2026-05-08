# ANU TreasureMap - Sprint 6 Team Retrospective Log

**Project:** ANU TreasureMap  
**Sprint:** SCRUM Sprint 6, 28 Apr - 10 May  
**Retrospective type:** Team-level retrospective  
**Purpose:** Record Sprint 6 process reflection, feedback response, and improvement actions for the final sprint review evidence pack.

## 1. Sprint Context

Sprint 6 was the final delivery sprint for ANU TreasureMap. The team’s agreed delivery goal was to complete a playable Week 1 proof-of-concept slice rather than attempt a full twelve-week game. The protected output was a coherent player path from starting page and onboarding into the ANU map, location-based events, treasure interaction, collection evidence, and lightweight external proof-of-concept testing.

This retrospective focuses on team process, not individual performance. It records how the team responded to client feedback, testing feedback, scope risk, implementation dependencies, GitHub/CI practice, and final showcase preparation.

## 2. Evidence Sources Used

This retrospective was based on the following Sprint 6 evidence:

- W7, W8, and W9 client meeting notes.
- Jira Sprint 6 board and issue-detail screenshots.
- SCRUM-81 client-agreed Sprint 6 pivot and protected outputs.
- SCRUM-82 feedback-to-Jira action register.
- SCRUM-84 Sprint 6 risk and dependency log.
- SCRUM-108 external testing summary.
- SCRUM-116 external testing reflection and final-version handover.
- SCRUM-128 deferred feature backlog from client scope negotiation.
- SCRUM-130 onboarding-first prioritisation.
- SCRUM-136 font-size and text-background readability improvement.
- SCRUM-142 event animations and image transitions.
- SCRUM-143 treasure choice interaction.
- SCRUM-144 game ending and credits flow.
- SCRUM-148 Go button, phone click, and event sound effects.
- SCRUM-150 poster information hierarchy, QR placement, and professional credits.
- SCRUM-151 professional 2-3 minute pitch video script.
- Final game screenshots showing start page, map, event flow, and treasure/collection evidence.
- GitHub PR and CI evidence for Sprint 6 implementation and documentation work.

## 3. What Went Well

### 3.1 The team converted scope pressure into a client-agreed delivery plan

The most important improvement in Sprint 6 was that the team stopped treating the full game concept as the implementation target. After the Sprint 5 pivot and the client’s paper-prototype expectations created pressure on the team’s capacity, Sprint 6 narrowed the goal to a playable Week 1 vertical slice.

This was not a private scope reduction. W7 and W8 client evidence recorded the scope adjustment as a negotiated pivot based on client feedback and what was realistic to deliver. SCRUM-81 then captured the protected outputs: start page, onboarding, playable Week 1, node events, treasure collection UI, music, treasure image, and proof-of-concept testing.

This helped the team protect quality. Instead of spreading effort thinly across a broad twelve-week version, the team focused on making one playable path understandable, demonstrable, and testable.

### 3.2 Client feedback became visible work

The team improved its feedback handling by turning client feedback into Jira tasks and evidence issues. W8 and W9 client meetings produced clear action items around onboarding, UI readability, footer layout, poster hierarchy, pitch tone, infinite-time showcase support, and royalty-free audio.

SCRUM-82 recorded this feedback-to-action process. Later Jira items then show that feedback was acted on rather than only discussed. Examples include SCRUM-130 for onboarding-first prioritisation, SCRUM-136 for larger fonts and text backgrounds, SCRUM-148 for sound feedback, SCRUM-150 for poster hierarchy and QR placement, and SCRUM-151 for pitch scripting.

### 3.3 The final game became a coherent proof path

The final build evidence shows a clearer product flow than earlier sprint work. The game now has a start screen, ANU map, HUD/resource information, event screens, character/event visuals, and collection evidence. This matters because the project is no longer only a concept or static map; it demonstrates the core loop of campus exploration, location-triggered events, and treasure discovery.

The Week 1 slice also became a useful foundation for handover. Future teams can extend the same loop into later weeks, richer mechanics, additional events, and deeper treasure logic.

### 3.4 Testing was closed honestly

External testing was not a formal usability study, but the team closed it at a lightweight formative proof-of-concept level. Three external users tested or reviewed the playable slice, and the team recorded repeated themes: the slice worked as a proof path, but the first impression needed to feel more game-like and players needed clearer guidance.

The team responded by recording testing outcomes in SCRUM-108 and SCRUM-116, maintaining a testing response register, and linking feedback to onboarding, UI, event, treasure, and sound tasks.

### 3.5 The project story became clearer through poster and pitch preparation

W9 client feedback emphasised that the final showcase should sell a clear professional vision rather than simply list features. The poster draft helped organise the project around goals, stakeholders, gameplay steps, activities, outcomes, impact, testing insights, and pitch access.

This improved the project’s communication layer. The poster and pitch work made the final game easier to explain to users, clients, tutors, and future teams.

## 4. What Did Not Go As Well

### 4.1 Velocity tracking was not mature enough

The team used story points and Jira estimates, but Sprint 6 did not maintain a fully mature velocity process. Planned, completed, carried-over, and deferred work were not consistently compared in a single velocity record during the sprint.

The team still learned from the Done/deferred split. The main planning lesson is that future sprints should protect the core playable loop first, then add content volume only after onboarding, integration, and readability are stable.

### 4.2 Formal peer review was inconsistently captured

GitHub PRs were used throughout Sprint 6, but formal reviewer assignment and approval were not consistently recorded. Some work was merged after self-review or lightweight checking.

The team reduced some quality risk through PR templates, linked Jira references, implementation summaries, manual test notes, CI checks, and post-merge corrective PRs. However, future work should require explicit reviewer assignment for code, documentation, and design PRs before merge.

### 4.3 Narrative, art, and code dependencies created bottlenecks

Several implementation streams depended on earlier creative decisions. Event art could not be produced confidently until the event script and flow were clear. Event implementation also depended on final assets and JSON/event data. This created waiting time across narrative, art, and code work.

The team responded by splitting work into explicit roles and recording the dependency risk in the Sprint 6 risk/dependency log. For future sprints, the team should use earlier story-art-code contracts, placeholder-first integration, and short integration checkpoints.

### 4.4 External testing happened late and remained lightweight

The final external testing evidence was useful, but the process was casual and late in the sprint. This limited the team’s ability to run a second testing cycle after changes were implemented.

For future work, testing should begin with a simple task script and response template earlier in the sprint. Even two or three early tests would give the team more time to improve onboarding, game identity, event feedback, and treasure clarity before final closure.

### 4.5 Some final showcase requirements arrived late

W9 feedback added important presentation requirements: stronger poster hierarchy, QR placement, professional credits, pitch tone, sound compliance, and self-managed demo support. These were useful improvements, but they added late cross-functional work across design, pitch, build, and documentation.

The team managed this by creating specific poster, pitch, audio, and showcase tasks. Future teams should begin showcase framing earlier, especially when a project has both software delivery and public demonstration requirements.

## 5. Feedback-to-Action Response Record

| Feedback source | Feedback / issue raised | Team response | Jira / evidence link |
|---|---|---|---|
| W7 client meeting | Sprint 5/Sprint 6 scope needed to be understood as a negotiated pivot, not disorganisation. | Recorded protected Sprint 6 outputs and focused on a playable Week 1 slice. | SCRUM-81 |
| W8 client meeting | Deliver a vertical slice and concept presentation rather than a full game. | Protected Week 1 gameplay and moved larger ideas into future handover/backlog. | SCRUM-81, SCRUM-127, SCRUM-128 |
| W8/W9 client meetings | Improve readability, contrast, and font size. | Increased font size, added text-background labels, improved map/HUD readability. | SCRUM-96, SCRUM-123, SCRUM-136 |
| W9 client meeting | Prioritise first impression and onboarding over filling every node with events. | Prioritised onboarding-first polish and finalised tutorial flow. | SCRUM-97, SCRUM-105, SCRUM-130 |
| W9 client meeting | Unimplemented nodes should be marked inactive or Coming Soon. | Treated unfinished nodes as explicit scope boundaries rather than hidden failures. | SCRUM-128, SCRUM-134 |
| W9 client meeting | Demo should be self-managed and use infinite-time/infinite-resource support. | Added demo-support flow and infinite-time showcase mode. | SCRUM-119, SCRUM-132, SCRUM-133 |
| W9 client meeting | Poster should have clearer information hierarchy, QR placement, and professional credits. | Refined poster structure around goals, activities, outcomes, impact, testing insights, and QR call-to-action. | SCRUM-150 |
| W9 client meeting | Pitch should be professional and avoid excessive memes. | Drafted a professional 2-3 minute pitch video script. | SCRUM-151 |
| W9 client meeting | Music must be royalty-free or properly credited. | Selected/credited audio and implemented BGM, click, and event sound effects. | SCRUM-122, SCRUM-148, SCRUM-149 |
| External testing | Players did not always know what to do. | Closed onboarding validation and improved first-action guidance. | SCRUM-105, SCRUM-97, SCRUM-130 |
| External testing | The game needed stronger game identity and clearer treasure-hunting feel. | Recorded as formative finding; strengthened visual/gameplay presentation and preserved richer RPG ideas for handover. | SCRUM-108, SCRUM-116, SCRUM-145, SCRUM-146, SCRUM-147 |
| External testing | Events needed clearer feedback and transitions. | Added event animations, image transitions, and stronger event visual support. | SCRUM-142, SCRUM-140 |
| External testing | Treasure interaction needed clearer reward/choice structure. | Implemented collect/hint logic, treasure book evidence, and pick-one-of-two interaction. | SCRUM-94, SCRUM-120, SCRUM-138, SCRUM-143 |

## 6. Retrospective Actions and PBI Mapping

| Retrospective action | Why it matters | Status / Jira mapping |
|---|---|---|
| Protect the Week 1 playable loop before adding content volume. | Prevents scope drift and keeps the final delivery testable. | Implemented through SCRUM-81, SCRUM-87, SCRUM-97, SCRUM-124, SCRUM-128, SCRUM-130 |
| Convert client feedback into Jira action items within the same week. | Prevents feedback from being lost in meeting notes. | Implemented through SCRUM-82 and W8/W9 action tables |
| Maintain a deferred-feature backlog instead of treating unimplemented ideas as failed sprint work. | Preserves future product value while protecting Sprint 6 scope. | Implemented through SCRUM-128 |
| Record risk mitigation and end-of-sprint status. | Makes planning decisions explainable and reviewable. | Implemented through SCRUM-84 risk/dependency log |
| Close external testing with a response register and limitation statement. | Keeps testing evidence honest and actionable. | Implemented through SCRUM-108, SCRUM-116, external testing closure docs |
| Improve onboarding before adding more node events. | Users need to understand the first action before more content adds value. | Implemented through SCRUM-97, SCRUM-105, SCRUM-130 |
| Improve visual readability and footer layout. | Client feedback showed the original map/header layout reduced readability. | Implemented through SCRUM-96, SCRUM-123, SCRUM-136 |
| Add event visuals, transitions, and sound feedback. | Makes the slice feel more like a game and less like a static campus guide. | Implemented through SCRUM-142, SCRUM-145, SCRUM-148 |
| Require explicit reviewer assignment for future PRs. | Reduces self-review risk and improves traceability of peer review. | Future process PBI / handover action |
| Maintain a formal planned/completed/carry-over velocity note. | Makes future estimation more reliable. | Future process PBI / handover action |
| Begin external testing earlier with a lightweight task script. | Allows a second improvement cycle before sprint close. | Future process PBI / handover action |
| Use story-art-code contracts before event implementation. | Reduces dependency waiting between narrative, art, and code. | Future process PBI / handover action |

## 7. Team Reflection

The main Sprint 6 lesson is that a small, coherent, client-aligned slice is more valuable than a broad but unstable feature set. The team’s earlier risk was trying to preserve too much of the ideal game concept inside one final sprint. Sprint 6 improved this by treating Week 1 as the proof mechanism: if Week 1 can show onboarding, map movement, event triggering, treasure interaction, and collection evidence, then later weeks can be described as extensions rather than forced into the sprint.

The second lesson is that feedback must become visible work quickly. W9 client feedback was specific and useful, but it touched many parts of the project: UI, onboarding, demo mode, poster, pitch, sound, and scope boundaries. The team handled this better once feedback was converted into Jira tasks and evidence issues. This made the sprint easier to defend because the report can show not only what the client said, but what the team did in response.

The third lesson is that quality control must be made more explicit. GitHub PRs, CI checks, manual checks, and Jira linkage helped Sprint 6 delivery, but formal peer review was not consistently captured. Future teams should keep the PR workflow but strengthen it with required reviewer assignment and approval before merge.

The fourth lesson is that testing evidence does not need to be exaggerated to be useful. Sprint 6 external testing was lightweight and formative, not a formal usability study. However, it still gave the team important product signals: players needed clearer game identity, clearer onboarding, more visible event outcomes, and stronger treasure feedback. By recording the limitation and the response register, the team turned imperfect testing into useful evidence rather than hiding the weakness.

Overall, Sprint 6 improved the team’s operating model. The team moved from broad ambition toward protected delivery, from informal feedback toward Jira-linked action, from isolated implementation toward a visible playable path, and from unstructured uncertainty toward documented risk and handover decisions.

## 8. Future Operating Rules for Handover

Future ANU TreasureMap work should follow these operating rules:

1. Protect the core playable loop first: onboarding -> map -> event -> treasure choice -> outcome.
2. Add more event volume only after the first-time player experience is clear.
3. Keep client feedback in a feedback-to-Jira register.
4. Maintain a formal velocity note with planned, completed, carried-over, and deferred points.
5. Require explicit reviewer assignment before merging code, documentation, or design PRs.
6. Start external testing earlier and use a small task script.
7. Use placeholder-first integration so narrative, art, and code can progress in parallel.
8. Treat deferred ideas as future product value, not Sprint 6 failure.

## 9. Closure Statement

This retrospective closes the team-level Reflection and Improvement evidence for Sprint 6. The team sought stakeholder and testing feedback, reviewed the completed playable slice and showcase materials, identified process weaknesses, mapped feedback into Jira-linked actions, and recorded future operating rules for handover. Individual reflections are not included here because the Sprint 6 review report is being written from the team perspective.
