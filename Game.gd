extends Node

var player_party : Node

onready var Timer = $Timer
onready var Pauser = $Timer.get_node("Pauser")
onready var Map = $WorldMap
onready var PartyGenerator = $PartyGenerator
onready var FactionsManager = $FactionsManager

func _ready():
	randomize()
	Timer.reset()
	Timer.start()
	FactionsManager.reset()
	Map.Tiles.generate_world(Map.Tiles._get_random_seed())
	player_party = PartyGenerator.spawn_player()
	
func _input(event):
	if event.is_action_pressed("add_ai"):
		for _i in range(0, 10):
			var party = PartyGenerator.spawn_party("Red Kingdom")
			party.start_mission()

		for _i in range(0, 10):
			var party = PartyGenerator.spawn_party("Blue Kingdom")
			party.start_mission()

		for _i in range(0, 10):
			var party = PartyGenerator.spawn_party("Green Kingdom")
			party.start_mission()