(define(problem craft-bots-prob)

(:domain craft-bots)

(:objects
	a14 a15 a16 - actor
	t11 t12 t13 - task
	n0 n1 n3 n6 n8 - node
	m19 m21 m20 m18 m17 - mine
	red blue orange black green - color
)

(:init
    ;; setting the initial node for each actor
	(actor_location a14 n0)
	(is_not_working a14)
	(= (total_resource_in_inventory a14) 0)

	(actor_location a15 n1)
	(is_not_working a15)
	(= (total_resource_in_inventory a15) 0)

	(actor_location a16 n8)
	(is_not_working a16)
	(= (total_resource_in_inventory a16) 0)


    ;; setting the connection between each nodes
	(connected n1 n0)	(connected n0 n1)
	(connected n3 n0)	(connected n0 n3)
	(connected n3 n1)	(connected n1 n3)
	(connected n6 n3)	(connected n3 n6)
	(connected n8 n3)	(connected n3 n8)
	(connected n8 n6)	(connected n6 n8)

    ;; setting the mines details
	(mine_detail m19 n0 orange)
	(mine_detail m21 n0 green)
	(mine_detail m20 n1 black)
	(mine_detail m18 n3 blue)
	(mine_detail m17 n8 red)

    ;; set the variables site_not_created
	(site_not_created n1 t11)
	(site_not_created n0 t12)
	(site_not_created n8 t13)

    ;; set the variables not_carrying
	(not_carrying a14 red)
	(not_carrying a14 blue)
	(not_carrying a14 orange)
	(not_carrying a14 black)
	(not_carrying a14 green)

	(not_carrying a15 red)
	(not_carrying a15 blue)
	(not_carrying a15 orange)
	(not_carrying a15 black)
	(not_carrying a15 green)

	(not_carrying a16 red)
	(not_carrying a16 blue)
	(not_carrying a16 orange)
	(not_carrying a16 black)
	(not_carrying a16 green)

    ;; set the resource_count function
	(= (total_resource_required t11 n1) 2)
	(building_not_built t11 n1)
	(= (resource_count t11 green) 2)

	(= (total_resource_required t12 n0) 1)
	(building_not_built t12 n0)
	(= (resource_count t12 orange) 1)

	(= (total_resource_required t13 n8) 1)
	(building_not_built t13 n8)
	(= (resource_count t13 blue) 1)

)

(:goal
	(and
		(building_built t11 n1)
		(building_built t12 n0)
		(building_built t13 n8)
)))
