;Header and description

(define (domain service_robot)

    ;remove requirements that are not needed
    (:requirements :strips :typing)

    (:types object ingredient tool location
            
    )


    (:predicates 
        (robot-at ?l - location)
        (at ?o - object ?l - location)

        (gripper-empty)
        (holding ?o - object)

        (prepared-at ?i - ingredient ?l - location)
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

    (:action move
        :parameters (?from ?to - location)
        :precondition (robot-at ?from)
        :effect (and 
            (robot-at ?to)
            (not (robot-at ?from))
        )
    )

    (:action prepare
        :parameters (?i - ingredient ?t - tool ?l - location)
        :precondition (and 
            (robot-at ?l)
            (gripper-empty)
            (at ?i ?l)
            (at ?t ?l)
        )
        :effect (and 
            (prepared-at ?i ?l)
        )
    )
)
