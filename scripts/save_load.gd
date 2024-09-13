extends Node

var data = {}

func save_game():
	var save_nodes = get_tree().get_nodes_in_group("save")
	for save_node in save_nodes.save_data:
		data.merge(save_node.save_data)
	var json_data = JSON.stringify(data)
	var file = FileAccess.open("user://save_game.dat", FileAccess.WRITE)
	file.store_string(json_data)
