extends CharacterBody2D

# --- Movimiento / dash ---
@export var move_speed: float = 130.0
@export var dash_speed: float = 260.0
@export var dash_time: float = 0.12
var _dash_timer: float = 0.0
var _dash_dir: Vector2 = Vector2.ZERO

# --- Ataque ---
@export var attack_cooldown: float = 0.25
@export var attack_active_time: float = 0.12
var _attack_cd: float = 0.0
@onready var hitbox: Area2D = $Hitbox

# --- Vida / daño ---
@export var max_hp: int = 3
@export var invuln_time: float = 0.6
@export var knockback_force: float = 180.0
var hp: int = 0
var _invuln: float = 0.0
@onready var sprite: Sprite2D = $Sprite2D

func _ready() -> void:
	hp = max_hp

func _physics_process(delta: float) -> void:
	# Invulnerabilidad visual
	if _invuln > 0.0:
		_invuln -= delta
		var t := float(Time.get_ticks_msec()) * 0.02
		sprite.modulate.a = 0.7 + 0.3 * sin(t)
	else:
		sprite.modulate.a = 1.0

	# Dirección de movimiento
	var dir: Vector2 = Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	).normalized()

	# Dash o movimiento normal
	if _dash_timer <= 0.0:
		velocity = dir * move_speed
		if Input.is_action_just_pressed("dash") and dir != Vector2.ZERO:
			_dash_dir = dir
			_dash_timer = dash_time
	else:
		velocity = _dash_dir * dash_speed
		_dash_timer -= delta

	move_and_slide()

	# Ataque
	if _attack_cd > 0.0:
		_attack_cd -= delta
	if Input.is_action_just_pressed("attack") and _attack_cd <= 0.0:
		_attack_cd = attack_cooldown
		_do_attack()

func _do_attack() -> void:
	hitbox.monitoring = true
	await get_tree().create_timer(attack_active_time).timeout
	hitbox.monitoring = false

# --- Señal del Hitbox ---
func _on_Hitbox_area_entered(area: Area2D) -> void:
	var owner: Node = area.get_parent()
	if owner and owner.has_method("apply_damage"):
		owner.apply_damage(1, global_position)

# --- Recibir daño ---
func apply_damage(amount: int, from_pos: Vector2 = global_position) -> void:
	if _invuln > 0.0:
		return
	hp -= amount
	_invuln = invuln_time

	var dir: Vector2 = (global_position - from_pos).normalized()
	velocity = dir * knockback_force

	if hp <= 0:
		_die()

func _die() -> void:
	get_tree().call_group("game", "on_player_dead")
