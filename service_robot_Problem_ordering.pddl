(define (problem breakfast_ordering_critical) (:domain service_robot)
    (:objects 
        counter fridge drawer - location
        butter jam bread - ingredient
        knife toaster - tool
    )

    (:init
        (robot-at counter)
        (gripper-empty)

        (prep-location counter)

        (can-toast toaster)
        (can-spread knife)

        (at bread counter)
        (at butter fridge)
        (at jam fridge)
        (at knife drawer)
        (at toaster counter)
    )

    (:goal (and
        (served-meal)
    ))

)
