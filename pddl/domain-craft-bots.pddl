;; domain file for assignment-1 part-1

(define (domain craft-bots)

    (:requirements :strips :typing :numeric-fluents :negative-preconditions)

    (:types
        actor node resource building site mine edge task color - object
    )

    (:predicates
        (actor_location ?a - actor ?l - node)
        (connected ?l1 - node ?l2 - node)

        (mine_detail ?m - mine ?l - node ?c - color)
        (resource_location ?l - node ?c - color)

        (create_site ?l - node ?t - task)
        (not_created_site ?l - node ?t - task)
        
        (carrying ?a - actor ?c - color)
        (not_carrying ?a - actor ?c - color)

        (deposited ?a - actor ?t - task ?c - color ?l - node)
        (not_deposited ?a - actor ?t - task ?c - color ?l - node)
    )

    (:functions
        (resource_count ?t - task ?c - color ?l - node)
    )
    
    ;; When two nodes in the graph are linked, the agent can move between them
    (:action move
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
    (:action dig
        :parameters (?a - actor ?m - mine ?l - node ?c - color)
        :precondition (and (actor_location ?a ?l) (mine_detail ?m ?l ?c))
        :effect (and (resource_location ?l ?c))
    )

    ;; agent collects a resource on the ground in the same node and adds it to the agent's inventory
    (:action pick-up
        :parameters (?a - actor ?l - node ?c - color)
        :precondition (and (actor_location ?a ?l) (resource_location ?l ?c) (not_carrying ?a ?c))
        :effect (and (carrying ?a ?c) (not (resource_location ?l ?c)) (not (not_carrying ?a ?c)))
    )

    ;; create a new site at the given node and add it to the list of sites
    (:action create-site
        :parameters (?a - actor ?l - node ?t - task)
        :precondition (and (actor_location ?a ?l) (not_created_site ?l ?t))
        :effect (and (create_site ?l ?t) (not (not_created_site ?l ?t)))
    )

    ;; agent removes one resource from its inventory and adds it to a site at the current node. 
    ;; resources cannot be recovered once deposited into a site
    (:action deposit
        :parameters (?a - actor ?t - task ?l - node ?c - color)
        :precondition (and (actor_location ?a ?l) (carrying ?a ?c) (not_deposited ?a ?t ?c ?l) (create_site ?l ?t))
        :effect (and (not (carrying ?a ?c)) (deposited ?a ?t ?c ?l) (not (not_deposited ?a ?t ?c ?l)) (not_carrying ?a ?c))
    )

    ;; progresses the completion of a site at the current node. The completion is bounded by the fraction of required resources 
    ;; that have been deposited. Once complete, the site will transform into a completed building
    (:action construct
        :parameters (?a - actor ?t - task ?l - node ?c - color)
        :precondition (and (actor_location ?a ?l) (deposited ?a ?t ?c ?l) (> (resource_count ?t ?c ?l) 0))
        :effect (and (not (deposited ?a ?t ?c ?l)) (decrease (resource_count ?t ?c ?l) 1) (not_deposited ?a ?t ?c ?l))
    )
)