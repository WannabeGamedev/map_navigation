extends Position2D

# A reference to a node that is a current target for this party
# Could be a city, other party or some other king of interactive object on the world map
# For example, if the party is seeking combat with other party, it will store the referance
# in a target variable and seek for collision with that specific node
var _target : Node
var _faction : String setget set_faction, get_faction

# Current path
var _speed : float = 200.0
var _path : = PoolVector2Array() setget set_path


onready var sprite = $Sprite
onready var body = $Body

onready var Game = get_tree().get_root().get_node("Game")


func is_type(type): return type == "Party" or .is_type(type)
func    get_type(): return "Party"


func _ready():
	set_process(false)

func goto(target_position : Vector2):
	Game.Map.Tiles.request_path(self, target_position)
#	set_path(GameNodes.Nav.get_simple_path(self.position, target_position))


func stop():
	reset_target()
	set_path(PoolVector2Array())


func new_path(path : PoolVector2Array):
	#TODO: Line2D shenenigans 
	set_path(path)


func set_path(path : PoolVector2Array):
	_path = path
	if path.size() == 0:
		return
	set_process(true)


func _process(delta):
	var move_distance = (_speed * float(Game.Timer.get_speed_modifier())) * delta
	move_along_path(move_distance)


func move_along_path(distance : float):
	var start_point : = position
	#if _target != null:
	#	goto(_target.position)
	for _i in range(_path.size()):
		var distance_to_next : = start_point.distance_to(_path[0])
		if distance <= distance_to_next and distance >= 0.0 and distance_to_next != 0:
			position = start_point.linear_interpolate(_path[0], distance / distance_to_next)
			break
		if _path.size() == 1 and distance >= distance_to_next:
			position = _path[0]
			_path.remove(0)
			set_process(false)
			path_complete()
			break
		distance -= distance_to_next
		start_point = _path[0]
		_path.remove(0)


func path_complete():
	pass


func move_to_tile(tile : Vector2):
	position = Game.Map.Tiles.tile_to_tile_center(tile)


func move_to(target_position):
	position = Game.Map.Tiles.position_to_tile_center(target_position)


func set_faction(faction : String):
	if Game.FactionsManager.faction_exists(faction):
		var f = Game.FactionsManager.get_faction(faction)
		_faction = f.name
		var img = load(f.get_party_icon())
		sprite.set_texture(img)
	else:
		print("Error assigning faction: %s" % faction)


func get_faction():
	return _faction


func set_target(target : Node):
	_target = target


func reset_target():
	_target = null


func get_target():
	return _target


func follow_party(party: Node):
	pass
	#print(self, " follows party: ", party)
	#set_target(party)
	#goto(party.position)


func _on_activation_request():
	pass


func _on_deactivation_request():
	pass


func _on_make_invisible_request():
	self.hide()


func _on_make_visible_request():
	self.show()
