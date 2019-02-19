extends Area2D


signal activation_request
signal deactivation_request
signal make_visible_request
signal make_invisible_request


onready var Game = get_tree().get_root().get_node("Game")


func is_type(type): return type == "PartyBody" or .is_type(type)
func    get_type(): return "PartyBody"


func _on_player_party_input_event(viewport, event, shape_idx):
	"""
	A party was clicked which should lead to us following them
	and initiating an interaction when we catch up (combat, dialog etc)
	"""
	if event is InputEventMouseButton and Input.is_action_pressed("mouse_left"):
		if owner != Game.player_party:
			print(owner, " was clicked!")
			Game.player_party.follow_party(owner)
			get_tree().set_input_as_handled()


func _on_area_entered(area):
	"""
	We clicked something, it was set as our target, and now we're colliding with it
	"""
	var target = owner.get_target()
	if target != null:
		if target.get_type() == "Party":
			if area == target.body:
				print("collision with target!")
				owner.stop()
				target.stop()


func activate():
	emit_signal("activation_request")
	
	
func deactivate():
	emit_signal("deactivation_request")
	
	
func make_visible():
	emit_signal("make_visible_request")
	
	
func make_invisible():
	emit_signal("make_invisible_request")

func _on_activation_request():
	pass # Replace with function body.


func _on_deactivation_request():
	pass # Replace with function body.
