
(define (domain service_robot_pddlPlus)

;remove requirements that are not needed
(:requirements :strips :fluents :typing :negative-preconditions :time)

(:types 
    object location
    ingredient tool - object
    base topping - ingredient
)

(:predicates
    (robot-at ?l - location)
    (at ?o - object ?l - location)

    (gripper-empty)
    (holding ?o - object)

    (prepared ?i - ingredient)
    (prep-location ?l - location)
    (base-ready)

    (exposed ?i - ingredient)
    (spoiled ?i - ingredient)
)


(:functions 
    (freshness ?i - ingredient)
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

(:action expose-food
    :parameters (?i - ingredient)
    :precondition (not (spoiled ?i))
    :effect (exposed ?i)
)

(:process degrade-food
    :parameters (?i - ingredient)
    :precondition (and
        (exposed ?i)
        (not (spoiled ?i))
    )
    :effect (and
        (decrease (freshness ?i) (* #t 1.0))
    )
)

(:event food-spoils
    :parameters (?i - ingredient)
    :precondition (and
        (exposed ?i)
        (<= (freshness ?i) 0)
    )
    :effect (spoiled ?i)
)

(:action prepare-base
    :parameters (?b - base ?t - tool ?l - location)
    :precondition (and 
        (robot-at ?l)
        (gripper-empty)
        (prep-location ?l)
        (at ?b ?l)
        (at ?t ?l)
        (not (spoiled ?b))
    )
    :effect (and 
        (prepared ?b)
        (base-ready)
    )
)

(:action prepare-topping
    :parameters (?i - topping ?t - tool ?l - location)
    :precondition (and 
        (robot-at ?l)
        (gripper-empty)
        (base-ready)
        (prep-location ?l)
        (at ?i ?l)
        (at ?t ?l)
        (not (spoiled ?i))
    )
    :effect (and 
        (prepared ?i)
        )
    )

)