;; domain file for assignment-1 part-1

(define (domain craft-bots)

    (:requirements :strips :typing :numeric-fluents :negative-preconditions :disjunctive-preconditions)

    (:types
        actor node mine task color - object
    )

    (:predicates
        (actor_location ?a - actor ?l - node)
        (is_not_working ?a - actor)
        (is_working ?a - actor ?t - task)
        (connected ?l1 - node ?l2 - node)

        (mine_detail ?m - mine ?l - node ?c - color)

        (create_site ?l - node ?t - task)
        (site_not_created ?l - node ?t - task)
        
        (deposited ?a - actor ?c - color ?l - node)

        (building_built ?t - task ?l - node)
        (building_not_built ?t - task ?l - node)

        (is_task_available ?t - task)
    )

    (:functions
        (resource_count ?t - task ?c - color)
        (carrying_color ?a - actor ?c - color)
        (total_resource_required ?t - task ?l - node)
        (total_resource_in_inventory ?a - actor)
    )
    
    ;; When two nodes in the graph are linked, the agent can move between them
    (:action move_between_nodes
        :parameters (?a - actor ?l1 ?l2 - node)
        :precondition (and 
            (actor_location ?a ?l1) 
            (connected ?l1 ?l2)
        )
        :effect (and 
            (not (actor_location ?a ?l1))
            (actor_location ?a ?l2)
        )
    )

    ;; when the agent is at a node that contains a mine, the agent produces one resource of the mine's resource type. Then the resource appears on the ground at that node
    (:action mine_and_pick_resource
        :parameters (?a - actor ?m - mine ?l - node ?c - color ?t - task)
        :precondition (and 
            (actor_location ?a ?l) 
            (mine_detail ?m ?l ?c)
            (is_not_working ?a)
            (> (resource_count ?t ?c) 0)
            (is_task_available ?t)
        )
        :effect (and 
            (not (is_not_working ?a))
            (is_working ?a ?t)
            (not (is_task_available ?t))
            (increase (carrying_color ?a ?c) 1)
            (increase (total_resource_in_inventory ?a) 1)
        )
    )

    (:action mine_and_pick_resource_for_task
        :parameters (?a - actor ?m - mine ?l - node ?c - color ?t - task)
        :precondition (and 
            (actor_location ?a ?l) 
            (mine_detail ?m ?l ?c)
            (is_working ?a ?t)
            (> (resource_count ?t ?c) 0)
            (< (carrying_color ?a ?c) (resource_count ?t ?c))
            (<= (total_resource_in_inventory ?a) 7)
        )
        :effect (and 
            (increase (carrying_color ?a ?c) 1)
            (increase (total_resource_in_inventory ?a) 1)
        )
    )
    
    ;; create a new site at the given node and add it to the list of sites
    (:action setup_site
        :parameters (?a - actor ?l - node ?t - task)
        :precondition (and 
            (actor_location ?a ?l) 
            (site_not_created ?l ?t)
            (is_working ?a ?t)
        )
        :effect (and 
            (create_site ?l ?t) 
            (not (site_not_created ?l ?t))
        )
    )

    ;; agent removes one resource from its inventory and adds it to a site at the current node. 
    ;; resources cannot be recovered once deposited into a site
    (:action deposit
        :parameters (?a - actor ?t - task ?l - node ?c - color)
        :precondition (and 
            (actor_location ?a ?l) 
            (create_site ?l ?t)
            (is_working ?a ?t)
            (> (total_resource_in_inventory ?a) 0)
            (> (resource_count ?t ?c) 0)
            (> (carrying_color ?a ?c) 0)
            (> (total_resource_required ?t ?l) 0)
        )
        :effect (and 
            (deposited ?a ?c ?l) 
            (decrease (total_resource_in_inventory ?a) 1)
            (decrease (resource_count ?t ?c) 1)
            (decrease (carrying_color ?a ?c) 1)
            (decrease (total_resource_required ?t ?l) 1)
        )
    )

    ;; progresses the completion of a site at the current node. The completion is bounded by the fraction of required resources 
    ;; that have been deposited. Once complete, the site will transform into a completed building
    (:action construct_building
        :parameters (?a - actor ?t - task ?l - node)
        :precondition (and 
            (is_working ?a ?t)
            (create_site ?l ?t) 
            (actor_location ?a ?l) 
            (= (total_resource_required ?t ?l) 0)
            (building_not_built ?t ?l)
        )
        :effect (and 
            (not (building_not_built ?t ?l))
            (building_built ?t ?l)
            (not (is_working ?a ?t))
            (is_not_working ?a)
        )
    )
)