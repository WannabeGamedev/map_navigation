extends Node

func random_int(minimum : int, maximum : int):
	return randi() % (maximum-minimum+1) + minimum