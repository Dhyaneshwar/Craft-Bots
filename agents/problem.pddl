(define(problem craft-bots-prob)

(:domain craft-bots)

(:objects
	a28 a29 a30 - actor
	t22 t23 t24 t25 t26 t27 - task
	n0 n1 n3 n5 n7 n9 n11 n13 n16 n18 - node
	m32 m31 m34 m35 m33 - mine
	red blue orange black green - color
)

(:init
    ;; setting the initial node for each actor
	(actor_location a28 n9)
	(is_not_working a28)
	(= (total_resource_in_inventory a28) 0)

	(actor_location a29 n13)
	(is_not_working a29)
	(= (total_resource_in_inventory a29) 0)

	(actor_location a30 n13)
	(is_not_working a30)
	(= (total_resource_in_inventory a30) 0)


    ;; setting the connection between each nodes
	(connected n1 n0)	(connected n0 n1)
	(connected n3 n1)	(connected n1 n3)
	(connected n5 n3)	(connected n3 n5)
	(connected n7 n5)	(connected n5 n7)
	(connected n9 n7)	(connected n7 n9)
	(connected n11 n9)	(connected n9 n11)
	(connected n13 n9)	(connected n9 n13)
	(connected n13 n11)	(connected n11 n13)
	(connected n18 n11)	(connected n11 n18)
	(connected n16 n13)	(connected n13 n16)
	(connected n18 n13)	(connected n13 n18)
	(connected n18 n16)	(connected n16 n18)

    ;; setting the mines details
	(mine_detail m32 n7 blue)
	(mine_detail m31 n16 red)
	(mine_detail m34 n16 black)
	(mine_detail m35 n16 green)
	(mine_detail m33 n18 orange)

    ;; set the variables site_not_created
	(is_task_available t22)
	(site_not_created n18 t22)
	(building_not_built t22 n18)

	(is_task_available t23)
	(site_not_created n13 t23)
	(building_not_built t23 n13)

	(is_task_available t24)
	(site_not_created n16 t24)
	(building_not_built t24 n16)

	(is_task_available t25)
	(site_not_created n11 t25)
	(building_not_built t25 n11)

	(is_task_available t26)
	(site_not_created n1 t26)
	(building_not_built t26 n1)

	(is_task_available t27)
	(site_not_created n16 t27)
	(building_not_built t27 n16)


    ;; set the variables not_carrying
	(= (carrying_color a28 red) 0)
	(= (carrying_color a28 blue) 0)
	(= (carrying_color a28 orange) 0)
	(= (carrying_color a28 black) 0)
	(= (carrying_color a28 green) 0)

	(= (carrying_color a29 red) 0)
	(= (carrying_color a29 blue) 0)
	(= (carrying_color a29 orange) 0)
	(= (carrying_color a29 black) 0)
	(= (carrying_color a29 green) 0)

	(= (carrying_color a30 red) 0)
	(= (carrying_color a30 blue) 0)
	(= (carrying_color a30 orange) 0)
	(= (carrying_color a30 black) 0)
	(= (carrying_color a30 green) 0)

    ;; set the resource_count function
	(= (total_resource_required t22 n18) 3)
	(= (resource_count t22 orange) 2)
	(= (resource_count t22 black) 1)

	(= (total_resource_required t23 n13) 2)
	(= (resource_count t23 blue) 2)

	(= (total_resource_required t24 n16) 5)
	(= (resource_count t24 red) 1)
	(= (resource_count t24 black) 1)
	(= (resource_count t24 green) 3)

	(= (total_resource_required t25 n11) 3)
	(= (resource_count t25 red) 1)
	(= (resource_count t25 orange) 1)
	(= (resource_count t25 black) 1)

	(= (total_resource_required t26 n1) 2)
	(= (resource_count t26 orange) 1)
	(= (resource_count t26 green) 1)

	(= (total_resource_required t27 n16) 3)
	(= (resource_count t27 blue) 1)
	(= (resource_count t27 orange) 2)

)

(:goal
	(and
		(building_built t22 n18)
		(building_built t23 n13)
		(building_built t24 n16)
		(building_built t25 n11)
		(building_built t26 n1)
		(building_built t27 n16)
)))
