(define(problem craft-bots-prob)

(:domain craft-bots)

(:objects
	a27 a29 a28 - actor
	t24 t25 t26 - task
	n0 n1 n3 n5 n7 n10 n13 n17 n19 n21 - node
	m30 m33 m31 m34 m32 - mine
	red blue orange black green - color
)

(:init
    ;; setting the initial node for each actor
	(alocation a27 n0)
	(alocation a29 n0)
	(alocation a28 n3)

    ;; setting the connection between each nodes
	(connected n1 n0)	(connected n0 n1)
	(connected n3 n1)	(connected n1 n3)
	(connected n13 n1)	(connected n1 n13)
	(connected n5 n3)	(connected n3 n5)
	(connected n7 n3)	(connected n3 n7)
	(connected n10 n3)	(connected n3 n10)
	(connected n13 n3)	(connected n3 n13)
	(connected n7 n5)	(connected n5 n7)
	(connected n10 n7)	(connected n7 n10)
	(connected n13 n10)	(connected n10 n13)
	(connected n17 n13)	(connected n13 n17)
	(connected n19 n17)	(connected n17 n19)
	(connected n21 n17)	(connected n17 n21)
	(connected n21 n19)	(connected n19 n21)

    ;; setting the mines details
	(mine_detail m30 n0 red)
	(mine_detail m33 n0 black)
	(mine_detail m31 n3 blue)
	(mine_detail m34 n17 green)
	(mine_detail m32 n21 orange)

    ;; set the variables not_created_site
	(not_created_site n10 t24)
	(not_created_site n0 t25)
	(not_created_site n7 t26)

    ;; set the variables not_carrying
	(not_carrying a27 red)
	(not_carrying a27 blue)
	(not_carrying a27 orange)
	(not_carrying a27 black)
	(not_carrying a27 green)

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


    ;; set the variables not_deposited
	(not_deposited a27 t24 red n10)
	(not_deposited a27 t24 blue n10)
	(not_deposited a27 t24 orange n10)
	(not_deposited a27 t24 black n10)
	(not_deposited a27 t24 green n10)

	(not_deposited a29 t24 red n10)
	(not_deposited a29 t24 blue n10)
	(not_deposited a29 t24 orange n10)
	(not_deposited a29 t24 black n10)
	(not_deposited a29 t24 green n10)

	(not_deposited a28 t24 red n10)
	(not_deposited a28 t24 blue n10)
	(not_deposited a28 t24 orange n10)
	(not_deposited a28 t24 black n10)
	(not_deposited a28 t24 green n10)

	(not_deposited a27 t25 red n0)
	(not_deposited a27 t25 blue n0)
	(not_deposited a27 t25 orange n0)
	(not_deposited a27 t25 black n0)
	(not_deposited a27 t25 green n0)

	(not_deposited a29 t25 red n0)
	(not_deposited a29 t25 blue n0)
	(not_deposited a29 t25 orange n0)
	(not_deposited a29 t25 black n0)
	(not_deposited a29 t25 green n0)

	(not_deposited a28 t25 red n0)
	(not_deposited a28 t25 blue n0)
	(not_deposited a28 t25 orange n0)
	(not_deposited a28 t25 black n0)
	(not_deposited a28 t25 green n0)

	(not_deposited a27 t26 red n7)
	(not_deposited a27 t26 blue n7)
	(not_deposited a27 t26 orange n7)
	(not_deposited a27 t26 black n7)
	(not_deposited a27 t26 green n7)

	(not_deposited a29 t26 red n7)
	(not_deposited a29 t26 blue n7)
	(not_deposited a29 t26 orange n7)
	(not_deposited a29 t26 black n7)
	(not_deposited a29 t26 green n7)

	(not_deposited a28 t26 red n7)
	(not_deposited a28 t26 blue n7)
	(not_deposited a28 t26 orange n7)
	(not_deposited a28 t26 black n7)
	(not_deposited a28 t26 green n7)


    ;; set the color_count function
	(= (color_count t24 blue n10) 1)
	(= (color_count t24 orange n10) 1)
	(= (color_count t24 black n10) 1)
	(= (color_count t24 green n10) 2)
	(= (color_count t25 orange n0) 1)
	(= (color_count t25 black n0) 2)
	(= (color_count t25 green n0) 1)
	(= (color_count t26 red n7) 2)
	(= (color_count t26 orange n7) 3)
	(= (color_count t26 green n7) 1)
)

(:goal
	(and
		(= (color_count t24 blue n10) 0)
		(= (color_count t24 orange n10) 0)
		(= (color_count t24 black n10) 0)
		(= (color_count t24 green n10) 0)
		(= (color_count t25 orange n0) 0)
		(= (color_count t25 black n0) 0)
		(= (color_count t25 green n0) 0)
		(= (color_count t26 red n7) 0)
		(= (color_count t26 orange n7) 0)
		(= (color_count t26 green n7) 0)
)))
