(define(problem craft-bots-prob)

(:domain craft-bots)

(:objects
	a27 a26 a28 - actor
	t23 t24 t25 - task
	n0 n1 n3 n5 n7 n10 n12 n15 n17 n20 - node
	m33 m29 m30 m31 m32 - mine
	red blue orange black green - color
)

(:init
    ;; setting the initial node for each actor
	(actor_location a27 n17)
	(actor_location a26 n20)
	(actor_location a28 n20)

    ;; setting the connection between each nodes
	(connected n1 n0)	(connected n0 n1)
	(connected n3 n1)	(connected n1 n3)
	(connected n17 n1)	(connected n1 n17)
	(connected n5 n3)	(connected n3 n5)
	(connected n7 n3)	(connected n3 n7)
	(connected n7 n5)	(connected n5 n7)
	(connected n10 n7)	(connected n7 n10)
	(connected n12 n7)	(connected n7 n12)
	(connected n12 n10)	(connected n10 n12)
	(connected n15 n12)	(connected n12 n15)
	(connected n17 n15)	(connected n15 n17)
	(connected n20 n15)	(connected n15 n20)
	(connected n20 n17)	(connected n17 n20)

    ;; setting the mines details
	(mine_detail m33 n0 green)
	(mine_detail m29 n5 red)
	(mine_detail m30 n5 blue)
	(mine_detail m31 n7 orange)
	(mine_detail m32 n7 black)

    ;; set the variables not_created_site
	(not_created_site n7 t23)
	(not_created_site n17 t24)
	(not_created_site n5 t25)

    ;; set the variables not_carrying
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

	(not_carrying a28 red)
	(not_carrying a28 blue)
	(not_carrying a28 orange)
	(not_carrying a28 black)
	(not_carrying a28 green)


    ;; set the variables not_deposited
	(not_deposited a27 t23 red n7)
	(not_deposited a27 t23 blue n7)
	(not_deposited a27 t23 orange n7)
	(not_deposited a27 t23 black n7)
	(not_deposited a27 t23 green n7)

	(not_deposited a26 t23 red n7)
	(not_deposited a26 t23 blue n7)
	(not_deposited a26 t23 orange n7)
	(not_deposited a26 t23 black n7)
	(not_deposited a26 t23 green n7)

	(not_deposited a28 t23 red n7)
	(not_deposited a28 t23 blue n7)
	(not_deposited a28 t23 orange n7)
	(not_deposited a28 t23 black n7)
	(not_deposited a28 t23 green n7)

	(not_deposited a27 t24 red n17)
	(not_deposited a27 t24 blue n17)
	(not_deposited a27 t24 orange n17)
	(not_deposited a27 t24 black n17)
	(not_deposited a27 t24 green n17)

	(not_deposited a26 t24 red n17)
	(not_deposited a26 t24 blue n17)
	(not_deposited a26 t24 orange n17)
	(not_deposited a26 t24 black n17)
	(not_deposited a26 t24 green n17)

	(not_deposited a28 t24 red n17)
	(not_deposited a28 t24 blue n17)
	(not_deposited a28 t24 orange n17)
	(not_deposited a28 t24 black n17)
	(not_deposited a28 t24 green n17)

	(not_deposited a27 t25 red n5)
	(not_deposited a27 t25 blue n5)
	(not_deposited a27 t25 orange n5)
	(not_deposited a27 t25 black n5)
	(not_deposited a27 t25 green n5)

	(not_deposited a26 t25 red n5)
	(not_deposited a26 t25 blue n5)
	(not_deposited a26 t25 orange n5)
	(not_deposited a26 t25 black n5)
	(not_deposited a26 t25 green n5)

	(not_deposited a28 t25 red n5)
	(not_deposited a28 t25 blue n5)
	(not_deposited a28 t25 orange n5)
	(not_deposited a28 t25 black n5)
	(not_deposited a28 t25 green n5)


    ;; set the resource_count function
	(= (resource_count t23 red n7) 1)
	(= (resource_count t23 blue n7) 2)
	(= (resource_count t23 orange n7) 1)
	(= (resource_count t23 black n7) 1)
	(= (resource_count t23 green n7) 1)
	(= (resource_count t24 red n17) 1)
	(= (resource_count t25 red n5) 2)
)

(:goal
	(and
		(= (resource_count t23 red n7) 0)
		(= (resource_count t23 blue n7) 0)
		(= (resource_count t23 orange n7) 0)
		(= (resource_count t23 black n7) 0)
		(= (resource_count t23 green n7) 0)
		(= (resource_count t24 red n17) 0)
		(= (resource_count t25 red n5) 0)
)))
