
(define (domain service_robot_pddlPlus)

(:requirements :strips :fluents :typing :negative-preconditions :time)

(:types
    object location
    ingredient tool - object
)

(:predicates
    (robot-at ?l - location)
    (at ?o - object ?l - location)
    (gripper-empty)
    (holding ?o - object)

    (can-toast ?t - tool)
    (can-spread ?t - tool)

    (prep-location ?l - location)
    (prepared ?i - ingredient)
    (served-meal)

    (moving)
    (moving-to ?l - location)

    (spoiled ?i - ingredient)
    (perishable ?i - ingredient)
)

(:functions
    (freshness ?i - ingredient)
    (degradation-rate ?i - ingredient)
    (move-progress)
    (move-duration)
)


; ---------------------- Instant actions -----------------------

(:action pick-up
    :parameters (?o - object ?l - location)
    :precondition (and 
        (robot-at ?l)
        (at ?o ?l)
        (gripper-empty)
        )

    :effect (and
        (holding ?o)
        (not (at ?o ?l))
        (not (gripper-empty))
    )
)

(:action put-down
    :parameters (?o - object ?l - location)
    :precondition (and 
        (robot-at ?l)
        (holding ?o)
    )
    :effect (and 
        (at ?o ?l)
        (not(holding ?o))
        (gripper-empty)
    )
)

; ----------------------- Movement ------------------------

(:action start-move
    :parameters (?from - location ?to - location)
    :precondition (and 
        (robot-at ?from)
        (not (moving))
    )
    :effect (and 
        (moving)
        (not(robot-at ?from))
        (moving-to ?to)
        (assign (move-progress) 0))
)

(:process travel
    :parameters ()
    :precondition (and
        (moving)
    )
    :effect (and
        (increase (move-progress) (* #t 1.0))
    )
)

(:event arrive
    :parameters (?l - location)
    :precondition (and
        (moving)
        (moving-to ?l)
        (>= (move-progress) (move-duration))
    )
    :effect (and
        (not (moving))
        (not (moving-to ?l))
        (robot-at ?l)
    )
)


; -------------------- Food degradation ------------------------

(:process degrade-food
    :parameters (?i - ingredient)
    :precondition (and
        (perishable ?i)
        (not (at ?i fridge))
        (not (prepared ?i))
        (not (spoiled ?i))
        (> (freshness ?i) 0)
    )
    :effect (decrease (freshness ?i) (* #t (degradation-rate ?i)))
)

(:event food-spoils
    :parameters (?i - ingredient)
    :precondition (and
        (perishable ?i)
        (<= (freshness ?i) 0)
        (not (spoiled ?i))
    )
    :effect (spoiled ?i)
)

; ---------------------- Prepare food (instant actions) ------------------------

(:action toast-bread
    :parameters (?t - tool ?l - location)
    :precondition (and 
        (robot-at ?l)
        (gripper-empty)
        (prep-location ?l)
        (at bread ?l)
        (can-toast ?t)
        (at ?t ?l)
    )
    :effect (prepared bread)
)

(:action spread-butter
    :parameters (?t - tool ?l - location)
    :precondition (and
        (robot-at ?l) 
        (holding ?t) 
        (prepared bread)
        (prep-location ?l) 
        (at butter ?l)
        (can-spread ?t) 
        (not (spoiled butter))
    )
    :effect (prepared butter)
)

(:action spread-jam
    :parameters (?t - tool ?l - location)
    :precondition (and 
        (robot-at ?l) 
        (holding ?t) 
        (prepared butter)
        (prep-location ?l) 
        (at jam ?l)
        (can-spread ?t) 
        (not (spoiled jam))
    )
    :effect (and 
        (prepared jam)
        (served-meal)
    )
)
)

