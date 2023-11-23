;; Domain file for the normal flow

(define (domain craft-bots)

    (:requirements :strips :typing :numeric-fluents)

    (:types
        actor node mine task color - object
    )

    (:predicates

        (actor_location ?a - actor ?l - node)

        (is_not_working ?a - actor)
        (is_working ?a - actor ?t - task)

        (pick_resource ?a - actor)
        (no_resource_to_pick ?a - actor)

        (connected ?l1 - node ?l2 - node)

        (mine_detail ?m - mine ?l - node ?c - color)
        (resource_location ?t - task ?l - node ?c - color)
        
        (create_site ?t - task ?l - node)
        (site_not_created ?t - task ?l - node)
        
        (building_built ?t - task ?l - node)
        (building_not_built ?t - task ?l - node)

        (is_task_available ?t - task)
        (is_task_not_available ?t - task)
    )

    (:functions
        (individual_resource_required ?t - task ?c - color)
        (count_of_resource_carried ?a - actor ?c - color)
        (total_resource_required ?t - task ?l - node)
        (total_resource_in_inventory ?a - actor)
    )
    
    ;; When two nodes in the graph are linked, the agent can move between them
    (:action move_between_nodes
        :parameters (?a - actor ?l1 ?l2 - node)
        :precondition (and 
            (actor_location ?a ?l1) 
            (connected ?l1 ?l2)
            (no_resource_to_pick ?a)
        )
        :effect (and 
            (not (actor_location ?a ?l1))
            (actor_location ?a ?l2)
        )
    )

    ;; When the actor (without any task assigned) is in mine, then the resource is digged and that task is assigned to the actor
    (:action assign_task_and_mine
        :parameters (?a - actor ?t - task ?l - node ?c - color ?m - mine)
        :precondition (and 
            (actor_location ?a ?l) 
            (mine_detail ?m ?l ?c)
            (is_not_working ?a)
            (> (individual_resource_required ?t ?c) 0)
            (is_task_available ?t)
            (no_resource_to_pick ?a)
        )
        :effect (and 
            (not (is_not_working ?a))
            (is_working ?a ?t)
            (not (is_task_available ?t))
            (is_task_not_available ?t)
            (resource_location ?t ?l ?c)
            (pick_resource ?a)
            (not (no_resource_to_pick ?a))
        )
    )

    ;; When the actor working on a specific task is in mine, then the resource required for that task is digged
    (:action mine_resource_for_task
        :parameters (?a - actor ?t - task ?l - node ?c - color ?m - mine)
        :precondition (and 
            (actor_location ?a ?l) 
            (mine_detail ?m ?l ?c)
            (is_working ?a ?t)
            (> (individual_resource_required ?t ?c) 0)
            (is_task_not_available ?t)
            (no_resource_to_pick ?a)
        )
        :effect (and 
            (resource_location ?t ?l ?c)
            (pick_resource ?a)
            (not (no_resource_to_pick ?a))
        )
    )

    ;; actor collects the resource from the same node and adds it to its inventory
    (:action pick_up_resource
        :parameters (?a - actor ?t - task ?l - node ?c - color)
        :precondition (and 
            (actor_location ?a ?l) 
            (resource_location ?t ?l ?c) 
            (pick_resource ?a)
            (is_working ?a ?t)
            (> (individual_resource_required ?t ?c) 0)
            (< (count_of_resource_carried ?a ?c) (individual_resource_required ?t ?c))
            (<= (total_resource_in_inventory ?a) 7)
        )
        :effect (and 
            (not (resource_location ?t ?l ?c))
            (increase (count_of_resource_carried ?a ?c) 1)
            (increase (total_resource_in_inventory ?a) 1)
            (not (pick_resource ?a))
            (no_resource_to_pick ?a)
        )
    )
    
    ;; create a new site at the node where actor is present
    (:action setup_site
        :parameters (?a - actor ?t - task ?l - node)
        :precondition (and 
            (actor_location ?a ?l) 
            (site_not_created ?t ?l)
            (is_working ?a ?t)
            (no_resource_to_pick ?a)
        )
        :effect (and 
            (create_site ?t ?l) 
            (not (site_not_created ?t ?l))
        )
    )

    ;; actor pops one resource from its inventory and adds it to a site at the current node. Deposited resources cannot be recovered.
    (:action deposit
        :parameters (?a - actor ?t - task ?l - node ?c - color)
        :precondition (and 
            (actor_location ?a ?l) 
            (create_site ?t ?l)
            (is_working ?a ?t)
            (> (total_resource_in_inventory ?a) 0)
            (> (individual_resource_required ?t ?c) 0)
            (> (count_of_resource_carried ?a ?c) 0)
            (> (total_resource_required ?t ?l) 0)
            (no_resource_to_pick ?a)
        )
        :effect (and 
            (decrease (total_resource_in_inventory ?a) 1)
            (decrease (individual_resource_required ?t ?c) 1)
            (decrease (count_of_resource_carried ?a ?c) 1)
            (decrease (total_resource_required ?t ?l) 1)
        )
    )

    ;; Once all the needed the resources are available, the construction is initiated and completed.
    (:action construct_building
        :parameters (?a - actor ?t - task ?l - node)
        :precondition (and 
            (is_working ?a ?t)
            (create_site ?t ?l) 
            (actor_location ?a ?l) 
            (= (total_resource_required ?t ?l) 0)
            (building_not_built ?t ?l)
            (no_resource_to_pick ?a)
        )
        :effect (and 
            (not (building_not_built ?t ?l))
            (building_built ?t ?l)
            (not (is_working ?a ?t))
            (is_not_working ?a)
        )
    )
)