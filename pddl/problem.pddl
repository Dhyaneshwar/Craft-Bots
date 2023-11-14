(define(problem craft-bots-prob)

(:domain craft-bots)

(:objects
	a25 a26 a24 - actor
	t21 t22 t23 - task
	n0 n1 n3 n5 n7 n9 n11 n13 n16 n19 - node
	m30 m27 m28 m29 m31 - mine
	red blue orange black green - color
)

(:init
	(alocation a25 n0)
	(alocation a26 n3)
	(alocation a24 n9)

	(connected n1 n0)	(connected n0 n1)
	(connected n3 n1)	(connected n1 n3)
	(connected n5 n3)	(connected n3 n5)
	(connected n7 n5)	(connected n5 n7)
	(connected n9 n7)	(connected n7 n9)
	(connected n16 n7)	(connected n7 n16)
	(connected n11 n9)	(connected n9 n11)
	(connected n13 n9)	(connected n9 n13)
	(connected n13 n11)	(connected n11 n13)
	(connected n16 n13)	(connected n13 n16)
	(connected n19 n16)	(connected n16 n19)

	(mine_detail m30 n0 black)
	(mine_detail m27 n1 red)
	(mine_detail m28 n3 blue)
	(mine_detail m29 n5 orange)
	(mine_detail m31 n7 green)

	(not_carrying a25 red)
	(not_deposited a25 red n1)
	(not_carrying a25 blue)
	(not_deposited a25 blue n1)
	(not_carrying a25 orange)
	(not_deposited a25 orange n1)
	(not_carrying a25 black)
	(not_deposited a25 black n1)
	(not_carrying a25 green)
	(not_deposited a25 green n1)

	(not_carrying a26 red)
	(not_deposited a26 red n1)
	(not_carrying a26 blue)
	(not_deposited a26 blue n1)
	(not_carrying a26 orange)
	(not_deposited a26 orange n1)
	(not_carrying a26 black)
	(not_deposited a26 black n1)
	(not_carrying a26 green)
	(not_deposited a26 green n1)

	(not_carrying a24 red)
	(not_deposited a24 red n1)
	(not_carrying a24 blue)
	(not_deposited a24 blue n1)
	(not_carrying a24 orange)
	(not_deposited a24 orange n1)
	(not_carrying a24 black)
	(not_deposited a24 black n1)
	(not_carrying a24 green)
	(not_deposited a24 green n1)

	(not_created_site n1)
	(= (color_count red n1) 1)
	(= (color_count blue n1) 1)
	(= (color_count orange n1) 1)
	(= (color_count black n1) 1)
)

(:goal
	(and
		(= (color_count red n1) 0)
		(= (color_count blue n1) 0)
		(= (color_count orange n1) 0)
		(= (color_count black n1) 0)
)))
