(define(problem craft-bots-prob)

(:domain craft-bots)

(:objects
	a29 a28 a27 - actor
	t21 t22 t23 t24 t25 t26 - task
	n0 n1 n3 n5 n7 n10 n12 n14 n16 n18 - node
	m32 m34 m30 m33 m31 - mine
	red blue orange black green - color
)

(:init
    ;; setting the initial node for each actor
	(actor_location a29 n7)
	(is_not_working a29)
	(= (total_resource_in_inventory a29) 0)

	(actor_location a28 n12)
	(is_not_working a28)
	(= (total_resource_in_inventory a28) 0)

	(actor_location a27 n14)
	(is_not_working a27)
	(= (total_resource_in_inventory a27) 0)


    ;; setting the connection between each nodes
	(connected n1 n0)	(connected n0 n1)
	(connected n3 n1)	(connected n1 n3)
	(connected n5 n3)	(connected n3 n5)
	(connected n7 n3)	(connected n3 n7)
	(connected n7 n5)	(connected n5 n7)
	(connected n10 n7)	(connected n7 n10)
	(connected n12 n10)	(connected n10 n12)
	(connected n14 n12)	(connected n12 n14)
	(connected n16 n14)	(connected n14 n16)
	(connected n18 n14)	(connected n14 n18)
	(connected n18 n16)	(connected n16 n18)

    ;; setting the mines details
	(mine_detail m32 n1 orange)
	(mine_detail m34 n1 green)
	(mine_detail m30 n5 red)
	(mine_detail m33 n14 black)
	(mine_detail m31 n18 blue)

    ;; set the variables site_not_created
	(site_not_created n7 t21)
	(site_not_created n5 t22)
	(site_not_created n14 t23)
	(site_not_created n10 t24)
	(site_not_created n5 t25)
	(site_not_created n10 t26)

    ;; set the variables not_carrying
	(not_carrying a29 red)
	(not_carrying a29 blue)
	(not_carrying a29 orange)
	(not_carrying a29 black)
	(not_carrying a29 green)

	(not_carrying a28 red)
	(not_carrying a28 blue)
	(not_carrying a28 orange)
	(not_carrying a28 black)
	(not_carrying a28 green)

	(not_carrying a27 red)
	(not_carrying a27 blue)
	(not_carrying a27 orange)
	(not_carrying a27 black)
	(not_carrying a27 green)

    ;; set the resource_count function
	(= (total_resource_required t21 n7) 6)
	(building_not_built t21 n7)
	(is_task_available t21)
	(= (resource_count t21 blue) 2)
	(= (resource_count t21 black) 3)
	(= (resource_count t21 green) 1)

	(= (total_resource_required t22 n5) 2)
	(building_not_built t22 n5)
	(is_task_available t22)
	(= (resource_count t22 blue) 1)
	(= (resource_count t22 black) 1)

	(= (total_resource_required t23 n14) 1)
	(building_not_built t23 n14)
	(is_task_available t23)
	(= (resource_count t23 blue) 1)

	(= (total_resource_required t24 n10) 1)
	(building_not_built t24 n10)
	(is_task_available t24)
	(= (resource_count t24 black) 1)

	(= (total_resource_required t25 n5) 4)
	(building_not_built t25 n5)
	(is_task_available t25)
	(= (resource_count t25 red) 1)
	(= (resource_count t25 blue) 2)
	(= (resource_count t25 orange) 1)

	(= (total_resource_required t26 n10) 5)
	(building_not_built t26 n10)
	(is_task_available t26)
	(= (resource_count t26 red) 1)
	(= (resource_count t26 black) 2)
	(= (resource_count t26 green) 2)

)

(:goal
	(and
		(building_built t21 n7)
		(building_built t22 n5)
		(building_built t23 n14)
		(building_built t24 n10)
		(building_built t25 n5)
		(building_built t26 n10)
)))
