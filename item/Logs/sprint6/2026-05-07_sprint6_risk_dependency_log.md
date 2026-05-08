# ANU TreasureMap - Sprint 6 Risk and Dependency Log

## Sprint Context

Sprint 6 focused on delivering the final playable proof-of-concept for ANU TreasureMap:

> Deliver a playable Week 1 slice of ANU TreasureMap, including starting page, onboarding, Week 1 gameplay, and external proof-of-concept testing evidence.

The client-agreed delivery scope was a playable sequence from start page to onboarding, map, node event, treasure collection, and outcome. Week 2 to Week 12 were treated as future repetitions of the Week 1 gameplay loop rather than Sprint 6 implementation targets.

## Source Evidence

- W7 Client Meeting: client-agreed pivot, protected playable Week 1 slice, concept handover, starting-location discussion, UI accessibility feedback.
- W8 Client Meeting: client advocacy and scope confirmation, proof-of-concept framing, readability feedback, testing/no-show reflection guidance, poster/pitch preparation.
- W9 Client Meeting: final build feedback, onboarding priority, bottom HUD, larger fonts, inactive nodes, showcase demo mode, poster hierarchy, pitch tone, process evidence, and audio/legal guidance.
- Jira Sprint 6 action register: SCRUM-81, SCRUM-82, SCRUM-127 to SCRUM-151.

## Risk Register

### R1. Scope Drift After Sprint 5 Pivot

**Description:** Sprint 5 exposed a major scope risk: the project had to pivot early, and the client-requested paper prototype placed pressure on the team's limited time and resources. Sprint 6 risked repeating this if the team attempted a full twelve-week game rather than a narrow final product slice.

**Impact:** The team could have spread work across too many features, weakening final delivery, testing evidence, and stakeholder confidence.

**Mitigation in Sprint 6:**

- Listed the Sprint 6 work at the start of the sprint.
- Used previous story-point experience to estimate realistic delivery capacity.
- Prioritised work with MoSCoW and protected a playable Week 1 vertical slice.
- Presented the realistic scope to clients and confirmed that starting page, onboarding, playable Week 1, events, treasure collection UI, music, treasure image, and external testing evidence were the key deliverables.
- Moved non-core ideas into future backlog/handover rather than treating them as Sprint 6 failures.

**Evidence trail:** SCRUM-81, SCRUM-127, SCRUM-128, W7 Client Meeting, W8 Client Meeting.

**End-of-sprint status:** Managed. Sprint 6 scope stayed focused on the agreed playable Week 1 slice.

### R2. Final Playable Slice Integration Risk

**Description:** The final product had to feel playable as one coherent sequence, but the work was distributed across Godot scene reconstruction, onboarding, map interaction, event flow, treasure logic, UI, art, and audio.

**Impact:** Even if individual components were completed, the final sprint could fail if the player journey did not connect from start page to outcome.

**Mitigation in Sprint 6:**

- Protected the player journey: start page -> onboarding -> map -> node event -> treasure collection -> outcome.
- Reconstructed the Godot project scene to support final slice integration.
- Added final flow tasks for self-managed showcase demo, infinite-time showcase mode, inactive nodes, and ending/credits.
- Prioritised onboarding and a small number of high-quality nodes over a larger but less guided content set.

**Evidence trail:** SCRUM-97, SCRUM-124, SCRUM-130, SCRUM-132, SCRUM-133, SCRUM-134, SCRUM-144.

**End-of-sprint status:** Managed. The risk is suitable for report evidence through Jira and final build screenshots.

### R3. Narrative-to-Art-to-Code Dependency Bottleneck

**Description:** Several implementation streams depended on earlier content decisions. For example, event art could not be produced confidently until event story/dialogue was written, and event implementation depended on both narrative flow and assets.

**Impact:** Art/UI contributors could be blocked while waiting for story/event decisions, and developers could be blocked while waiting for assets or final event content.

**Mitigation in Sprint 6:**

- Split the Yuki/event pipeline into explicit roles: Wing Sze Shing for gameplay flow and narrative script, Anlin Bai for corresponding art assets, and Suya Xie for code implementation.
- Made narrative work visible in Jira instead of hiding it inside implementation tasks.
- Added explicit tasks for Week 1 event dialogue, event integration, event animations/image transitions, and event sprites.
- Treated complex enhancement systems as future backlog so the core event loop could be finished.

**Evidence trail:** SCRUM-88, SCRUM-93, SCRUM-102, SCRUM-140, SCRUM-141, SCRUM-142, SCRUM-145.

**End-of-sprint status:** Managed for the Sprint 6 playable slice. Future teams should keep narrative, art, and implementation sequencing visible in Jira.

### R4. UI Readability and Accessibility Risk

**Description:** Client feedback in Week 7 and Week 8 identified readability concerns, including low contrast text over map backgrounds and the need for a "glasses-off" readability check.

**Impact:** Poor readability would reduce testing quality, stakeholder confidence, and showcase usability because players might not understand onboarding, map, event, or outcome text.

**Mitigation in Sprint 6:**

- Converted contrast/readability feedback into Jira action.
- Increased font size and added background labels/shadows where needed.
- Relocated the top header into a bottom interaction area where appropriate.
- Toned down map connection lines so the map and nodes were easier to read.

**Evidence trail:** SCRUM-94, SCRUM-123, SCRUM-135, SCRUM-136, SCRUM-137.

**End-of-sprint status:** Managed. Final report should include readable gameplay screenshots as visual evidence.

### R5. External Testing Evidence Risk

**Description:** Sprint 6 required external proof-of-concept testing evidence, but testing participation was vulnerable to scheduling issues and no-shows.

**Impact:** Without clear testing evidence, the report could overclaim validation or weaken the Reflection and Improvement rubric area.

**Mitigation in Sprint 6:**

- Kept external testing as a protected Sprint 6 evidence item.
- Recorded testing/no-show constraints explicitly rather than hiding them.
- Prepared the final report to distinguish completed testing evidence from remaining evidence gaps.
- Assigned final-version documentation/testing reflection to Zijun Yang and report integration to Jeongjoon Lee.

**Evidence trail:** SCRUM-108, SCRUM-116, W8 Client Meeting.

**End-of-sprint status:** Partially managed. Final participant count, tester notes/forms, and screenshots should still be supplied if available.

### R6. Campus Authenticity and Location Accuracy Risk

**Description:** The game depends on recognisable ANU locations, but campus details can be inaccurate or outdated. Clients specifically noted start-location suitability and landmark/photo accuracy.

**Impact:** Inaccurate location choices or outdated imagery could make the proof-of-concept feel less credible to ANU stakeholders.

**Mitigation in Sprint 6:**

- Captured start-location and landmark/photo accuracy as a specific design action.
- Considered client suggestions such as The Hive / Computing, Uni Lodge, and updated Bruce Hall context.
- Matched nodes with the background image and toned down connection lines for clarity.
- Marked unimplemented nodes as inactive or Coming Soon to avoid implying unfinished map content was complete.

**Evidence trail:** SCRUM-91, SCRUM-129, SCRUM-134, SCRUM-137.

**End-of-sprint status:** Managed for the proof-of-concept. Future teams should revisit location accuracy if expanding beyond Week 1.

### R7. Audio Licensing and Attribution Risk

**Description:** Music and sound effects increase product polish, but public showcase/report use creates a risk if audio is not royalty-free or properly credited.

**Impact:** Uncredited or unsuitable audio could weaken professionalism and create avoidable legal/academic presentation risk.

**Mitigation in Sprint 6:**

- Created a specific audio-credit task.
- Tracked music direction separately from sound effects.
- Required royalty-free or properly credited music for final report/showcase evidence.

**Evidence trail:** SCRUM-122, SCRUM-148, SCRUM-149, W9 Client Meeting.

**End-of-sprint status:** Managed if final report includes audio credit/source evidence.

### R8. Showcase Communication Risk

**Description:** Sprint 6 did not only require a game build. The team also needed poster, pitch, and showcase material that could communicate goal, activities, outcomes, and future value.

**Impact:** A technically functional prototype could still score poorly if final communication was unclear, unprofessional, or unsupported by evidence.

**Mitigation in Sprint 6:**

- Converted poster and pitch feedback into explicit Jira tasks.
- Applied client guidance: poster hierarchy of Goal -> Activities -> Outcomes, QR code bottom right, team names/roles/course/College visible, and a professional energetic pitch tone.
- Framed the pitch as a startup-style product vision rather than a meme-heavy presentation.

**Evidence trail:** SCRUM-110, SCRUM-112, SCRUM-114, SCRUM-150, SCRUM-151.

**End-of-sprint status:** Managed for planning evidence. Final poster/pitch screenshots should be embedded in the Sprint 6 DOCX if available.

## Dependency Register

### D1. Client Agreement Before Sprint Execution

The final Sprint 6 backlog depended on client confirmation that the team should deliver a playable Week 1 proof-of-concept rather than a complete twelve-week game.

**Dependency owner:** Jeongjoon Lee  
**Closure evidence:** SCRUM-81, W7 Client Meeting, W8 Client Meeting  
**Status:** Closed

### D2. Event Script Before Art and Implementation

Event art and code depended on narrative and gameplay-flow decisions. Yuki, Chess Board, and Kangaroo dialogue needed to be written before event assets and implementation could be finalised.

**Dependency owner:** Wing Sze Shing for narrative; Anlin Bai for art; Suya Xie for implementation  
**Closure evidence:** SCRUM-141, SCRUM-145, SCRUM-140  
**Status:** Closed for Sprint 6 playable content; continue for future event expansion

### D3. Scene Integration Depends on Core Systems and Assets

The final playable sequence depended on map nodes, onboarding/tutorial flow, event flow, treasure collection, profile/collection UI, and outcome/credits being integrated into one Godot scene.

**Dependency owner:** Shaoming Qin  
**Closure evidence:** SCRUM-119, SCRUM-120, SCRUM-121, SCRUM-124, SCRUM-132, SCRUM-144  
**Status:** Closed for Sprint 6 report evidence; final screenshots should be captured

### D4. UI Polish Depends on Client Readability Feedback

Final UI polish depended on W8/W9 client feedback about contrast, font size, text backgrounds, HUD placement, and map clarity.

**Dependency owner:** Shaoming Qin, Xiyin Li, Zijun Yang, Suya Xie  
**Closure evidence:** SCRUM-123, SCRUM-135, SCRUM-136, SCRUM-137  
**Status:** Closed

### D5. Testing Reflection Depends on Real Participant Evidence

The testing/reflection section depends on available participant count, feedback notes, screenshots/forms, and no-show context.

**Dependency owner:** Zijun Yang and Jeongjoon Lee  
**Closure evidence:** SCRUM-108, SCRUM-116  
**Status:** Partially closed. User/team should still provide final participant artifacts if available.

### D6. Report Evidence Depends on Jira, GitHub, Meeting Notes, and Screenshots

The final Sprint 6 DOCX depends on embedded evidence from Jira, GitHub, meeting notes, build/demo screenshots, testing evidence, poster/pitch evidence, and documentation/handover material.

**Dependency owner:** Jeongjoon Lee  
**Closure evidence:** SCRUM-82, SCRUM-117, SCRUM-127, SCRUM-150, SCRUM-151, Sprint 6 report evidence screenshots  
**Status:** Open until final DOCX evidence pack is complete

## End-of-Sprint Risk Summary

Sprint 6 reduced the main Sprint 5 risks by narrowing scope, converting client feedback into owned Jira actions, and explicitly managing the dependencies between narrative, art, implementation, UI readability, testing, and final showcase communication.

The main remaining evidence dependencies before final submission are:

- final Week 9 testing participant count and feedback notes;
- final demo screenshots or video frames covering start page, onboarding, map, node event, treasure collection, and outcome;
- final poster/pitch screenshots or draft artefacts;
- audio credit/source evidence if music or sound effects are shown in the final report.
