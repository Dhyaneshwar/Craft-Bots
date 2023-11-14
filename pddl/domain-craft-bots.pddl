;; domain file for assignment-1 part-1

(define (domain craft-bots)

    (:requirements :strips :typing :numeric-fluents :negative-preconditions)

    (:types
        actor node mine task color - object
    )

    (:predicates
        (actor_location ?a - actor ?l - node)
        (connected ?l1 - node ?l2 - node)

        (mine_detail ?m - mine ?l - node ?c - color)
        (resource_location ?l - node ?c - color)

        (create_site ?l - node ?t - task)
        (site_not_created ?l - node ?t - task)
        
        (carrying ?a - actor ?c - color)
        (not_carrying ?a - actor ?c - color)

        (deposited ?a - actor ?c - color ?l - node)

        (building_built ?t - task ?l - node)
    )

    (:functions
        (resource_count ?t - task ?c - color ?l - node)
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
    (:action mine_resource
        :parameters (?a - actor ?m - mine ?l - node ?c - color)
        :precondition (and 
            (actor_location ?a ?l) 
            (mine_detail ?m ?l ?c)
        )
        :effect (and 
            (resource_location ?l ?c)
        )
    )

    ;; agent collects a resource on the ground in the same node and adds it to the agent's inventory
    (:action pick_up_resource
        :parameters (?a - actor ?l - node ?c - color)
        :precondition (and 
            (actor_location ?a ?l) 
            (resource_location ?l ?c) 
            (not_carrying ?a ?c)
            (<= (total_resource_in_inventory ?a) 3)
        )
        :effect (and 
            (not (not_carrying ?a ?c))
            (not (resource_location ?l ?c))
            (carrying ?a ?c)
            (increase (total_resource_in_inventory ?a) 1)
        )
    )

    ; (:action drop
    ;     :parameters (?a - actor ?l - node ?c - color)
    ;     :precondition (and 
    ;         (actor_location ?a ?l)
    ;         (carrying ?a ?c)
    ;         (>= (total_resource_in_inventory ?a) 1)
    ;     )
    ;     :effect (and 
    ;         (resource_location ?l ?c)
    ;         (not_deposited ?a ?c ?l)
    ;         (not_carrying ?a ?c)
    ;         (not (carrying ?a ?c))
    ;         (decrease (total_resource_in_inventory ?a) 1)
    ;     )
    ; )
    
    ;; create a new site at the given node and add it to the list of sites
    (:action setup_site
        :parameters (?a - actor ?l - node ?t - task)
        :precondition (and 
            (actor_location ?a ?l) 
            (site_not_created ?l ?t)
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
            (carrying ?a ?c)
            (>= (total_resource_in_inventory ?a) 1)
            (> (resource_count ?t ?c ?l) 0)
        )
        :effect (and 
            (deposited ?a ?c ?l) 
            (not_carrying ?a ?c)
            (not (carrying ?a ?c)) 
            (decrease (total_resource_in_inventory ?a) 1)
            (decrease (resource_count ?t ?c ?l) 1)
            (decrease (total_resource_required ?t ?l) 1)
        )
    )

    ;; progresses the completion of a site at the current node. The completion is bounded by the fraction of required resources 
    ;; that have been deposited. Once complete, the site will transform into a completed building
    (:action construct_building
        :parameters (?a - actor ?t - task ?l - node)
        :precondition (and 
            (create_site ?l ?t) 
            (actor_location ?a ?l) 
            (= (total_resource_required ?t ?l) 0)
        )
        :effect (and 
            (building_built ?t ?l)
        )
    )
)