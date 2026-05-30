(define (problem breakfast_simple) (:domain service_robot)
    (:objects 
        counter - location
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
        (at jam counter)
        (at butter counter)
        (at knife counter)
        (at toaster counter)
    )

    (:goal (and
        (served-meal)
        )
    )

)
