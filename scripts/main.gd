extends Node2D

@export var game_scene: PackedScene

func _ready()->void:
	var g:=game_scene.instantiate() as Node2D
	add_child(g)