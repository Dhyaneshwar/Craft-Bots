(define(problem craft-bots-prob)

(:domain craft-bots)

(:objects
	;; Declaring the objects for the problem
	a32 a34 a33 - actor
	t26 t27 t28 t29 t30 t31 - task
	n0 n1 n3 n5 n7 n9 n12 n15 n17 n22 - node
	m37 m35 m36 m38 m39 - mine
	red blue orange black green - color
)

(:init
	;; setting the initial node for each actor
	(actor_location a32 n0)
	(is_not_working a32)
	(no_resource_to_pick a32)
	(= (total_resource_in_inventory a32) 0)

	(actor_location a34 n7)
	(is_not_working a34)
	(no_resource_to_pick a34)
	(= (total_resource_in_inventory a34) 0)

	(actor_location a33 n9)
	(is_not_working a33)
	(no_resource_to_pick a33)
	(= (total_resource_in_inventory a33) 0)


	;; setting the connection between each nodes
	(connected n1 n0)	(connected n0 n1)
	(connected n3 n1)	(connected n1 n3)
	(connected n5 n3)	(connected n3 n5)
	(connected n17 n3)	(connected n3 n17)
	(connected n22 n3)	(connected n3 n22)
	(connected n7 n5)	(connected n5 n7)
	(connected n9 n5)	(connected n5 n9)
	(connected n12 n5)	(connected n5 n12)
	(connected n17 n5)	(connected n5 n17)
	(connected n9 n7)	(connected n7 n9)
	(connected n12 n9)	(connected n9 n12)
	(connected n15 n12)	(connected n12 n15)
	(connected n17 n12)	(connected n12 n17)
	(connected n17 n15)	(connected n15 n17)
	(connected n22 n15)	(connected n15 n22)
	(connected n22 n17)	(connected n17 n22)

	;; setting the mines details
	(mine_detail m37 n1 orange)
	(mine_detail m35 n12 red)
	(mine_detail m36 n15 blue)
	(mine_detail m38 n15 black)
	(mine_detail m39 n17 green)

	;; set the variables to track the progress of the tasks
	(is_task_available t26)
	(site_not_created t26 n5)
	(building_not_built t26 n5)

	(is_task_available t27)
	(site_not_created t27 n17)
	(building_not_built t27 n17)

	(is_task_available t28)
	(site_not_created t28 n15)
	(building_not_built t28 n15)

	(is_task_available t29)
	(site_not_created t29 n0)
	(building_not_built t29 n0)

	(is_task_available t30)
	(site_not_created t30 n17)
	(building_not_built t30 n17)

	(is_task_available t31)
	(site_not_created t31 n9)
	(building_not_built t31 n9)


	;; set function to count the number of resources carried by the actor
	(= (count_of_resource_carried a32 red) 0)
	(= (count_of_resource_carried a32 blue) 0)
	(= (count_of_resource_carried a32 orange) 0)
	(= (count_of_resource_carried a32 black) 0)
	(= (count_of_resource_carried a32 green) 0)

	(= (count_of_resource_carried a34 red) 0)
	(= (count_of_resource_carried a34 blue) 0)
	(= (count_of_resource_carried a34 orange) 0)
	(= (count_of_resource_carried a34 black) 0)
	(= (count_of_resource_carried a34 green) 0)

	(= (count_of_resource_carried a33 red) 0)
	(= (count_of_resource_carried a33 blue) 0)
	(= (count_of_resource_carried a33 orange) 0)
	(= (count_of_resource_carried a33 black) 0)
	(= (count_of_resource_carried a33 green) 0)

	;; set function to count total and individual resources required for a task
	(= (total_resource_required t26 n5) 2)
	(= (individual_resource_required t26 orange) 1)
	(= (individual_resource_required t26 black) 1)

	(= (total_resource_required t27 n17) 4)
	(= (individual_resource_required t27 orange) 1)
	(= (individual_resource_required t27 black) 3)

	(= (total_resource_required t28 n15) 1)
	(= (individual_resource_required t28 orange) 1)

	(= (total_resource_required t29 n0) 6)
	(= (individual_resource_required t29 red) 2)
	(= (individual_resource_required t29 blue) 2)
	(= (individual_resource_required t29 green) 2)

	(= (total_resource_required t30 n17) 2)
	(= (individual_resource_required t30 blue) 1)
	(= (individual_resource_required t30 green) 1)

	(= (total_resource_required t31 n9) 5)
	(= (individual_resource_required t31 red) 2)
	(= (individual_resource_required t31 blue) 2)
	(= (individual_resource_required t31 green) 1)

)

(:goal
	;; setting the goal for each task
	(and
		(building_built t26 n5)
		(building_built t27 n17)
		(building_built t28 n15)
		(building_built t29 n0)
		(building_built t30 n17)
		(building_built t31 n9)
)))
