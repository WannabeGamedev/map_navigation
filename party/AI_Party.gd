extends "res://party/Party.gd"


func _ready():
	start_mission()

func start_mission():
	goto( Game.Map.Tiles.tile_to_tile_center( Game.Map.Tiles.get_random_spawn_position() ) )


func path_complete():
	start_mission()
	
	
func _on_activation_request():
	start_mission()


func _on_deactivation_request():
	stop()