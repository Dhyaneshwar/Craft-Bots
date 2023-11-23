;; Domain file for the temporal problem

(define (domain craft-bots-temporal)

    (:requirements :strips :typing :durative-actions :fluents)

    (:types
        actor node mine task color - object
    )

    (:predicates 
        (actor_location ?a - actor ?l - node)
        (connected ?l1 - node ?l2 - node)
        (is_idle ?a - actor)

        (mine_location ?m - mine ?l - node)
        (mine_color ?m - mine ?c - color)
        (resource_location ?l - node ?c - color)

        (create_site ?l - node)
        (site_not_created ?l - node)
        
        (carrying ?a - actor ?c - color)
        (not_carrying ?a - actor ?c - color)
        
        (not-same ?a1 ?a2 - actor)

        (is_red ?c - color)
        (is_blue ?c - color)
        (is_orange ?c - color)
        (is_black ?c - color)
        (is_green ?c - color)

        (not_red ?c - color)
        (not_blue ?c - color)
        (not_orange ?c - color) 
        (not_black ?c - color)
        (not_green ?c - color)

        (is_red_available ?c - color)

        (building_built ?t - task ?l - node)
        (building_not_built ?t - task ?l - node)
)

    (:functions 
        (edge_length ?l1 - node ?l2 - node)
        (move_speed ?a - actor)
        (mine_duration ?m - mine)

        (individual_resource_required ?t - task ?c - color)
        (total_resource_required ?t - task ?l - node)
        (total_resource_in_inventory ?a - actor)
)

    ;; When two nodes in the graph are linked, the agent can move between them
    (:durative-action move_between_nodes
        :parameters (?a - actor ?l1 - node ?l2 - node)
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

    ;; create a new site at the node where actor is present
    (:durative-action setup_site
        :parameters (?a - actor ?l - node)
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
    
    ;; mine red, black or green resources
    (:durative-action mine_resource
        :parameters (?a - actor ?m - mine ?l - node ?c - color)
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

    ;; mining blue resource takes twice as long as other mine
    (:durative-action mine_blue_resource
        :parameters (?a - actor ?m - mine ?l - node ?c - color)
        :duration (= ?duration (mine_duration ?m))
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

    ;; mining orange resource requires multiple actors to mine
    (:durative-action mine_orange_resource
        :parameters (?a1 - actor ?a2 - actor ?m - mine ?l - node ?c - color)
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

    ;; picking the blue, orange or green resources
    (:durative-action pick_up_resource
        :parameters (?a - actor ?l - node ?c - color)
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

    ;; the red resource can only be collected within time interval 0-1200
    (:durative-action pick_up_red_resource
        :parameters (?a - actor ?l - node ?c - color)
        :duration (= ?duration 3)
        :condition (and 
            (at start (and 
                    (not_carrying ?a ?c) 
                    (is_red_available ?c) 
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
    
    ;; the black resource cannot be picked with any other resource
    (:durative-action pick_up_black_resource
        :parameters (?a - actor ?l - node ?c - color)
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
    
    ;; depost the resource in the site
    (:durative-action deposit
        :parameters (?a - actor ?l - node ?c - color ?t - task)
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
    
    ;; construct the building
    (:durative-action construct_building
        :parameters (?a - actor ?l - node ?t - task)
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