;; domain file for assignment-1 part-2

(define (domain craft-bots-temporal)

    (:requirements :strips :typing :equality :fluents :durative-actions :conditional-effects :negative-preconditions :timed-initial-literals)

    (:types
        actor node mine task color - object
    )

    (:predicates 
        (actor_location ?a - actor ?l - node)
        (connected ?l1 - node ?l2 - node)

        (mine_detail ?m - mine ?l - node ?c - color)
        (resource_location ?l - node ?c - color)
        
        (create_site ?l - node)
        (site_not_created ?l - node)
        
        (carrying ?a - actor ?c - color)
        (not_carrying ?a - actor ?c - color)
        
        (deposited ?a - actor ?c - color ?l - node)
        (not_deposited ?a - actor ?c - color ?l - node)
        (not-same ?a1 ?a2 - actor)

        (is_orange ?c - color)
        (is_blue ?c - color)
        (is_red ?c - color)
        (is_black ?c - color)
        (is_green ?c - color)

        (not_orange ?c - color) 
        (not_blue ?c - color)
        (not_red ?c - color)
        (not_black ?c - color)
        (not_green ?c - color)
        
        (red_available)
    )

    (:functions 
        (color_count ?c - color ?l - node)
        (edge_length ?l1 - node ?l2 - node)
        (move_speed ?a - actor)
        (mine_duration ?m - mine)
        (mine_duration_blue ?m - mine)
        (total_resource_in_inventory ?a - actor)
    )

    (:durative-action move
        :parameters (?a - actor ?l1 ?l2 - node)
        ;; duration determined by actor move speed and edge length between locations
        :duration (= ?duration (/ (edge_length ?l1 ?l2) (move_speed ?a)))
        :condition (and 
            (at start (actor_location ?a ?l1))
            (over all (connected ?l1 ?l2))
        )
        :effect (and
            (at start (not (actor_location ?a ?l1)))
            (at end (actor_location ?a ?l2))
        )
    )

    ;; create a new site at the node where actor is present
    (:durative-action create-site
        :parameters (?a - actor ?l - node)
        :duration (= ?duration 1)
        :condition (and 
            (at start (site_not_created ?l))
            (over all (actor_location ?a ?l))
        )
        :effect (and 
            (at start (not (site_not_created ?l)))
            (at end (create_site ?l))
        )
    )
    
    ;; dig red, black or green resources
    (:durative-action dig
        :parameters (?a - actor ?m - mine ?l - node ?c - color)
        ;; duration determined by the mine's max progress and actor's mining rate
        :duration (= ?duration (mine_duration ?m))
        :condition (and 
            (over all (and 
                (actor_location ?a ?l) 
                (mine_detail ?m ?l ?c) 
                (not_orange ?c) 
                (not_blue ?c))
            )
        )
        :effect (and 
            (at end 
                (resource_location ?l ?c)
            )
        )
    )

    ;; blue resource takes twice as long to mine
    (:durative-action dig-blue
        :parameters (?a - actor ?m - mine ?l - node ?c - color)
        ;; duration determined by the mine's max progress and actor's mining rate
        :duration (= ?duration (mine_duration_blue ?m))
        :condition (and 
            (over all (and 
                (actor_location ?a ?l) 
                (mine_detail ?m ?l ?c) 
                (is_blue ?c))
            )
        )
        :effect (and 
            (at end 
                (resource_location ?l ?c)
            )
        )
    )

    ;; orange resource requires multiple actors to mine
    (:durative-action dig-orange
        :parameters (?a1 - actor ?a2 - actor ?m - mine ?l - node ?c - color)
        :duration (= ?duration (mine_duration ?m))
        :condition (and 
            (over all (and 
                (not-same ?a1 ?a2) 
                (actor_location ?a1 ?l) 
                (actor_location ?a2 ?l) 
                (mine_detail ?m ?l ?c) 
                (is_orange ?c))
            )
        )
        :effect (and 
            (at end (and 
                (resource_location ?l ?c))
            )
        )
    )

    (:durative-action pick-up
        :parameters (?a - actor ?l - node ?c - color)
        :duration (= ?duration 1)
        :condition (and 
            (at start (and 
                (not_carrying ?a ?c) (not_black ?c) (not_red ?c))
            )
            (over all (and 
                    (resource_location ?l ?c) 
                    (actor_location ?a ?l) 
                    (<=(total_resource_in_inventory) 7)
                )
            )
        )
        :effect (and 
            (at start (and
                    (not (resource_location ?l ?c)) 
                    (not (not_carrying ?a ?c))
                )
            )
            (at end (and 
                    (carrying ?a ?c) 
                    (increase (total_resource_in_inventory ?a) 1)
                )
            )
        )
    )

    ;; red resource can only be collected within time interval 0-1200
    (:durative-action pick-up-red
        :parameters (?a - actor ?l - node ?c - color)
        :duration (= ?duration 1)
        :condition (and 
            (at start (and 
                    (not_carrying ?a ?c) 
                    (red_available) 
                    (<=(total_resource_in_inventory) 7)
                )
            )
            (over all (and 
                    (actor_location ?a ?l)
                    (resource_location ?l ?c) 
                    (not_carrying ?a ?c)
                    (is_red ?c)
                )
            )
        )
        :effect (and
            (at start (and
                    (not (resource_location ?l ?c)) 
                    (not (not_carrying ?a ?c))
                )
            )
            (at end (and
                    (carrying ?a ?c)
                    (increase (total_resource_in_inventory ?a) 1)
                )
            )
        )
    )
    
    ;; black resource cannot be carried with any other resource
    (:durative-action pick-up-black
        :parameters (?a - actor ?l - node ?c - color)
        :duration (= ?duration 1)
        :condition (and 
            (at start (and 
                    (not_carrying ?a ?c)
                    (=(total_resource_in_inventory) 0)
                )
            )
            (over all (and 
                    (actor_location ?a ?l) 
                    (resource_location ?l ?c)
                    (is_black ?c)
                )
            )
        )
        :effect (and 
            (at start (and
                    (not (resource_location ?l ?c)) 
                    (not (not_carrying ?a ?c))
                )
            )
            (at end (and
                    (carrying ?a ?c)
                    (increase (total_resource_in_inventory ?a) 1)
                )
            )
        )
    )
    
    (:durative-action deposit
        :parameters (?a - actor ?l - node ?c - color)
        :duration (= ?duration 1)
        :condition (and 
            (at start (and 
                    (carrying ?a ?c) 
                    (not_deposited ?a ?c ?l)
                )
            )
            (over all (and 
                    (actor_location ?a ?l) 
                    (carrying ?a ?c) 
                    (create_site ?l)
                )
            )
        )
        :effect (and 
            (at start (and
                    (not (not_deposited ?a ?c ?l)) 
                    (not (carrying ?a ?c)) 
                )
            )
            (at end (and 
                (deposited ?a ?c ?l)
                (not_carrying ?a ?c)
                (increase (total_resource_in_inventory ?a) 1))
            )
        )
    )
    
    (:durative-action construct
        :parameters (?a - actor ?l - node ?c - color)
        :duration (= ?duration 33) ;; construction duration is given by site_max_progress (100) / actor_build_speed (3) 
        :condition (and 
            (at start 
                (deposited ?a ?c ?l) 
            )
            (over all (and 
                    (actor_location ?a ?l) 
                    (> (color_count ?c ?l) 0)
                )
            )
        )
        :effect (and 
            (at start 
                (not (deposited ?a ?c ?l))
            )
            (at end (and 
                    (decrease (color_count ?c ?l) 1) 
                    (not_deposited ?a ?c ?l)
                )
            )
        )
    )
)