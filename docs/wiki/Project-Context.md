# Project Context

Evidence baseline: repository branch `sprint6-evidence-docs`, TechLauncher delivery guide, and client-agreed team scope, verified 2026-05-05 14:01 AEST.

## Product Premise

ANU TreasureMap turns the campus into a playable map. Instead of presenting ANU as a static guide, the prototype lets players move between recognizable areas, trigger short narrative encounters, and collect treasures or clues through choices.

The core design image is simple: the campus is the board, locations are doors into stories, and player choices decide whether a discovery becomes a kept treasure, a missed chance, or a hint that could help a future player.

## Final Delivery Scope

The final semester delivery is framed as a playable Week 1 build. The team and clients agreed that the delivery target should run from the start screen through Week 1, rather than attempting to fully implement Weeks 2-12 inside the semester.

The reason is structural: Week 2 through Week 12 repeat the same play logic as Week 1. Once Week 1 proves the loop, later weeks become content expansion: more events, more treasures, more assets, and more progression tuning.

The agreed delivery target includes:

- start and onboarding flow
- playable Week 1 campus-map exploration
- at least one event or interaction for each playable node
- treasure collection UI
- music
- treasure images
- core map, travel/resource, event, choice, and progress logic
- location-linked narrative events
- treasure or missed-opportunity outcomes
- repository evidence and handover documentation

The delivery framing is supported by the TechLauncher delivery guide, the client-agreed scope supplied by the team, the repository README, Sprint 6 handover notes, Sprint 6 evidence register, and Week 7/8 client meeting notes.

## Client Feedback Trail

The main client-driven decisions were:

- Treat the scope change as a negotiated pivot, not as abandoned work.
- Deliver a playable Week 1 proof of concept before attempting a full twelve-week game.
- Improve readability, contrast, and font size after accessibility feedback.
- Use a guided or scripted happy path for demos so testers can see the intended treasure-hunting loop.
- Present the poster and pitch as a vision-led story, closer to a startup pitch than a feature inventory.
- Preserve concept depth in documentation so future teams can continue the project.

## What This Means For Review

The project should be reviewed against the agreed final delivery claim. A strong review story is not "we built the whole twelve-week game." It is "we delivered the agreed Week 1 playable experience, proved the repeatable game logic, documented the tradeoffs, and left a clear evidence trail."

That distinction matters because the build contains real implementation, but it also contains honest carry-forward work: Week 2-12 content, larger story expansion, broader user testing, final demo packaging, and richer future-player hint mechanics.

## Primary Evidence

- `README.md`
- `TL26-S1-delivery-guide.docx`
- `docs/sprint6-review-evidence.md`
- `docs/sprint6-handover.md`
- `item/meeting/meeting_2026_sems1/stakeholder_meeting/W7_Client_meeting.md`
- `item/meeting/meeting_2026_sems1/stakeholder_meeting/W8_Client_meeting.md`
