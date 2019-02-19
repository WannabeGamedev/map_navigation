extends Node

# Scenes required to spawn player/ai party instances
var Player = preload("res://party/PlayerParty.tscn")
var AI = preload("res://party/AI_Party.tscn")

# A flag that prevents parties from being generated
var SPAWN_ALLOW = true

onready var Game = owner

func reset():
	destroy_parties()
	# Allow parties to spawn
	SPAWN_ALLOW = true
	
func spawn_player():
	"""
	A function to create and spawn player party on a map
	"""
	if SPAWN_ALLOW:
		var player = Player.instance()
		Game.Map.get_node("Parties/Player").add_child(player)
		player.move_to_tile(Game.Map.Tiles.get_random_spawn_position())
		return player
	return null

func spawn_party(faction: String):
	if SPAWN_ALLOW:
		var party = AI.instance()
		Game.Map.get_node("Parties/Others").add_child(party)
		party.move_to_tile(Game.Map.Tiles.get_random_spawn_position())
		party.set_faction(faction)
		return party
	return null

func destroy_parties():
	for child in Game.Map.get_node("Parties/Others").get_children():
		child.queue_free()
	for child in Game.Map.get_node("Parties/Player").get_children():
		child.queue_free()