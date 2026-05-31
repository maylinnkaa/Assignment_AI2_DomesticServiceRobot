
; Q2 — infeasible: move-duration 10 > jam freshness 8

(define (problem breakfast_fresh_infeasible)
(:domain service_robot_pddlPlus)

(:objects
    counter fridge drawer - location
    bread butter jam - ingredient
    knife toaster - tool
)

(:init
    (robot-at fridge)
    (gripper-empty)

    (prep-location counter)

    (can-spread knife)
    (can-toast toaster)

    (at knife drawer)
    (at toaster counter)

    (at bread counter)
    (at butter fridge)
    (at jam fridge)

    (= (move-progress) 0)
    (= (move-duration) 10)

    (perishable butter)
    (perishable jam)

    (= (freshness butter) 20)
    (= (freshness jam) 8)

    (= (degradation-rate butter) 1)
    (= (degradation-rate jam) 1)
)

(:goal (and
    (served-meal)
    )
)

)