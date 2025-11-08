extends Node2D

@export var room_scene: PackedScene
@export var player_scene: PackedScene

var _room: Node2D
var _player: CharacterBody2D

func _ready() -> void:
    add_to_group("game") # Para recibir on_player_dead desde Player
    _new_run()

func _new_run() -> void:
    if _player:
        _player.queue_free()
        _player = null
    if _room:
        _room.queue_free()
        _room = null

    _room = room_scene.instantiate() as Node2D
    add_child(_room)

    
    _spawn_player()

func _spawn_player() -> void:
    var spawn: Marker2D = _room.get_node_or_null("SpawnPlayer") as Marker2D
    _player = player_scene.instantiate() as CharacterBody2D

    _room.add_child(_player) # Asegura que el player esté en el árbol antes de ajustar la posición

    if spawn:
        _player.position = spawn.position
    else:
        push_warning("[GameManager] No se encontró 'SpawnPlayer' en la Room. Usando (0,0).")
        _player.position = Vector2.ZERO

    _player.add_to_group("player")

func on_player_dead() -> void:
    _new_run()
