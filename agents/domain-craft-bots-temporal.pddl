;; domain file for assignment-1 part-2

(define (domain craft-bots-temporal)

    (:requirements :strips :typing :equality :fluents :durative-actions :conditional-effects :negative-preconditions :timed-initial-literals)

    (:types
        actor location resource building site mine edge node task color - object
    )

    (:predicates 
        (actor_location ?a - actor ?l - location)
        (connected ?l1 - location ?l2 - location)
        (is_idle ?a - actor)

        (mine_location ?m - mine ?l - location)
        (mine_color ?m - mine ?c - color)
        (resource_location ?l - location ?c - color)

        (create_site ?l - location)
        (site_not_created ?l - location)
        
        (carrying ?a - actor ?c - color)
        (not_carrying ?a - actor ?c - color)
        
        (not-same ?a1 ?a2 - actor)

        (is_orange ?c - color)
        (is_blue ?c - color)
        (is_red ?c - color)
        (is_black ?c - color)

        (not_orange ?c - color) 
        (not_blue ?c - color)
        (not_red ?c - color)
        (not_green ?c - color)
        (not_black ?c - color)

        (is_red_available)

        (building_built ?t - task ?l - location)
        (building_not_built ?t - task ?l - location)
)

    (:functions 
        (edge_length ?l1 - location ?l2 - location)
        (move_speed ?a - actor)
        (mine_duration_blue ?m - mine)
        (mine_duration ?m - mine)

        (individual_resource_required ?t - task ?c - color)
        (total_resource_required ?t - task ?l - location)
        (total_resource_in_inventory ?a - actor)
)

    (:durative-action move
        :parameters (?a - actor ?l1 - location ?l2 - location)
        ;; duration determined by actor move speed and edge length between locations
        :duration (= ?duration (/ (edge_length ?l1 ?l2) (move_speed ?a)))
        :condition (and 
            (at start (and 
                    (actor_location ?a ?l1) 
                    (is_idle ?a)
                )
            )
            (over all (connected ?l1 ?l2))
        )
        :effect (and 
            (at start ( and
                    (not (is_idle ?a))
                    (not (actor_location ?a ?l1))
                )
            )
            (at end (and 
                    (actor_location ?a ?l2) 
                    (is_idle ?a)
                )
            )
        )
    )

    (:durative-action create-site
        :parameters (?a - actor ?l - location)
        :duration (= ?duration 3)
        :condition (and 
            (at start (and 
                    (site_not_created ?l)
                    (is_idle ?a)
                )
            )
            (over all (actor_location ?a ?l))
        )
        :effect (and
            (at start ( and
                    (not (is_idle ?a))
                    (not (site_not_created ?l))
                )
            ) 
            (at end (and 
                    (create_site ?l) 
                    (is_idle ?a)
                )
            )
        )
    )
    
    ;; dig red, black or green resources
    (:durative-action mine_resource
        :parameters (?a - actor ?m - mine ?l - location ?c - color)
        ;; duration determined by the mine's max progress and actor's mining rate
        :duration (= ?duration (mine_duration ?m))
        :condition (and 
            (at start (and 
                    (not_orange ?c) 
                    (not_blue ?c)
                    (is_idle ?a)
                )
            )
            (over all (and 
                    (actor_location ?a ?l) 
                    (mine_location ?m ?l) 
                    (mine_color ?m ?c) 
                )
            )
        )
        :effect (and 
            (at start (not (is_idle ?a))) 
            (at end (and
                (is_idle ?a)
                (resource_location ?l ?c)
            ))
        )
    )

    ;; blue resource takes twice as long to mine
    (:durative-action mine_blue_resource
        :parameters (?a - actor ?m - mine ?l - location ?c - color)
        ;; duration determined by the mine's max progress and actor's mining rate
        :duration (= ?duration (mine_duration_blue ?m))
        :condition (and 
            (at start (and 
                    (is_blue ?c)
                    (is_idle ?a)
                )
            )
            (over all (and 
                    (actor_location ?a ?l) 
                    (mine_location ?m ?l) 
                    (mine_color ?m ?c) 
                )
            )
        )
        :effect (and 
            (at start (not (is_idle ?a))) 
            (at end (and
                    (is_idle ?a)
                    (resource_location ?l ?c)
                )
            )
        )
    )

    ;; orange resource requires multiple actors to mine
    (:durative-action mine_orange_resource
        :parameters (?a1 - actor ?a2 - actor ?m - mine ?l - location ?c - color)
        :duration (= ?duration (mine_duration ?m))
        :condition (and 
            (at start (and 
                    (is_orange ?c) 
                    (is_idle ?a1)
                    (is_idle ?a2)
                )
            )
            (over all (and 
                    (not-same ?a1 ?a2) 
                    (actor_location ?a1 ?l) 
                    (actor_location ?a2 ?l) 
                    (mine_location ?m ?l) 
                    (mine_color ?m ?c) 
                )
            )
        )
        :effect (and 
            (at start (and
                    (not (is_idle ?a1))
                    (not (is_idle ?a2))
                )
            ) 
            (at end (and
                (is_idle ?a1)
                (is_idle ?a2)
                (resource_location ?l ?c)
            ))
        )
    )

    ;; red resource can only be collected within time interval 0-1200
    (:durative-action pick_up_red
        :parameters (?a - actor ?l - location ?c - color)
        :duration (= ?duration 3)
        :condition (and 
            (at start (and 
                    (not_carrying ?a ?c) 
                    (is_red_available) 
                    (is_red ?c) 
                    (is_idle ?a)
                )
            )
            (over all (and 
                    (resource_location ?l ?c) 
                    (actor_location ?a ?l) 
                    (< (total_resource_in_inventory ?a) 7)
                )
            )
        )
        :effect (and 
            (at start (and
                    (not (is_idle ?a))
                    (not (not_carrying ?a ?c))
                )
            ) 
            (at end (and 
                    (carrying ?a ?c)
                    (increase (total_resource_in_inventory ?a) 1)
                    (not (resource_location ?l ?c))
                    (is_idle ?a)
                )
            )
        )
    )
    
    
    ;; black resource cannot be carried with any other resource
    (:durative-action pick_up_black
        :parameters (?a - actor ?l - location ?c - color)
        :duration (= ?duration 3)
        :condition (and 
            (at start (and 
                    (not_carrying ?a ?c) 
                    (is_black ?c) 
                    (is_idle ?a)
                )
            )
            (over all (and 
                    (actor_location ?a ?l) 
                    (resource_location ?l ?c) 
                    (= (total_resource_in_inventory ?a) 0)
                )
            )
        )
        :effect (and 
            (at start (and
                (not (is_idle ?a))
                (not (not_carrying ?a ?c)) 
            ))
            (at end (and 
                    (carrying ?a ?c) 
                    (increase (total_resource_in_inventory ?a) 1)
                    (not (resource_location ?l ?c))
                    (is_idle ?a)
                )
            )
        )
    )
    
    (:durative-action pick-up
        :parameters (?a - actor ?l - location ?c - color)
        :duration (= ?duration 3)
        :condition (and 
            (at start (and 
                    (not_carrying ?a ?c) 
                    (not_black ?c) 
                    (not_red ?c) 
                    (is_idle ?a)
                )
            )
            (over all (and 
                    (actor_location ?a ?l) 
                    (resource_location ?l ?c) 
                    (< (total_resource_in_inventory ?a) 7)
                )
            )
        )
        :effect (and 
            (at start (and
                (not (is_idle ?a))
                (not (not_carrying ?a ?c)) 
            ))
            (at end (and 
                    (carrying ?a ?c) 
                    (increase (total_resource_in_inventory ?a) 1)
                    (not (resource_location ?l ?c)) 
                    (is_idle ?a)
                )
            )
        )
    )
    
    (:durative-action deposit
        :parameters (?a - actor ?l - location ?c - color ?t - task)
        :duration (= ?duration 3)
        :condition (and 
            (at start (and 
                    (carrying ?a ?c) 
                    (is_idle ?a)
                )
            )
            (over all (and 
                    (actor_location ?a ?l) 
                    (create_site ?l)    
                    (> (individual_resource_required ?t ?c) 0)
                    (> (total_resource_required ?t ?l) 0)
                    (< (total_resource_in_inventory ?a) 7)
                )
            )
        )
        :effect (and 
            (at start (and
                (not (carrying ?a ?c)) 
                (not (is_idle ?a))
            ))
            (at end (and 
                    (decrease (individual_resource_required ?t ?c) 1) 
                    (decrease (total_resource_required ?t ?l) 1) 
                    (decrease (total_resource_in_inventory ?a) 1)
                    (not_carrying ?a ?c)
                    (is_idle ?a)    
                )
            )
        )
    )
    
    (:durative-action construct
        :parameters (?a - actor ?l - location ?t - task)
        :duration (= ?duration 33) 
        :condition (and 
            (at start (and 
                    (is_idle ? a)
                    (building_not_built ?t ?l)
                )
            )
            (over all (and 
                    (= (total_resource_required ?t ?l) 0)
                    (actor_location ?a ?l) 
                )
            )
        )
        :effect (and 
            (at start (and
                (not ( is_idle ?a))
                (not (building_not_built ?t ?l))
            ))
            (at end (and 
                    (building_built ?t ?l)
                    (is_idle ?a)
                )
            )
        )
    )
    
)