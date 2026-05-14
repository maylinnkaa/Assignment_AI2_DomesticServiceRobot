(define (problem breakfast_fresh) (:domain service_robot_pddlPlus)
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

    (= (freshness bread) 20)
    (= (freshness jam) 20)
    (= (freshness butter) 20)

    (exposed bread)
    (exposed jam)
    (exposed butter)
)

(:goal (and
    (prepared bread)
    (prepared jam)
    (prepared butter)

    (not (spoiled bread))
    (not (spoiled butter))
    (not (spoiled jam))
    )
)

)
