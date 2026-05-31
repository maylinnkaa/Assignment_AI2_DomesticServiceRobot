# Assignment_AI2_DomesticServiceRobot

## Scenario

A robot prepares breakfast but has a limited gripper: it can only hold one object at a time.  
The robot must manipulate ingredients (bread, butter, jam) and tools to prepare a meal.

## Domain Characteristics

- Robot: single manipulator
- Constraints: limited carrying capacity
- Tasks: sequential manipulation

## Modelling Guidelines

- Explicitly model the gripper state (empty vs holding).
- Ensure that object transport requires explicit actions.
- Avoid implicit assumptions about object availability.

## Repository structure

```
pddl/      Q1 — basic PDDL model
  Q1_Domain.pddl
  Q1_Problem_minimal.pddl
  Q1_Problem_critical.pddl
pddl+/     Q2 — PDDL+ model with time, degradation and spoilage
  Q2_Domain.pddl
  Q2_Problem_feasible.pddl
  Q2_Problem_infeasible.pddl
```

## Q1 – Basic PDDL Model

Requirements and how they're met:

- **Object handling constraints** — `pick-up` requires an empty gripper and sets `holding`; `put-down` frees it. Only one object can be held at a time.
- **Minimal problem** — `Q1_Problem_minimal.pddl`: all ingredients and tools already at the counter, so the plan is a straight prepare sequence.
- **Ordering-critical problem** — `Q1_Problem_critical.pddl`: ingredients start in the fridge/drawer, so the one-object limit forces a specific fetch-and-return order.
- **Valid plans** — see Q1 Results below.

### Q1 Results

**Minimal problem** (`Q1_Problem_minimal.pddl`):

```
(toast-bread toaster counter)
(pick-up knife counter)
(spread-butter knife counter)
(spread-jam knife counter)
```

**Ordering-critical problem** (`Q1_Problem_critical.pddl`):

```
(toast-bread toaster counter)
(move counter fridge)
(pick-up butter fridge)
(move fridge counter)
(put-down butter counter)
(move counter fridge)
(pick-up jam fridge)
(move fridge counter)
(put-down jam counter)
(move counter drawer)
(pick-up knife drawer)
(move drawer counter)
(spread-butter knife counter)
(spread-jam knife counter)
```

The robot makes three separate round trips (butter, jam, then the knife) because
the single gripper forces one object at a time. This is what makes the problem
"ordering-critical".

## Q2 – PDDL+ Model

Requirements and how they're met:

- **Process for time-dependent degradation** — `degrade-food` drains `freshness` while an ingredient is out of the fridge.
- **Event for spoilage** — `food-spoils` fires when `freshness` hits zero, permanently blocking the spread action.
- **Delays impact feasibility** — demonstrated by the feasible/infeasible problem pair (see Q2 Results table).

### Q2 Results

The two Q2 problems are identical except for `move-duration` (the time each trip
takes). This isolates the delay as the only variable, so any change in
feasibility is caused by it alone.

| | Feasible | Infeasible |
|---|---|---|
| `move-duration` | 5 | 10 |
| Butter freshness (start) | 20 | 20 |
| Jam freshness (start) | 8 | 8 |
| Butter spoils before use? | No | No |
| Jam spoils before use? | No (5 < 8) | Yes (10 > 8) |
| Result | reaches `served-meal` | no plan found |
 
The jam survives only while `move-duration < freshness(jam)`. Below the
threshold (8) the jam reaches the counter before the `food-spoils` event fires;
at or above it, the event triggers in transit, `spread-jam` can never run, and
`served-meal` becomes unreachable. Butter starts much fresher (20), so it never
risks spoilage at either delay — jam is the tighter constraint and the one that
determines feasibility. The "no plan found" result for the infeasible problem is
the intended outcome, not a broken file.

**Feasible plan** (`Q2_Problem_feasible.pddl`, `move-duration = 5`):
 
```
0:    (pick-up butter fridge)
0:    (start-move fridge counter)
5.0:  (put-down butter counter)
5.0:  (toast-bread toaster counter)
5.0:  (start-move counter drawer)
10.0: (pick-up knife drawer)
10.0: (start-move drawer counter)
15.0: (spread-butter knife counter)
15.0: (put-down knife counter)
15.0: (start-move counter fridge)
20.0: (pick-up jam fridge)
20.0: (start-move fridge counter)
25.0: (put-down jam counter)
25.0: (pick-up knife counter)
25.0: (spread-jam knife counter)
```
 
Jam is fetched last and exposed for only its final return trip of 5 units. With
8 units of freshness, it arrives with 3 to spare (8 − 5 = 3), so it never spoils.
Butter is fetched first and stays out longer, but with 20 units of freshness it
also arrives comfortably intact. The plan reaches `served-meal` at t = 25.
 
**Infeasible plan** (`Q2_Problem_infeasible.pddl`, `move-duration = 10`):
 
```
f(n) = 103.0 (Expanded Nodes: 589901, Evaluated States: 589909, ...) Frontier Size: 8
f(n) = 104.0 (Expanded Nodes: 589910, Evaluated States: 589911, ...) Frontier Size: 1
Problem unsolvable
Expanded Nodes: 589911
States Evaluated: 589911
```
 
Jam needs at least one fridge-to-counter trip (10 units) to be used, but it only
has 8 units of freshness. It runs out 8 units into the 10-unit trip (2 units
short of the counter) so `food-spoils` fires in transit no matter the order.
`spread-jam` can then never run, making `served-meal` unreachable.
The planner explored the entire search space (589,911 states, frontier emptied to 0) before returning `Problem unsolvable`, which confirms that no valid plan exists at `move-duration` = 10 rather than the planner simply timing out.

## Discussion

### Impact of manipulation constraints on planning
The single gripper shapes every plan the planner produces. Since the robot can only hold one object at a time, it cannot carry the butter, knife and jam together. Each one needs its own pick-up, move and put-down, with the gripper emptied in between. That's why the plans are mostly "fridge and back" trips instead of one efficient fetch of ingredients. The carrying limit doesn't just add steps, it rules out doing things in parallel. 

There is also a clash between carrying and spreading. Spreading needs the robot to be holding the knife, but pick-up needs an empty gripper, so it can't hold an ingredient and the knife at the same time. The robot has to put each ingredient down before it can pick the knife back up. Any plan that tries to skip this gets rejected, so the gripper effectively forces a strict order on actions that would otherwise be free to happen in any sequence. 

This is also where the difference between the two parts becomes interesting. In the basic PDDL model the gripper limit only makes the plan longer, it doesn't cost anything else. But once time is added in PDDL+, the same limit starts to matter. Because items go one at a time and each trip takes time, the gripper is what decides how long an ingredient sits out before it gets used. So the carrying limit and the spoilage are not separate problems. The one at a time rule is exactly what makes elapsed time, and therefore spoilage, depend on how the plan is put together. This shows up directly in the Q2 results, where the same model solves with a short trip time but becomes unsolvable once the trip is long enough for the jam to spoil in transit. 

### Modelling resource-like constraints
There are two kinds of resources in the model and they're worth telling apart.

The gripper is a reusable resource with a capacity of one. Picking something up uses it, putting something down frees it, and a single boolean `gripper-empty` tracks whether it's available or not. It works like a lock; while `gripper-empty` is false, the robot cannot pick up anything else, so only one object is ever held at a time. 

Freshness is the opposite. This resource gets used up and never comes back, and it changes with time rather than with a single action so that a single boolean can't capture it. I modelled it as a numeric fluent that the `degrade-food` process drains over time, with the `food-spoils` event firing once it hits zero. The degradation only runs while the ingredient is out of the fridge, so what actually gets spent is time outside cold storage. The planner has to budget that on its own, without being told to.

What makes the model interesting is that these two constraints shape the plan in different ways. The gripper decides the order things happen in and how many trips are needed. The order is what matters, not just how much time passes, but how long each ingredient is left out of the fridge. If the jam is taken out first, it sits exposed through everything else before it gets used, and it spoils. If it is taken out last, it's only exposed for its own trip and it survives, even though the total work is the same. Freshness then decides whether the chosen order keeps every ingredient within its limit. So the gripper limit and the spoilage are connected. Because the robot can only carry one thing at a time, it has to choose an order, and that order is what decided whether anything spoils.



## Running ENHSP locally
```
java -jar ~/enhsp/ENHSP-Public/enhsp-dist/enhsp.jar \
  -o "pddl+/Q2_Domain.pddl" \
  -f "pddl+/Q2_Problem_feasible.pddl" \
  -planner opt-blind
```
Swap in `Q2_Problem_infeasible.pddl` to reproduce the unsolvable case.