(define(problem craft-bots-temporal-prob)

(:domain craft-bots-temporal)

(:objects
	;; Declaring the objects for the problem
	a25 a27 a26 - actor
	t22 t23 t24 - task
	n0 n1 n3 n5 n7 n9 n13 n15 n17 n20 - node
	m32 m31 m29 m28 m30 - mine
	red blue orange black green - color
)

(:init
	;; setting the initial node for each actor
	(actor_location a25 n0)
	(= (move_speed a25) 5)
	(= (total_resource_in_inventory a25) 0)

	(actor_location a27 n3)
	(= (move_speed a27) 5)
	(= (total_resource_in_inventory a27) 0)

	(actor_location a26 n13)
	(= (move_speed a26) 5)
	(= (total_resource_in_inventory a26) 0)


	;; setting the connection between each nodes
	(connected n1 n0)	(connected n0 n1)
	(= (edge_length n1 n0) 84)	(= (edge_length n0 n1) 84)
	(connected n3 n1)	(connected n1 n3)
	(= (edge_length n3 n1) 81)	(= (edge_length n1 n3) 81)
	(connected n9 n1)	(connected n1 n9)
	(= (edge_length n9 n1) 98)	(= (edge_length n1 n9) 98)
	(connected n5 n3)	(connected n3 n5)
	(= (edge_length n5 n3) 80)	(= (edge_length n3 n5) 80)
	(connected n7 n5)	(connected n5 n7)
	(= (edge_length n7 n5) 73)	(= (edge_length n5 n7) 73)
	(connected n9 n5)	(connected n5 n9)
	(= (edge_length n9 n5) 98)	(= (edge_length n5 n9) 98)
	(connected n9 n7)	(connected n7 n9)
	(= (edge_length n9 n7) 73)	(= (edge_length n7 n9) 73)
	(connected n13 n9)	(connected n9 n13)
	(= (edge_length n13 n9) 88)	(= (edge_length n9 n13) 88)
	(connected n15 n13)	(connected n13 n15)
	(= (edge_length n15 n13) 75)	(= (edge_length n13 n15) 75)
	(connected n17 n13)	(connected n13 n17)
	(= (edge_length n17 n13) 84)	(= (edge_length n13 n17) 84)
	(connected n17 n15)	(connected n15 n17)
	(= (edge_length n17 n15) 82)	(= (edge_length n15 n17) 82)
	(connected n20 n17)	(connected n17 n20)
	(= (edge_length n20 n17) 84)	(= (edge_length n17 n20) 84)

	;; setting the mines details
	(mine_detail m32 n3 green)
	(mine_detail m31 n5 black)
	(mine_detail m29 n9 blue)
	(mine_detail m28 n15 red)
	(mine_detail m30 n15 orange)

	(not_carrying a25 red)
	(not_carrying a25 blue)
	(not_carrying a25 orange)
	(not_carrying a25 black)
	(not_carrying a25 green)

	(not_carrying a27 red)
	(not_carrying a27 blue)
	(not_carrying a27 orange)
	(not_carrying a27 black)
	(not_carrying a27 green)

	(not_carrying a26 red)
	(not_carrying a26 blue)
	(not_carrying a26 orange)
	(not_carrying a26 black)
	(not_carrying a26 green)

	(not_carrying a25 red)
	(not_carrying a25 blue)
	(not_carrying a25 orange)
	(not_carrying a25 black)
	(not_carrying a25 green)

	(not_carrying a27 red)
	(not_carrying a27 blue)
	(not_carrying a27 orange)
	(not_carrying a27 black)
	(not_carrying a27 green)

	(not_carrying a26 red)
	(not_carrying a26 blue)
	(not_carrying a26 orange)
	(not_carrying a26 black)
	(not_carrying a26 green)

	(not_carrying a25 red)
	(not_carrying a25 blue)
	(not_carrying a25 orange)
	(not_carrying a25 black)
	(not_carrying a25 green)

	(not_carrying a27 red)
	(not_carrying a27 blue)
	(not_carrying a27 orange)
	(not_carrying a27 black)
	(not_carrying a27 green)

	(not_carrying a26 red)
	(not_carrying a26 blue)
	(not_carrying a26 orange)
	(not_carrying a26 black)
	(not_carrying a26 green)


	(not_deposited a25 red n0)
	(not_deposited a25 blue n0)
	(not_deposited a25 orange n0)
	(not_deposited a25 black n0)
	(not_deposited a25 green n0)

	(not_deposited a27 red n0)
	(not_deposited a27 blue n0)
	(not_deposited a27 orange n0)
	(not_deposited a27 black n0)
	(not_deposited a27 green n0)

	(not_deposited a26 red n0)
	(not_deposited a26 blue n0)
	(not_deposited a26 orange n0)
	(not_deposited a26 black n0)
	(not_deposited a26 green n0)

	(not_deposited a25 red n1)
	(not_deposited a25 blue n1)
	(not_deposited a25 orange n1)
	(not_deposited a25 black n1)
	(not_deposited a25 green n1)

	(not_deposited a27 red n1)
	(not_deposited a27 blue n1)
	(not_deposited a27 orange n1)
	(not_deposited a27 black n1)
	(not_deposited a27 green n1)

	(not_deposited a26 red n1)
	(not_deposited a26 blue n1)
	(not_deposited a26 orange n1)
	(not_deposited a26 black n1)
	(not_deposited a26 green n1)

	(not_deposited a25 red n15)
	(not_deposited a25 blue n15)
	(not_deposited a25 orange n15)
	(not_deposited a25 black n15)
	(not_deposited a25 green n15)

	(not_deposited a27 red n15)
	(not_deposited a27 blue n15)
	(not_deposited a27 orange n15)
	(not_deposited a27 black n15)
	(not_deposited a27 green n15)

	(not_deposited a26 red n15)
	(not_deposited a26 blue n15)
	(not_deposited a26 orange n15)
	(not_deposited a26 black n15)
	(not_deposited a26 green n15)

	(not (create_site n0))
	(site_not_created n0)

	(not (create_site n1))
	(site_not_created n1)
	
	(not (create_site n15))
	(site_not_created n15)

	(= (color_count red n0) 2)
	(= (color_count black n1) 2)
	(= (color_count orange n15) 1)
	(= (color_count black n15) 1)
	(= (color_count green n15) 1)

	(not-same a25 a27)	(not-same a27 a25)
	(not-same a25 a26)	(not-same a26 a25)
	(not-same a27 a25)	(not-same a25 a27)
	(not-same a27 a26)	(not-same a26 a27)
	(not-same a26 a25)	(not-same a25 a26)
	(not-same a26 a27)	(not-same a27 a26)

	(= (mine_duration m32) 33)
	(= (mine_duration m31) 33)
	(= (mine_duration_blue m29) 66)
	(= (mine_duration m28) 33)
	(= (mine_duration m30) 33)

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


	(at 0 (red_available))
	(at 1200 (red_available))
	(at 2400 (red_available))
	(at 3600 (red_available))
	(at 4800 (red_available))
	(at 6000 (red_available))
	(at 7200 (red_available))
	(at 8400 (red_available))
	(at 9600 (red_available))
)
(:goal
	(and
		(= (color_count red n0) 0)
)))
