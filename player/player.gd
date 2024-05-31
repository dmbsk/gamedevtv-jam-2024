extends CharacterBody2D

class_name Player

@export var move_speed := 110.0
@export var max_weight_capacity := 100
@export var mobility_curve: Curve
@export var floor_acceleration := 200.0
@export var air_acceleration := 200.0
@export var floor_friction := 1200.0
@export var air_friction := 0.0

var weight_capacity := 0.0:
	set(value):
		weight_capacity += clampf(value / max_weight_capacity, 0.0, 1.0)

var last_direction := 0.0
var can_anim_jump := true

var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")

var direction := 0.0

var can_jump := false
@export var jump_buffer_ms := 0.1

@export var variable_jump_velocity_min := 100.0
@export var variable_jump_velocity_max := 450.0
var variable_jump_velocity := 0.0

var is_on_coyote_floor := false
@export var jump_coyote_ms := 0.15

var jump_buffer_timer: Timer = Timer.new()
var jump_coyote_timer: Timer = Timer.new()

func setup_jump_timer() -> void:
	jump_buffer_timer.timeout.connect(jump_buffer_timer_timeout)
	jump_buffer_timer.autostart = false
	jump_buffer_timer.one_shot = true
	add_child(jump_buffer_timer)

func setup_coyote_timer() -> void:
	jump_coyote_timer.timeout.connect(jump_coyote_timer_timeout)
	jump_coyote_timer.autostart = false
	jump_coyote_timer.one_shot = true
	add_child(jump_coyote_timer)

func jump_buffer_timer_timeout():
	can_jump = false

func jump_coyote_timer_timeout():
	is_on_coyote_floor = false

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	GlobalBackpack.CountUpdated.connect(handle_backpack_change)
	setup_jump_timer()
	setup_coyote_timer()

func _process(delta: float) -> void:
	# Add the gravity.
	direction = Input.get_axis("move_left", "move_right")

	if Input.is_action_just_pressed("jump"):
		can_jump = true
		variable_jump_velocity = 0
		jump_buffer_timer.start(jump_buffer_ms)

	if Input.is_action_pressed("jump"):
		variable_jump_velocity += gravity * delta * 1.6

	if Input.is_action_just_released("jump"):
		variable_jump_velocity = 0
		can_jump = false

	if not is_on_floor():
		if jump_coyote_timer.is_stopped():
			jump_coyote_timer.start(jump_coyote_ms)

	if is_on_floor():
		is_on_coyote_floor = true
		jump_coyote_timer.stop()

	if direction:
		last_direction = direction

	anim_sprite()
	move_and_slide()

func _physics_process(delta: float) -> void:
		
	if not is_on_floor():
		velocity.y += gravity * delta

	if can_jump and is_on_coyote_floor:
		velocity.y = -min(variable_jump_velocity_min + variable_jump_velocity, variable_jump_velocity_max)

	if direction:
		if (sign(velocity.x) != sign(direction)):
			velocity.x = move_toward(velocity.x, direction * move_speed, delta * get_acceleration() * 2)
		else:
			velocity.x = move_toward(velocity.x, direction * move_speed, delta * get_acceleration())
	else:
		velocity.x = move_toward(velocity.x, 0, delta * get_friction())

func anim_sprite():
	if is_on_floor():
		can_anim_jump = true
		if direction:
			if abs(velocity.x) > move_speed * 0.9:
				if direction > 0:
					animated_sprite.play("run_right")
				if direction < 0:
					animated_sprite.play("run_left")
				return
			if direction > 0:
				animated_sprite.play("move_right")
			if direction < 0:
				animated_sprite.play("move_left")
			return

		if last_direction > 0:
			animated_sprite.play("idle_right")
		if last_direction < 0:
			animated_sprite.play("idle_left")
			
		return

	if can_anim_jump:
		can_anim_jump = false
		if velocity.y < 0:
			if last_direction > 0:
				animated_sprite.play("jump_right")
				return
			if last_direction < 0:
				animated_sprite.play("jump_left")
				return

func get_mobility() -> float:
	return mobility_curve.sample(weight_capacity)

func get_acceleration() -> float:
	if is_on_floor():
		return floor_acceleration * get_mobility()
	return air_acceleration * get_mobility()

func get_friction() -> float:
	if is_on_floor():
		return floor_friction * get_mobility()
	return air_friction * get_mobility()

func handle_backpack_change(p: PrefabricateResource, count: int) -> void:
	weight_capacity = p.prefabricate_weight
