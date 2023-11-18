(define(problem craft-bots-prob)

(:domain craft-bots)

(:objects
	;; Declaring the objects for the problem
	a29 a27 a28 - actor
	t21 t22 t23 t24 t25 t26 - task
	n0 n1 n3 n5 n7 n9 n11 n13 n16 n18 - node
	m30 m32 m31 m34 m33 - mine
	red blue orange black green - color
)

(:init
	;; setting the initial node for each actor
	(actor_location a29 n9)
	(is_not_working a29)
	(no_resource_to_pick a29)
	(= (total_resource_in_inventory a29) 0)

	(actor_location a27 n13)
	(is_not_working a27)
	(no_resource_to_pick a27)
	(= (total_resource_in_inventory a27) 0)

	(actor_location a28 n18)
	(is_not_working a28)
	(no_resource_to_pick a28)
	(= (total_resource_in_inventory a28) 0)


	;; setting the connection between each nodes
	(connected n1 n0)	(connected n0 n1)
	(connected n3 n1)	(connected n1 n3)
	(connected n5 n3)	(connected n3 n5)
	(connected n7 n5)	(connected n5 n7)
	(connected n18 n5)	(connected n5 n18)
	(connected n9 n7)	(connected n7 n9)
	(connected n11 n9)	(connected n9 n11)
	(connected n13 n9)	(connected n9 n13)
	(connected n13 n11)	(connected n11 n13)
	(connected n16 n13)	(connected n13 n16)
	(connected n18 n16)	(connected n16 n18)

	;; setting the mines details
	(mine_detail m30 n0 red)
	(mine_detail m32 n1 orange)
	(mine_detail m31 n5 blue)
	(mine_detail m34 n9 green)
	(mine_detail m33 n13 black)

	;; set the variables to track the progress of the tasks
	(is_task_available t21)
	(site_not_created t21 n1)
	(building_not_built t21 n1)

	(is_task_available t22)
	(site_not_created t22 n1)
	(building_not_built t22 n1)

	(is_task_available t23)
	(site_not_created t23 n9)
	(building_not_built t23 n9)

	(is_task_available t24)
	(site_not_created t24 n18)
	(building_not_built t24 n18)

	(is_task_available t25)
	(site_not_created t25 n0)
	(building_not_built t25 n0)

	(is_task_available t26)
	(site_not_created t26 n9)
	(building_not_built t26 n9)


	;; set function to count the number of resources carried by the actor
	(= (count_of_resource_carried a29 red) 0)
	(= (count_of_resource_carried a29 blue) 0)
	(= (count_of_resource_carried a29 orange) 0)
	(= (count_of_resource_carried a29 black) 0)
	(= (count_of_resource_carried a29 green) 0)

	(= (count_of_resource_carried a27 red) 0)
	(= (count_of_resource_carried a27 blue) 0)
	(= (count_of_resource_carried a27 orange) 0)
	(= (count_of_resource_carried a27 black) 0)
	(= (count_of_resource_carried a27 green) 0)

	(= (count_of_resource_carried a28 red) 0)
	(= (count_of_resource_carried a28 blue) 0)
	(= (count_of_resource_carried a28 orange) 0)
	(= (count_of_resource_carried a28 black) 0)
	(= (count_of_resource_carried a28 green) 0)

	;; set function to count total and individual resources required for a task
	(= (total_resource_required t21 n1) 4)
	(= (individual_resource_required t21 blue) 2)
	(= (individual_resource_required t21 orange) 1)
	(= (individual_resource_required t21 black) 1)

	(= (total_resource_required t22 n1) 3)
	(= (individual_resource_required t22 red) 1)
	(= (individual_resource_required t22 black) 1)
	(= (individual_resource_required t22 green) 1)

	(= (total_resource_required t23 n9) 4)
	(= (individual_resource_required t23 red) 1)
	(= (individual_resource_required t23 orange) 2)
	(= (individual_resource_required t23 black) 1)

	(= (total_resource_required t24 n18) 1)
	(= (individual_resource_required t24 black) 1)

	(= (total_resource_required t25 n0) 4)
	(= (individual_resource_required t25 black) 2)
	(= (individual_resource_required t25 green) 2)

	(= (total_resource_required t26 n9) 2)
	(= (individual_resource_required t26 orange) 1)
	(= (individual_resource_required t26 black) 1)

)

(:goal
	;; setting the goal for each task
	(and
		(building_built t21 n1)
		(building_built t22 n1)
		(building_built t23 n9)
		(building_built t24 n18)
		(building_built t25 n0)
		(building_built t26 n9)
)))
