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

## Q1 – Basic PDDL Model

You must:

- Model object handling constraints.
- Provide:
  - one problem with minimal constraints
  - one where ordering becomes critical due to limited capacity
- Provide valid plans.

## Q2 – PDDL+ Model

You must:

- Introduce a process modelling time-dependent food degradation.
- Introduce an event representing food spoilage.
- Show how delays impact plan feasibility.

## Discussion

Discuss:

- impact of manipulation constraints on planning
- modelling resource-like constraints