(define(problem craft-bots-prob)

(:domain craft-bots)

(:objects
	a33 a32 a31 - actor
	t25 t26 t27 t28 t29 t30 - task
	n0 n1 n3 n6 n8 n10 n12 n14 n16 n22 - node
	m34 m35 m36 m38 m37 - mine
	red blue orange black green - color
)

(:init
    ;; setting the initial node for each actor
	(actor_location a33 n8)
	(is_not_working a33)
	(no_resource_to_pick a33)
	(= (total_resource_in_inventory a33) 0)

	(actor_location a32 n10)
	(is_not_working a32)
	(no_resource_to_pick a32)
	(= (total_resource_in_inventory a32) 0)

	(actor_location a31 n14)
	(is_not_working a31)
	(no_resource_to_pick a31)
	(= (total_resource_in_inventory a31) 0)


    ;; setting the connection between each nodes
	(connected n1 n0)	(connected n0 n1)
	(connected n3 n0)	(connected n0 n3)
	(connected n3 n1)	(connected n1 n3)
	(connected n6 n3)	(connected n3 n6)
	(connected n8 n6)	(connected n6 n8)
	(connected n16 n6)	(connected n6 n16)
	(connected n10 n8)	(connected n8 n10)
	(connected n16 n8)	(connected n8 n16)
	(connected n12 n10)	(connected n10 n12)
	(connected n16 n10)	(connected n10 n16)
	(connected n14 n12)	(connected n12 n14)
	(connected n16 n12)	(connected n12 n16)
	(connected n16 n14)	(connected n14 n16)
	(connected n22 n14)	(connected n14 n22)
	(connected n22 n16)	(connected n16 n22)

    ;; setting the mines details
	(mine_detail m34 n3 red)
	(mine_detail m35 n6 blue)
	(mine_detail m36 n10 orange)
	(mine_detail m38 n12 green)
	(mine_detail m37 n16 black)

    ;; set the variables site_not_created
	(is_task_available t25)
	(site_not_created n8 t25)
	(building_not_built t25 n8)

	(is_task_available t26)
	(site_not_created n3 t26)
	(building_not_built t26 n3)

	(is_task_available t27)
	(site_not_created n6 t27)
	(building_not_built t27 n6)

	(is_task_available t28)
	(site_not_created n6 t28)
	(building_not_built t28 n6)

	(is_task_available t29)
	(site_not_created n16 t29)
	(building_not_built t29 n16)

	(is_task_available t30)
	(site_not_created n0 t30)
	(building_not_built t30 n0)


    ;; set the variables not_carrying
	(= (carrying_color a33 red) 0)
	(= (carrying_color a33 blue) 0)
	(= (carrying_color a33 orange) 0)
	(= (carrying_color a33 black) 0)
	(= (carrying_color a33 green) 0)

	(= (carrying_color a32 red) 0)
	(= (carrying_color a32 blue) 0)
	(= (carrying_color a32 orange) 0)
	(= (carrying_color a32 black) 0)
	(= (carrying_color a32 green) 0)

	(= (carrying_color a31 red) 0)
	(= (carrying_color a31 blue) 0)
	(= (carrying_color a31 orange) 0)
	(= (carrying_color a31 black) 0)
	(= (carrying_color a31 green) 0)

    ;; set the resource_count function
	(= (total_resource_required t25 n8) 5)
	(= (resource_count t25 blue) 1)
	(= (resource_count t25 orange) 2)
	(= (resource_count t25 green) 2)

	(= (total_resource_required t26 n3) 4)
	(= (resource_count t26 red) 1)
	(= (resource_count t26 blue) 2)
	(= (resource_count t26 green) 1)

	(= (total_resource_required t27 n6) 1)
	(= (resource_count t27 orange) 1)

	(= (total_resource_required t28 n6) 2)
	(= (resource_count t28 green) 2)

	(= (total_resource_required t29 n16) 5)
	(= (resource_count t29 red) 2)
	(= (resource_count t29 blue) 1)
	(= (resource_count t29 black) 2)

	(= (total_resource_required t30 n0) 4)
	(= (resource_count t30 red) 1)
	(= (resource_count t30 blue) 2)
	(= (resource_count t30 black) 1)

)

(:goal
	(and
		(building_built t25 n8)
		(building_built t26 n3)
		(building_built t27 n6)
		(building_built t28 n6)
		(building_built t29 n16)
		(building_built t30 n0)
)))
