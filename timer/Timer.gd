extends Timer

signal time_changed(days, hours, minutes)
signal hour_changed

# Unique key for save game
onready var SAVE_KEY = name

onready var _campaign_start = 0 setget ,get_campaign_start
onready var _total_time = 0
onready var _days = 0
onready var _hours = 0
onready var _minutes = 0

# Time flow settings
# _speed is amount of in-game minutes per timer tick
# _speed_modifier is for x2 speedup
var _speed = 30
var _speed_modifier = 1 setget set_speed_modifier, get_speed_modifier

const THRESHOLD_MORNING = 6
const THRESHOLD_EVENING = 21

func set_speed_modifier(value: int):
	_speed_modifier = value
	
func get_speed_modifier():
	return _speed_modifier

func get_campaign_start() -> int:
	return _campaign_start

func reset():
	self.stop()
	_campaign_start = OS.get_unix_time()
	_total_time = 0
	_minutes = 30
	_hours = 20
	_days = 1
	emit_signal("time_changed", _days, _hours, _minutes)
	
func _tick():
	# flag that tells us to check for day/night animation
	var light_anim = false
	_total_time += _speed * _speed_modifier
	_minutes += _speed * _speed_modifier
	
	if _minutes >= 60:
		_minutes = _minutes - 60
		_hours += 1
		# hours changed, maybe it's time to play animation, set flag to true
		light_anim = true
		emit_signal("hour_changed")
		
	if _hours >= 24:
		_hours = _hours - 24
		_days += 1
		
	# visual effect
	#if light_anim:
		#if _hours == THRESHOLD_MORNING:
			#GameNodes.Light.play_animation("morning", get_speed_modifier())
		#if _hours == THRESHOLD_EVENING:
			#GameNodes.Light.play_animation("evening", get_speed_modifier())
			
	emit_signal("time_changed", _days, _hours, _minutes)

func is_day() -> bool:
	if _hours >= THRESHOLD_MORNING and _hours < THRESHOLD_EVENING:
		return true
	else:
		return false

func save(save_game : Resource):
	save_game.data[SAVE_KEY] = {
		"campaign_start": _campaign_start,
		"total": _total_time,
		"minutes": _minutes,
		"hours": _hours,
		"days": _days
	}
	
func load(save_game : Resource):
	var data : Dictionary = save_game.data[SAVE_KEY]
	_campaign_start = data["campaign_start"]
	_total_time = data["total"]
	_minutes = data["minutes"]
	_hours = data["hours"]
	_days = data["days"]