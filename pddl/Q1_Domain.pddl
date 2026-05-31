
(define (domain service_robot)

    (:requirements :strips :typing)

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

        (prepared ?i - ingredient)
        (prep-location ?l - location)
        (served-meal)
    )

; ---------------------- Object handling -----------------------

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

; ----------------------- Movement -----------------------------

    (:action move
        :parameters (?from ?to - location)
        :precondition (robot-at ?from)
        :effect (and 
            (robot-at ?to)
            (not (robot-at ?from))
        )
    )

; ---------------------- Prepare food --------------------------

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
        :effect (and 
            (prepared bread)
        )
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
        )
        :effect (and 
        (prepared butter)
        )
    )
    
    (:action spread-jam
        :parameters (?t - tool ?l - location)
        :precondition (and 
        (robot-at ?l)
        (holding ?t)
        (prepared butter)
        (prep-location ?l)
        (can-spread ?t)
        (at jam ?l)
        )
        :effect (and 
        (prepared jam)
        (served-meal)
        )
    )
)
