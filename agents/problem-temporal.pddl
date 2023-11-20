(define(problem craft-bots-temporal-problem)

(:domain craft-bots-temporal)

(:objects
	a28 a26 a27 - actor
	t25 t26 t27 - task
	n0 n1 n3 n5 n7 n9 n11 n14 n19 n22 - location
	m32 m31 m29 m33 m30 - mine
	red blue orange black green - color
)
(:init
	(actor_location a28 n1)
	(= (move_speed a28) 5)
	(is_idle a28)
	(= (total_resource_in_inventory a28) 0)
	
	(actor_location a26 n1)
	(= (move_speed a26) 5)
	(is_idle a26)
	(= (total_resource_in_inventory a26) 0)
	
	(actor_location a27 n1)
	(= (move_speed a27) 5)
	(is_idle a27)
	(= (total_resource_in_inventory a27) 0)

	(connected n1 n0)	(connected n0 n1)
	(= (edge_length n1 n0) 93)	(= (edge_length n0 n1) 93)
	(connected n3 n1)	(connected n1 n3)
	(= (edge_length n3 n1) 84)	(= (edge_length n1 n3) 84)
	(connected n14 n1)	(connected n1 n14)
	(= (edge_length n14 n1) 66)	(= (edge_length n1 n14) 66)
	(connected n19 n1)	(connected n1 n19)
	(= (edge_length n19 n1) 85)	(= (edge_length n1 n19) 85)
	(connected n5 n3)	(connected n3 n5)
	(= (edge_length n5 n3) 79)	(= (edge_length n3 n5) 79)
	(connected n14 n3)	(connected n3 n14)
	(= (edge_length n14 n3) 58)	(= (edge_length n3 n14) 58)
	(connected n7 n5)	(connected n5 n7)
	(= (edge_length n7 n5) 78)	(= (edge_length n5 n7) 78)
	(connected n11 n5)	(connected n5 n11)
	(= (edge_length n11 n5) 79)	(= (edge_length n5 n11) 79)
	(connected n14 n5)	(connected n5 n14)
	(= (edge_length n14 n5) 76)	(= (edge_length n5 n14) 76)
	(connected n9 n7)	(connected n7 n9)
	(= (edge_length n9 n7) 83)	(= (edge_length n7 n9) 83)
	(connected n11 n9)	(connected n9 n11)
	(= (edge_length n11 n9) 82)	(= (edge_length n9 n11) 82)
	(connected n14 n11)	(connected n11 n14)
	(= (edge_length n14 n11) 83)	(= (edge_length n11 n14) 83)
	(connected n22 n11)	(connected n11 n22)
	(= (edge_length n22 n11) 80)	(= (edge_length n11 n22) 80)
	(connected n19 n14)	(connected n14 n19)
	(= (edge_length n19 n14) 83)	(= (edge_length n14 n19) 83)
	(connected n22 n19)	(connected n19 n22)
	(= (edge_length n22 n19) 89)	(= (edge_length n19 n22) 89)

	(mine_location m32 n0)
	(mine_color m32 black)

	(mine_location m31 n1)
	(mine_color m31 orange)
	
	(mine_location m29 n9)
	(mine_color m29 red)
	
	(mine_location m33 n11)
	(mine_color m33 green)
	
	(mine_location m30 n19)
	(mine_color m30 blue)

	(not_carrying a28 red)
	(not_carrying a28 blue)
	(not_carrying a28 orange)
	(not_carrying a28 black)
	(not_carrying a28 green)

	(not_carrying a26 red)
	(not_carrying a26 blue)
	(not_carrying a26 orange)
	(not_carrying a26 black)
	(not_carrying a26 green)

	(not_carrying a27 red)
	(not_carrying a27 blue)
	(not_carrying a27 orange)
	(not_carrying a27 black)
	(not_carrying a27 green)

	(not-same a26 a27)	(not-same a27 a26)
	(not-same a26 a28)	(not-same a28 a26)
	(not-same a27 a28)	(not-same a28 a27)

	(= (mine_duration m32) 33)
	(= (mine_duration m31) 33)
	(= (mine_duration m29) 33)
	(= (mine_duration m33) 33)
	(= (mine_duration_blue m30) 66)

	(is_red red)
	(is_blue blue)
	(is_orange orange)
	(is_black black)

	(not_red blue)
	(not_red orange)
	(not_red green)
	(not_red black)

	(not_black red)
	(not_black orange)
	(not_black green)
	(not_black blue)

	(not_blue red)
	(not_blue orange)
	(not_blue black)
	(not_blue green)

	(not_orange black)
	(not_orange blue)
	(not_orange green)
	(not_orange red)

	(at 0 (is_red_available))
	(at 1200 (is_red_available))
	(at 2400 (is_red_available))
	(at 3600 (is_red_available))
	(at 4800 (is_red_available))
	(at 6000 (is_red_available))

	(site_not_created n19)
	(= (individual_resource_required t25 orange) 2)
	(= (total_resource_required t25 n19) 2)
	(building_not_built t25 n19)

	(site_not_created n1)
	(= (individual_resource_required t26 black) 1)
	(= (individual_resource_required t26 red) 1)
	(= (total_resource_required t26 n1) 2)
	(building_not_built t26 n1)

	(site_not_created n22)
	(= (individual_resource_required t27 blue) 1)
	(= (individual_resource_required t27 green) 1)
	(= (individual_resource_required t27 red) 1)
	(= (individual_resource_required t27 black) 2)
	(= (total_resource_required t27 n22) 5)
	(building_not_built t27 n22)
)

(:goal
	(and
		(building_built t25 n19)
		(building_built t26 n1)
		(building_built t27 n22)
	)
))