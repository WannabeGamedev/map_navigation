extends Node


var relations : = {}
var party_icon : = "" setget set_party_icon, get_party_icon
var flag_icon : = "" setget set_flag_icon, get_flag_icon
	
	
func init(data: Dictionary):
	if data.has("name"):
		name = data["name"]
	if data.has("party_icon"):
		set_party_icon(data["party_icon"])
	if data.has("flag_icon"):
		set_flag_icon(data["flag_icon"])


func set_flag_icon(img: String):
	flag_icon = img
	
	
func get_flag_icon():
	return party_icon
	
	
func set_party_icon(img: String):
	party_icon = img
	
	
func get_party_icon():
	return party_icon
	
	
func set_relations(faction_name: String, value: int):
	relations[faction_name] = value


func get_relations(faction_name: String):
	if relations.has(faction_name):
		return relations[faction_name]
	else:
		return null