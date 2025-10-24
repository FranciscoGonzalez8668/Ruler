extends Node2D

@export var room_scene: PackedScene
@export var player_scene: PackedScene



var _room: Node2D
var _player: Node2D

func _ready()->void:
	_new_run()
# Called when the node enters the scene tree for the first time.
func _new_run() -> void:
	if _room:
		_room.queue_free()
	_room = room_scene.instantiate() as Node2D
	add_child(_player)

func _spawn_player() -> void:
	#Buscar un Marker2D en la habitacion para spawnear al jugador
	var spawn: Marker2D = _room.get_node_or_null("SpawnPlayer") as Marker2D
	_player = player_scene.instantiate() 
	if _player:
		_player.position = spawn.global_position
	add_child(_player) 
	_player.add_to_group("player")

func on_player_dead() -> void:
	_new_run()
