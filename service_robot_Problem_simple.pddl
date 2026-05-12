(define (problem breakfast_simple) (:domain service_robot)
(:objects 
    table counter fridge - location
    bread butter jam - ingredient
    knife - tool
)

(:init
    (robot-at counter)
    (gripper-empty)
    
    (ingredient-object bread)
    (ingredient-object butter)
    (ingredient-object jam)
    
    (tool-object knife)

    (at bread counter)
    (at jam fridge)
    (at butter fridge)
    (at knife counter)
)

(:goal (and
    (prepared-at butter table)
    (prepared-at jam table)
    (prepared-at bread table)
    )
)

)
