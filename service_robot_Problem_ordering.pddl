(define (problem breakfast_ordering_critical) (:domain service_robot)
    (:objects 
        counter fridge - location
        butter jam - topping
        bread - base
        knife - tool
    )

    (:init
        (robot-at counter)
        (gripper-empty)

        (prep-location counter)

        (at bread counter)
        (at butter fridge)
        (at jam fridge)
        (at knife counter)
    )

    (:goal (and
        (prepared bread)
        (prepared jam)
        (prepared butter)
    ))

)
