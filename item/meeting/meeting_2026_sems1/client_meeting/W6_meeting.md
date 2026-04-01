# ANU TreasureMap Client Meeting

**Client Meeting** - **Week 6** - [31/03/26] ([15:00 - 16:00])

**Absent:** None  
**Lead/scribe:** [Jeongjoon Lee]

### Agreed Procedure
**Sharing order:** Detailed prototype walkthrough → Individual "Stand-up" updates (Done, Doing, Blockers) → Client feedback (Gall's Law & Simplicity) → Strategic advice on documentation.

The team is currently two days away from the end of the sprint. The client praised the team's proficiency in the "Stand-up" format and emphasized the importance of managing complexity by starting with simple, functional systems.

### Agenda Items
| # | Item |
|:-:|:-----|
| 1 | Detailed prototype walkthrough: Tutorial narrative and customization flow |
| 2 | Individual status updates using the agile "Stand-up" format |
| 3 | Client feedback: Complexity management (Gall’s Law) and the "Pedal bike vs. Motorbike" approach |
| 4 | Strategic advice: Early concept playtesting and process documentation (evidence) |
| 5 | Future direction: Sprint review preparation and communication cadence |

### Meeting Minutes

**Detailed Prototype & Tutorial Flow**
*   **Narrative Shift:** The tutorial has moved from a simple ID card collection to a "treasure hunting agency" theme to enhance immersion.
*   **Onboarding:** The UI simulates an Instagram-inspired interface where a friend (Alex) guides the player to register their name, major, and home base.
*   **Player Customization:** During a "Market Day" event, players select interests (e.g., history, sports), which determines the types of hints and social networks (clubs/friends) they receive.
*   **Mechanics:** The walkthrough demonstrated stamina costs for node movement, map animations, and an "Easter Egg" involving senior members (NPCs) who represent the legacy of previous players.

**Individual Stand-up Updates**
*   **Wing Sze Shing (Data):** Resolved user permission issues. Currently implementing low-level security policies in the database to ensure users only access their own data. **Blocker:** Policy implementation is currently not working as intended and requires debugging.
*   **Anlin Bai & Xiyin (Nora) Li (Art/UI):** Finalized the artistic style for treasure assets (extracting elements from photos) and designed the game start page. **Blocker:** Difficulty converting Figma designs and animations into Godot-compatible PNG sequences.
*   **Zijun Yang (Game Design):** Completed the Instagram-style interface and registration logic.
*   **Shaoming Qin & Suya Xie (Development):** Implemented the game start process, character registration, and node-to-node movement using stamina cost algorithms (BFS/DFS) **Blocker:** Experienced data loss due to Godot’s manual save requirement (Ctrl+S) and is currently re-implementing the lost logic.
*   **Jeongjoon Lee (PM):** Managed GitHub pipelines and coordinated regular feature meetings to resolve design misalignments. **Blocker:** Currently waiting for team members to deliver tutorial products to finalize the Sprint Review presentation.

**Technical & Client Strategy**
*   **Managing Complexity:** The client introduced **Gall's Law**, stating that complex systems must evolve from simple ones. They advised the team to focus on a "pedal bike" (simple/functional) rather than a "motorbike" (complex/high-risk).
*   **Playtesting:** The team was encouraged to perform "concept stage" playtesting-even with just storyboards-to ensure player choices feel meaningful before full implementation.
*   **Communication:** To avoid merge conflicts during technical integration, the client suggested shorter, more frequent (5-15 min) "intensive" check-ins and clear handover protocols similar to hospital shifts.

### Action Items
| Task | Assigned To | Due Date |
|:---|:---:|:---:|
| Submit tutorial deliverables and details for Sprint Review slides | All Team Members | Week 6 (Sunday) |
| Capture "Evidence of Process" (photos of meetings, sketches, prototypes) for the report | All Team Members | Ongoing |
| Conduct informal concept playtesting with peers outside the project | Game Design Team | Week 7 |
| Coordinate internal meeting schedule and expectations for the upcoming break | Jeongjoon Lee | Week 7 |
