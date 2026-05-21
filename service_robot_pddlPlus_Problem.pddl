(define (problem breakfast_fresh)
(:domain service_robot_pddlPlus)

(:objects
    counter fridge drawer - location
    bread butter jam - ingredient
    knife - tool
)

(:init
    (robot-at counter)
    (gripper-empty)

    (at knife counter)

    (prep-location counter)

    (is-bread bread)
    (is-butter butter)
    (is-jam jam)

    (at bread counter)
    (at butter fridge)
    (at jam fridge)

    (= (freshness bread) 100)
    (= (freshness butter) 100)
    (= (freshness jam) 100)

    (= (prep-progress bread) 0)
    (= (prep-progress butter) 0)
    (= (prep-progress jam) 0)
)

(:goal (and
    (prepared bread)
    (prepared jam)
    (prepared butter)
  
)
)

)