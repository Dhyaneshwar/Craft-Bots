(define(problem craft-bots-temporal-prob)

(:domain craft-bots-temporal)

(:objects
	;; Declaring the objects for the problem
	a27 a25 a26 - actor
	t22 t23 t24 - task
	n0 n1 n3 n5 n8 n12 n14 n16 n18 n20 - node
	m31 m28 m32 m30 m29 - mine
	red blue orange black green - color
)

(:init
	;; setting the initial node for each actor
	(actor_location a27 n12)
	(is_idle a27)
	(= (move_speed a27) 5)
	(= (total_resource_in_inventory a27) 0)

	(actor_location a25 n16)
	(is_idle a25)
	(= (move_speed a25) 5)
	(= (total_resource_in_inventory a25) 0)

	(actor_location a26 n20)
	(is_idle a26)
	(= (move_speed a26) 5)
	(= (total_resource_in_inventory a26) 0)


	;; setting the connection between each nodes
	(connected n1 n0)	(connected n0 n1)
	(= (edge_length n1 n0) 80)	(= (edge_length n0 n1) 80)
	(connected n8 n0)	(connected n0 n8)
	(= (edge_length n8 n0) 80)	(= (edge_length n0 n8) 80)
	(connected n3 n1)	(connected n1 n3)
	(= (edge_length n3 n1) 79)	(= (edge_length n1 n3) 79)
	(connected n5 n1)	(connected n1 n5)
	(= (edge_length n5 n1) 60)	(= (edge_length n1 n5) 60)
	(connected n8 n1)	(connected n1 n8)
	(= (edge_length n8 n1) 62)	(= (edge_length n1 n8) 62)
	(connected n5 n3)	(connected n3 n5)
	(= (edge_length n5 n3) 83)	(= (edge_length n3 n5) 83)
	(connected n8 n5)	(connected n5 n8)
	(= (edge_length n8 n5) 82)	(= (edge_length n5 n8) 82)
	(connected n12 n8)	(connected n8 n12)
	(= (edge_length n12 n8) 95)	(= (edge_length n8 n12) 95)
	(connected n14 n12)	(connected n12 n14)
	(= (edge_length n14 n12) 88)	(= (edge_length n12 n14) 88)
	(connected n16 n14)	(connected n14 n16)
	(= (edge_length n16 n14) 82)	(= (edge_length n14 n16) 82)
	(connected n18 n16)	(connected n16 n18)
	(= (edge_length n18 n16) 81)	(= (edge_length n16 n18) 81)
	(connected n20 n18)	(connected n18 n20)
	(= (edge_length n20 n18) 90)	(= (edge_length n18 n20) 90)

	;; setting the mines details
	(mine_location m31 n0)
	(mine_color m31 black)
	(= (mine_duration m31) 33)

	(mine_location m28 n1)
	(mine_color m28 red)
	(= (mine_duration m28) 33)

	(mine_location m32 n12)
	(mine_color m32 green)
	(= (mine_duration m32) 33)

	(mine_location m30 n14)
	(mine_color m30 orange)
	(= (mine_duration m30) 33)

	(mine_location m29 n16)
	(mine_color m29 blue)
	(= (mine_duration m29) 66)


	;; settting a variable to track the resource carried by the actor
	(not_carrying a27 red)
	(not_carrying a27 blue)
	(not_carrying a27 orange)
	(not_carrying a27 black)
	(not_carrying a27 green)

	(not_carrying a25 red)
	(not_carrying a25 blue)
	(not_carrying a25 orange)
	(not_carrying a25 black)
	(not_carrying a25 green)

	(not_carrying a26 red)
	(not_carrying a26 blue)
	(not_carrying a26 orange)
	(not_carrying a26 black)
	(not_carrying a26 green)

	(not-same a27 a25)	(not-same a25 a27)
	(not-same a27 a26)	(not-same a26 a27)
	(not-same a25 a26)	(not-same a26 a25)

	;; set function to count total and individual resources required for a task
	(site_not_created n20)
	(= (total_resource_required t22 n20) 2)
	(= (individual_resource_required t22 red) 1)
	(= (individual_resource_required t22 blue) 1)
	(building_not_built t22 n20)

	(site_not_created n0)
	(= (total_resource_required t23 n0) 3)
	(= (individual_resource_required t23 blue) 2)
	(= (individual_resource_required t23 orange) 1)
	(building_not_built t23 n0)

	(site_not_created n5)
	(= (total_resource_required t24 n5) 1)
	(= (individual_resource_required t24 black) 1)
	(building_not_built t24 n5)

	(is_red red)
	(not_blue red)
	(not_orange red)
	(not_black red)
	(not_green red)

	(not_red blue)
	(is_blue blue)
	(not_orange blue)
	(not_black blue)
	(not_green blue)

	(not_red orange)
	(not_blue orange)
	(is_orange orange)
	(not_black orange)
	(not_green orange)

	(not_red black)
	(not_blue black)
	(not_orange black)
	(is_black black)
	(not_green black)

	(not_red green)
	(not_blue green)
	(not_orange green)
	(not_black green)
	(is_green green)

	(at 0 (is_red_available red))
	(at 1200 (is_red_available red))
	(at 2400 (is_red_available red))
	(at 3600 (is_red_available red))
	(at 4800 (is_red_available red))
	(at 6000 (is_red_available red))
	(at 7200 (is_red_available red))
	(at 8400 (is_red_available red))
	(at 9600 (is_red_available red))
	(at 10800 (is_red_available red))
	(at 12000 (is_red_available red))
	(at 13200 (is_red_available red))
	(at 14400 (is_red_available red))
	(at 15600 (is_red_available red))
	(at 16800 (is_red_available red))
	(at 18000 (is_red_available red))
	(at 19200 (is_red_available red))

)
(:goal
	(and
		(building_built t22 n20)
		(building_built t23 n0)
		(building_built t24 n5)
)))
