(define(problem craft-bots-prob)

(:domain craft-bots)

(:objects
	;; Declaring the objects for the problem
	a31 a33 a32 - actor
	t25 t26 t27 t28 t29 t30 - task
	n0 n1 n3 n6 n9 n11 n13 n16 n18 n21 - node
	m34 m35 m36 m38 m37 - mine
	red blue orange black green - color
)

(:init
	;; setting the initial node for each actor
	(actor_location a31 n1)
	(is_not_working a31)
	(no_resource_to_pick a31)
	(= (total_resource_in_inventory a31) 0)

	(actor_location a33 n11)
	(is_not_working a33)
	(no_resource_to_pick a33)
	(= (total_resource_in_inventory a33) 0)

	(actor_location a32 n18)
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
	(connected n13 n9)	(connected n9 n13)
	(connected n13 n11)	(connected n11 n13)
	(connected n21 n11)	(connected n11 n21)
	(connected n16 n13)	(connected n13 n16)
	(connected n18 n13)	(connected n13 n18)
	(connected n21 n13)	(connected n13 n21)
	(connected n18 n16)	(connected n16 n18)
	(connected n21 n18)	(connected n18 n21)

	;; setting the mines details
	(mine_detail m34 n0 red)
	(mine_detail m35 n1 blue)
	(mine_detail m36 n16 orange)
	(mine_detail m38 n18 green)
	(mine_detail m37 n21 black)

	;; set the variables to track the progress of the tasks
	(is_task_available t25)
	(site_not_created t25 n1)
	(building_not_built t25 n1)

	(is_task_available t26)
	(site_not_created t26 n18)
	(building_not_built t26 n18)

	(is_task_available t27)
	(site_not_created t27 n18)
	(building_not_built t27 n18)

	(is_task_available t28)
	(site_not_created t28 n11)
	(building_not_built t28 n11)

	(is_task_available t29)
	(site_not_created t29 n21)
	(building_not_built t29 n21)

	(is_task_available t30)
	(site_not_created t30 n13)
	(building_not_built t30 n13)


	;; set function to count the number of resources carried by the actor
	(= (count_of_resource_carried a31 red) 0)
	(= (count_of_resource_carried a31 blue) 0)
	(= (count_of_resource_carried a31 orange) 0)
	(= (count_of_resource_carried a31 black) 0)
	(= (count_of_resource_carried a31 green) 0)

	(= (count_of_resource_carried a33 red) 0)
	(= (count_of_resource_carried a33 blue) 0)
	(= (count_of_resource_carried a33 orange) 0)
	(= (count_of_resource_carried a33 black) 0)
	(= (count_of_resource_carried a33 green) 0)

	(= (count_of_resource_carried a32 red) 0)
	(= (count_of_resource_carried a32 blue) 0)
	(= (count_of_resource_carried a32 orange) 0)
	(= (count_of_resource_carried a32 black) 0)
	(= (count_of_resource_carried a32 green) 0)

	;; set function to count total and individual resources required for a task
	(= (total_resource_required t25 n1) 1)
	(= (individual_resource_required t25 black) 1)

	(= (total_resource_required t26 n18) 4)
	(= (individual_resource_required t26 red) 1)
	(= (individual_resource_required t26 orange) 1)
	(= (individual_resource_required t26 black) 1)
	(= (individual_resource_required t26 green) 1)

	(= (total_resource_required t27 n18) 4)
	(= (individual_resource_required t27 red) 2)
	(= (individual_resource_required t27 black) 2)

	(= (total_resource_required t28 n11) 6)
	(= (individual_resource_required t28 red) 1)
	(= (individual_resource_required t28 orange) 1)
	(= (individual_resource_required t28 green) 4)

	(= (total_resource_required t29 n21) 1)
	(= (individual_resource_required t29 black) 1)

	(= (total_resource_required t30 n13) 4)
	(= (individual_resource_required t30 red) 1)
	(= (individual_resource_required t30 blue) 1)
	(= (individual_resource_required t30 orange) 1)
	(= (individual_resource_required t30 black) 1)

)

(:goal
	;; setting the goal for each task
	(and
		(building_built t25 n1)
		(building_built t26 n18)
		(building_built t27 n18)
		(building_built t28 n11)
		(building_built t29 n21)
		(building_built t30 n13)
)))
