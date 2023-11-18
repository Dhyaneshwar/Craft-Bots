(define(problem craft-bots-prob)

(:domain craft-bots)

(:objects
	a29 a31 a30 - actor
	t23 t24 t25 t26 t27 t28 - task
	n0 n1 n3 n6 n8 n10 n13 n15 n17 n20 - node
	m33 m34 m35 m32 m36 - mine
	red blue orange black green - color
)

(:init
    ;; setting the initial node for each actor
	(actor_location a29 n0)
	(is_not_working a29)
	(no_resource_to_pick a29)
	(= (total_resource_in_inventory a29) 0)

	(actor_location a31 n0)
	(is_not_working a31)
	(no_resource_to_pick a31)
	(= (total_resource_in_inventory a31) 0)

	(actor_location a30 n10)
	(is_not_working a30)
	(no_resource_to_pick a30)
	(= (total_resource_in_inventory a30) 0)


    ;; setting the connection between each nodes
	(connected n1 n0)	(connected n0 n1)
	(connected n3 n0)	(connected n0 n3)
	(connected n3 n1)	(connected n1 n3)
	(connected n6 n3)	(connected n3 n6)
	(connected n8 n6)	(connected n6 n8)
	(connected n10 n6)	(connected n6 n10)
	(connected n10 n8)	(connected n8 n10)
	(connected n13 n10)	(connected n10 n13)
	(connected n15 n13)	(connected n13 n15)
	(connected n17 n13)	(connected n13 n17)
	(connected n20 n13)	(connected n13 n20)
	(connected n17 n15)	(connected n15 n17)
	(connected n20 n17)	(connected n17 n20)

    ;; setting the mines details
	(mine_detail m33 n1 blue)
	(mine_detail m34 n1 orange)
	(mine_detail m35 n3 black)
	(mine_detail m32 n6 red)
	(mine_detail m36 n20 green)

    ;; set the variables site_not_created
	(is_task_available t23)
	(site_not_created n15 t23)
	(building_not_built t23 n15)

	(is_task_available t24)
	(site_not_created n20 t24)
	(building_not_built t24 n20)

	(is_task_available t25)
	(site_not_created n1 t25)
	(building_not_built t25 n1)

	(is_task_available t26)
	(site_not_created n15 t26)
	(building_not_built t26 n15)

	(is_task_available t27)
	(site_not_created n13 t27)
	(building_not_built t27 n13)

	(is_task_available t28)
	(site_not_created n17 t28)
	(building_not_built t28 n17)


    ;; set the variables not_carrying
	(= (carrying_color a29 red) 0)
	(= (carrying_color a29 blue) 0)
	(= (carrying_color a29 orange) 0)
	(= (carrying_color a29 black) 0)
	(= (carrying_color a29 green) 0)

	(= (carrying_color a31 red) 0)
	(= (carrying_color a31 blue) 0)
	(= (carrying_color a31 orange) 0)
	(= (carrying_color a31 black) 0)
	(= (carrying_color a31 green) 0)

	(= (carrying_color a30 red) 0)
	(= (carrying_color a30 blue) 0)
	(= (carrying_color a30 orange) 0)
	(= (carrying_color a30 black) 0)
	(= (carrying_color a30 green) 0)

    ;; set the resource_count function
	(= (total_resource_required t23 n15) 5)
	(= (resource_count t23 red) 1)
	(= (resource_count t23 black) 1)
	(= (resource_count t23 green) 3)

	(= (total_resource_required t24 n20) 2)
	(= (resource_count t24 red) 1)
	(= (resource_count t24 black) 1)

	(= (total_resource_required t25 n1) 5)
	(= (resource_count t25 red) 1)
	(= (resource_count t25 orange) 2)
	(= (resource_count t25 black) 2)

	(= (total_resource_required t26 n15) 1)
	(= (resource_count t26 blue) 1)

	(= (total_resource_required t27 n13) 2)
	(= (resource_count t27 red) 1)
	(= (resource_count t27 orange) 1)

	(= (total_resource_required t28 n17) 4)
	(= (resource_count t28 red) 1)
	(= (resource_count t28 orange) 3)

)

(:goal
	(and
		(building_built t23 n15)
		(building_built t24 n20)
		(building_built t25 n1)
		(building_built t26 n15)
		(building_built t27 n13)
		(building_built t28 n17)
)))
