extends Node

var Faction = preload("res://factions/Faction.tscn")
enum RELATIONS { FRIENDLY, HOSTILE }
var factions_data : = [
{
	"name": "Player",
	"starting_faction": true,
	"default_relations": RELATIONS.HOSTILE,
	"party_icon": "res://assets/img/party/icon.png",
	"flag_icon": "res://assets/img/flag/grey.png"
},
{
	"name": "Blue Kingdom",
	"starting_faction": true,
	"default_relations": RELATIONS.FRIENDLY,
	"party_icon": "res://assets/img/party/icon_blue.png",
	"flag_icon": "res://assets/img/flag/blue.png"
},
{
	"name": "Red Kingdom",
	"starting_faction": true,
	"default_relations": RELATIONS.FRIENDLY,
	"party_icon": "res://assets/img/party/icon_red.png",
	"flag_icon": "res://assets/img/flag/red.png"
},
{
	"name": "Green Kingdom",
	"starting_faction": true,
	"default_relations": RELATIONS.FRIENDLY,
	"party_icon": "res://assets/img/party/icon_green.png",
	"flag_icon": "res://assets/img/flag/green.png"
}]
	
	
func reset():
	for faction in factions_data:
		add_faction(faction)
	
	for faction in factions_data:
		for f in factions_data:
			if faction["name"] == f["name"]:
				continue
			if faction["default_relations"] == RELATIONS.FRIENDLY and f["default_relations"] == RELATIONS.FRIENDLY:
				set_faction_relations(faction["name"], f["name"], RELATIONS.FRIENDLY)
			else:
				set_faction_relations(faction["name"], f["name"], RELATIONS.HOSTILE)
	

func add_faction(data: Dictionary):
	var f = Faction.instance()
	f.init(data)
	self.add_child(f)


func faction_exists(faction_name: String):
	for faction in self.get_children():
		if faction.name == faction_name:
			return true
	return false
	
	
func get_faction(faction_name: String):
	for faction in self.get_children():
		if faction.name == faction_name:
			return faction
	return null


func check_relations(val: int) -> bool:
	var result : = false
	for key in RELATIONS.keys():
		if RELATIONS[key] == val:
			result = true
	return result


func set_faction_relations(faction1: String, faction2: String, relations: int):
	if faction_exists(faction1) and faction_exists(faction2):
		if check_relations(relations):
			var f1 = get_faction(faction1)
			f1.set_relations(faction2, relations)
			var f2 = get_faction(faction2)
			f2.set_relations(faction1, relations)
	
	
func get_faction_relations(faction1: String, faction2: String):
	if faction_exists(faction1) and faction_exists(faction2):
		var f1 = get_faction(faction1)
		return f1.get_relations(faction2)
	return null