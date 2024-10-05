class_name Level extends Node2D

@export var spawn_points: Array[Node2D]
var spawn := Vector2(0, 0)

func _ready():
	$NavigationRegion2D.bake_navigation_polygon()
