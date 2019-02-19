extends TileMap

signal generation_complete

const SAVE_KEY = "Map"

const MAP_WIDTH = 128
const MAP_HEIGHT = 128

const TILES = {
	'water' : 1,
	'grass' : 0,
	'mountain': 2
}

const OBSTACLE_TILES = [1]

var _seed = null
var open_simplex_noise

onready var Game = get_tree().get_root().get_node("Game")

func _ready():
	generate_world(_get_random_seed())


func _get_random_seed():
	return randi()


func generate_world(map_seed):
	
	open_simplex_noise = OpenSimplexNoise.new()
	open_simplex_noise.seed = map_seed
	_seed = open_simplex_noise.seed
	
	open_simplex_noise.octaves = 4
	open_simplex_noise.period = 15
	open_simplex_noise.lacunarity = 1.5
	open_simplex_noise.persistence = 0.75
	
	for x in MAP_WIDTH:
		for y in MAP_HEIGHT:
			self.set_cellv(Vector2(float(x), float(y)), _get_tile_type(open_simplex_noise.get_noise_2d(float(x), float(y))))
	
	emit_signal("generation_complete")


func _get_tile_type(sample):
	if sample < -0.1:
		return TILES.water
	elif sample < 0.5:
		return TILES.grass
	else:
		return TILES.mountain
	
	
func get_random_spawn_position():
	var x = randi() % MAP_WIDTH
	var y = randi() % MAP_HEIGHT
	var tile = Vector2(float(x), float(y))
	if !OBSTACLE_TILES.has(get_cellv(tile)):
		return tile
	else:
		return get_random_spawn_position()


func position_to_tile_center(pos: Vector2) -> Vector2:
	return map_to_world(world_to_map(pos)) + Vector2(0, cell_size.y / 2)


func tile_to_tile_center(tile: Vector2) -> Vector2:
	return map_to_world(tile) + Vector2(0, cell_size.y / 2)


func _unhandled_input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed \
		 	or event is InputEventScreenTouch and event.pressed:
		request_path(Game.player_party, get_global_mouse_position())
		Game.player_party.reset_target()


func request_path(party: Node, target_position: Vector2):
		var new_path = Game.Map.Nav.get_simple_path(party.position, target_position)
		party.new_path(new_path)


func save(save_game : Resource):
	save_game.data[SAVE_KEY] = {
		"seed": _seed
	}
	
	
func load(save_game : Resource):
	var data : Dictionary = save_game.data[SAVE_KEY]
	generate_world(data['seed'])
	
	