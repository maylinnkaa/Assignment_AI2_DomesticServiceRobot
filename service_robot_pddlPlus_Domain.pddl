(define (domain service_robot_pddlPlus)

(:requirements :strips :fluents :typing :negative-preconditions :time)

(:types
    object location
    ingredient tool - object
)

(:predicates
    (robot-at ?l - location)
    (at ?o - object ?l - location)

    (prep-location ?l - location)

    (gripper-empty)
    (holding ?o - object)

    (is-bread ?i - ingredient)
    (is-butter ?i - ingredient)
    (is-jam ?i - ingredient)

    (bread-ready)
    (butter-ready)

    (exposed ?i - ingredient)
    (prepared ?i - ingredient)
    (spoiled ?i - ingredient)
)

(:functions
    (freshness ?i - ingredient)
    (prep-progress ?i - ingredient)
)

(:action move
    :parameters (?from ?to - location)
    :precondition (and 
        (robot-at ?from)
    )
    :effect (and 
        (robot-at ?to)
        (not (robot-at ?from))
    )
)

(:action pick-up-tool
    :parameters (?t - tool ?l - location)
    :precondition (and 
        (robot-at ?l)
        (at ?t ?l)
        (gripper-empty)
        )

    :effect (and
        (holding ?t)
        (not (at ?t ?l))
        (not (gripper-empty))
        )
    )

(:action pick-up-ingredient
    :parameters (?i - ingredient ?l - location)
    :precondition (and 
        (robot-at ?l)
        (at ?i ?l)
        (gripper-empty)
        )

    :effect (and
        (holding ?i)
        (not (at ?i ?l))
        (not (gripper-empty))
        (exposed ?i)
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

(:process degrade-food
    :parameters (?i - ingredient)
    :precondition (and
        (exposed ?i)
        (not (spoiled ?i))
    )
    :effect (decrease (freshness ?i) (* #t 0.1))
)

(:event food-spoils
    :parameters (?i - ingredient)
    :precondition (and
        (exposed ?i)
        (<= (freshness ?i) 0)
    )
    :effect (spoiled ?i)
)

(:process prepare-food
    :parameters (?i - ingredient ?t - tool ?l - location)
    :precondition (and
        (robot-at ?l)
        (exposed ?i)
        (at ?i ?l)
        (at ?t ?l)
        (prep-location ?l)
        (not (prepared ?i))
        (not (spoiled ?i))
    )
    :effect (increase (prep-progress ?i) (* #t 1))
)

(:event bread-prepared
    :parameters (?i - ingredient)
    :precondition (and
        (is-bread ?i)
        (>= (prep-progress ?i) 5)
        (not (prepared ?i))
    )
    :effect (and
        (prepared ?i)
        (bread-ready)
    )
)

(:event butter-prepared
    :parameters (?i - ingredient)
    :precondition (and
        (is-butter ?i)
        (bread-ready)
        (>= (prep-progress ?i) 5)
        (not (prepared ?i))
    )
    :effect (and
        (prepared ?i)
        (butter-ready)
    )
)

(:event jam-prepared
    :parameters (?i - ingredient)
    :precondition (and
        (is-jam ?i)
        (bread-ready)
        (butter-ready)
        (>= (prep-progress ?i) 5)
        (not (prepared ?i))
    )
    :effect (prepared ?i)
)

)

