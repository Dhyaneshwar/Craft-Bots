(define(problem craft-bots-prob)

(:domain craft-bots)

(:objects
	a23 a21 a22 - actor
	t18 t19 t20 - task
	n0 n1 n3 n5 n7 n9 n12 n15 - node
	m25 m24 m27 m28 m26 - mine
	red blue orange black green - color
)

(:init
    ;; setting the initial node for each actor
	(actor_location a23 n1)
	(actor_location a21 n3)
	(actor_location a22 n5)

    ;; setting the connection between each nodes
	(connected n1 n0)	(connected n0 n1)
	(connected n3 n1)	(connected n1 n3)
	(connected n5 n3)	(connected n3 n5)
	(connected n7 n5)	(connected n5 n7)
	(connected n9 n5)	(connected n5 n9)
	(connected n9 n7)	(connected n7 n9)
	(connected n12 n7)	(connected n7 n12)
	(connected n12 n9)	(connected n9 n12)
	(connected n15 n9)	(connected n9 n15)
	(connected n15 n12)	(connected n12 n15)

    ;; setting the mines details
	(mine_detail m25 n1 blue)
	(mine_detail m24 n5 red)
	(mine_detail m27 n5 black)
	(mine_detail m28 n5 green)
	(mine_detail m26 n9 orange)

    ;; set the variables site_not_created
	(site_not_created n9 t18)
	(site_not_created n5 t19)
	(site_not_created n3 t20)

    ;; set the variables not_carrying
	(not_carrying a23 red)
	(not_carrying a23 blue)
	(not_carrying a23 orange)
	(not_carrying a23 black)
	(not_carrying a23 green)

	(not_carrying a21 red)
	(not_carrying a21 blue)
	(not_carrying a21 orange)
	(not_carrying a21 black)
	(not_carrying a21 green)

	(not_carrying a22 red)
	(not_carrying a22 blue)
	(not_carrying a22 orange)
	(not_carrying a22 black)
	(not_carrying a22 green)


    ;; set the resource_count function
	(= (total_resource_required t20 n3) 4)
	(= (resource_count t18 red n9) 2)
	(= (resource_count t18 blue n9) 0)
	(= (resource_count t18 orange n9) 0)
	(= (resource_count t18 black n9) 2)
	(= (resource_count t18 green n9) 0)

	(= (total_resource_required t18 n9) 5)
	(= (resource_count t19 red n5) 1)
	(= (resource_count t19 blue n5) 1)
	(= (resource_count t19 orange n5) 2)
	(= (resource_count t19 black n5) 1)
	(= (resource_count t19 green n5) 0)

	(= (total_resource_required t19 n5) 4)
	(= (resource_count t20 red n3) 1)
	(= (resource_count t20 blue n3) 2)
	(= (resource_count t20 orange n3) 0)
	(= (resource_count t20 black n3) 0)
	(= (resource_count t20 green n3) 1)


	(= (total_resource_in_inventory a23) 0)
	(= (total_resource_in_inventory a21) 0)
	(= (total_resource_in_inventory a22) 0)
)

(:goal
	(and
		(building_built t18 n9)
		(building_built t19 n5)
		(building_built t20 n3)
)))
