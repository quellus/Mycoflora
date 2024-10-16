extends Node

var data = {
	"players": {
		"player1": {
			"killed_boss": false,
			"has_weapon": false,
			"flowers": 10
		}
	}
}

func save_game():
	var json_data = JSON.stringify(data)
	var file = FileAccess.open("user://save_game.json", FileAccess.WRITE)
	file.store_string(json_data)
