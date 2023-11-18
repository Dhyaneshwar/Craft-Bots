(define(problem craft-bots-prob)

(:domain craft-bots)

(:objects
	;; Declaring the objects for the problem
	a31 a30 a32 - actor
	t24 t25 t26 t27 t28 t29 - task
	n0 n1 n3 n6 n9 n11 n13 n15 n17 n20 - node
	m33 m34 m36 m35 m37 - mine
	red blue orange black green - color
)

(:init
	;; setting the initial node for each actor
	(actor_location a31 n0)
	(is_not_working a31)
	(no_resource_to_pick a31)
	(= (total_resource_in_inventory a31) 0)

	(actor_location a30 n13)
	(is_not_working a30)
	(no_resource_to_pick a30)
	(= (total_resource_in_inventory a30) 0)

	(actor_location a32 n15)
	(is_not_working a32)
	(no_resource_to_pick a32)
	(= (total_resource_in_inventory a32) 0)


	;; setting the connection between each nodes
	(connected n1 n0)	(connected n0 n1)
	(connected n3 n0)	(connected n0 n3)
	(connected n6 n0)	(connected n0 n6)
	(connected n3 n1)	(connected n1 n3)
	(connected n6 n3)	(connected n3 n6)
	(connected n9 n6)	(connected n6 n9)
	(connected n11 n9)	(connected n9 n11)
	(connected n13 n11)	(connected n11 n13)
	(connected n15 n13)	(connected n13 n15)
	(connected n17 n13)	(connected n13 n17)
	(connected n20 n13)	(connected n13 n20)
	(connected n17 n15)	(connected n15 n17)
	(connected n20 n15)	(connected n15 n20)
	(connected n20 n17)	(connected n17 n20)

	;; setting the mines details
	(mine_detail m33 n0 red)
	(mine_detail m34 n0 blue)
	(mine_detail m36 n0 black)
	(mine_detail m35 n1 orange)
	(mine_detail m37 n1 green)

	;; set the variables to track the progress of the tasks
	(is_task_available t24)
	(site_not_created t24 n20)
	(building_not_built t24 n20)

	(is_task_available t25)
	(site_not_created t25 n0)
	(building_not_built t25 n0)

	(is_task_available t26)
	(site_not_created t26 n0)
	(building_not_built t26 n0)

	(is_task_available t27)
	(site_not_created t27 n1)
	(building_not_built t27 n1)

	(is_task_available t28)
	(site_not_created t28 n1)
	(building_not_built t28 n1)

	(is_task_available t29)
	(site_not_created t29 n9)
	(building_not_built t29 n9)


	;; set function to count the number of resources carried by the actor
	(= (count_of_resource_carried a31 red) 0)
	(= (count_of_resource_carried a31 blue) 0)
	(= (count_of_resource_carried a31 orange) 0)
	(= (count_of_resource_carried a31 black) 0)
	(= (count_of_resource_carried a31 green) 0)

	(= (count_of_resource_carried a30 red) 0)
	(= (count_of_resource_carried a30 blue) 0)
	(= (count_of_resource_carried a30 orange) 0)
	(= (count_of_resource_carried a30 black) 0)
	(= (count_of_resource_carried a30 green) 0)

	(= (count_of_resource_carried a32 red) 0)
	(= (count_of_resource_carried a32 blue) 0)
	(= (count_of_resource_carried a32 orange) 0)
	(= (count_of_resource_carried a32 black) 0)
	(= (count_of_resource_carried a32 green) 0)

	;; set function to count total and individual resources required for a task
	(= (total_resource_required t24 n20) 2)
	(= (individual_resource_required t24 green) 2)

	(= (total_resource_required t25 n0) 4)
	(= (individual_resource_required t25 red) 1)
	(= (individual_resource_required t25 blue) 1)
	(= (individual_resource_required t25 black) 1)
	(= (individual_resource_required t25 green) 1)

	(= (total_resource_required t26 n0) 2)
	(= (individual_resource_required t26 green) 2)

	(= (total_resource_required t27 n1) 2)
	(= (individual_resource_required t27 orange) 2)

	(= (total_resource_required t28 n1) 3)
	(= (individual_resource_required t28 orange) 1)
	(= (individual_resource_required t28 black) 2)

	(= (total_resource_required t29 n9) 3)
	(= (individual_resource_required t29 red) 1)
	(= (individual_resource_required t29 blue) 1)
	(= (individual_resource_required t29 green) 1)

)

(:goal
	;; setting the goal for each task
	(and
		(building_built t24 n20)
		(building_built t25 n0)
		(building_built t26 n0)
		(building_built t27 n1)
		(building_built t28 n1)
		(building_built t29 n9)
)))
