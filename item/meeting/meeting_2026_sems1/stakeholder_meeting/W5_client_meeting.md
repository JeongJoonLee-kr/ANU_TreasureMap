# ANU TreasureMap Client Meeting

**Client Meeting** - **Week 5** - [24/03/26] ([15:00 - 16:00])

**Absent:** None  
**Lead/scribe:** Jeongjoon Lee

---

### Agreed Procedure
**Sharing order:** Internal meeting coordination -> Individual "Stand-up" updates (Done, Doing, Blockers) -> Paper Prototype Walkthrough (Instagram/Social Media Concept) -> Strategic prioritization (MoSCoW & Backlog) -> Client feedback.

The team conducted its second **"Stand-up"** meeting to track progress across six streams. A major focus of this session was aligning the team's vision through a **paper prototype walkthrough**, specifically exploring the "fake" social media/Instagram interface for game progression.

---

### Agenda Items
|  #  | Item                                                                                |
| :-: | :---------------------------------------------------------------------------------- |
|  1  | Coordinating internal meeting cadence (moving from ad-hoc to scheduled)             |
|  2  | Individual status updates: Logic refurbishment, art styles, and database connection |
|  3  | Paper Prototype Walkthrough: Onboarding, Instagram UI, and "Fake Friend" system     |
|  4  | Resource management discussion: Energy, Time, and Money vs. Gender/Major relevance  |
|  5  | Prioritization strategy: Implementation of MoSCoW method and Backlog management     |

---

### Meeting Minutes

#### Internal Coordination & Cadence
* **Meeting Frequency:** The clients (Susan and Thomas) strongly recommended moving away from ad-hoc internal meetings to a fixed **cadence**.  
* **Requirement:** The team must schedule at least one internal meeting per week outside the formal client meeting to ensure alignment. It is easier to cancel a scheduled meeting than to find time for an urgent one.

---

#### Individual Stand-up Updates
* **Zijun (Game Design):** Game logic mechanism is nearly complete. Currently working on storylines for specific spots/treasures and detailing in-game items.  
  **Blocker:** Translating complex design logic into feasible code.

* **Anlin (Art/UI):** Converting treasure photos into various art styles to match the "feeling" of different items (e.g., traditional styles for heritage items).  
  **Blocker:** Time constraints for creating multiple styles.

* **Wing (Data):** Successfully set up the database schema and connected it to Godot via Supabase. Working on user identification to ensure players only edit their own records.  
  **Blocker:** Scaling uncertainty regarding simultaneous connections (currently limited to 15 by default).

* **Shaoming & Suya (Development):** Developed the player status and option systems (how choices affect resources). Currently debugging and adjusting code structures for clarity and reusability.  
  **Blocker:** Determining the technical link between options, locations, and events.

* **Xiyin (Art/UI):** Completed the paper model and initial UI designs. Moving into the development team to assist with coding.  
  **Blocker:** Onboarding to the existing codebase.

* **Jeongjoon (PM):** Automated the Pull Request (PR) review process in GitHub. Tracking team progress and milestones to manage dependencies and potential delays.

---

#### Paper Prototype: The "Instagram" Concept
* **Onboarding:** The game starts with a menu (New Game/Continue). The first quest involves heading to the Student Center to collect an ANU ID card.  
* **Instagram Analogy:** The game uses a "fake" social media layout as a modern digital diary. Players follow "posts" from societies to find activities/treasures.  
* **Social Mechanics:** Players interact with "fake friends" (seniors or past players) who provide hints and help based on their unique "personalities" (e.g., a Geography lover helps find specific treasures).  
* **Character Stats:** Character creation includes Name, Gender, Major, and Personality.

---

#### Client Strategy & Feedback
* **MoSCoW Prioritization:** The client introduced the **MoSCoW method** (Must have, Should have, Could have, Won't have) to manage scope. They suggested using these as prefixes or labels in Jira.  
* **Simplification:** The clients questioned if attributes like "Gender" or "Major" have mechanical value; if they don't impact gameplay, they should be simplified or removed to save time.  
* **Scaling Targets:** Wing should investigate the feasibility of supporting **15 to 100 simultaneous players**.  
* **Storyboarding:** The team should use "storyboard" or "cartoon strip" styles for the next prototype iteration to define clickable areas and transitions.

---

### Action Items
| Task                                                                            |   Assigned To    | Due Date |
| :------------------------------------------------------------------------------ | :--------------: | :------: |
| Schedule a recurring **weekly internal meeting** (cadence)                      |  Jeongjoon Lee   |  Week 6  |
| Refine the **paper prototype** into a storyboard (shot-by-shot views)           | All Team Members |  Week 6  |
| Analyze database parameters to confirm supported **player capacity**             |  Wing Sze Shing  |  Week 6  |
| Categorize current tasks in Jira using the **MoSCoW method**                    | All Team Members |  Week 6  |
| Evaluate if "Gender/Major" stats can be crunched into a simpler "Energy" system |    Zijun Yang    |  Week 6  |
