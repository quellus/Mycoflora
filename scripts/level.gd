class_name Level extends Node2D

@export var spawn_points: Array[Node2D]
@export var nav_region: NavigationRegion2D
var spawn := Vector2(0, 0)

func _ready():
	if OS.has_feature("editor"):
		if nav_region:
			nav_region.bake_navigation_polygon()
