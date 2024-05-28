extends CharacterBody2D

class_name Player

@export var move_speed := 75.0
@export var jump_velocity := 300.0
@export var sprint_speed := 125.0
@export var max_weight_capacity := 100
@export var mobility_curve: Curve

var weight_capacity := 0.0:
	set(value):
		weight_capacity += clampf(value / max_weight_capacity, 0.0, 1.0)

var last_direction := 0.0
var can_anim_jump := true

var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")

var direction := 0.0

var is_jumping := false
@export var jump_buffer_ms := 0.1

var is_on_coyote_floor := false
@export var jump_coyote_ms := 0.1

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
	is_jumping = false

func jump_coyote_timer_timeout():
	is_on_coyote_floor = false

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	GlobalBackpack.CountUpdated.connect(handle_backpack_change)
	setup_jump_timer()
	setup_coyote_timer()

func _input(event: InputEvent) -> void:
	direction = Input.get_axis("move_left", "move_right")

	if event.is_action_pressed("jump"):
		is_jumping = true
		jump_buffer_timer.start(jump_buffer_ms)

func _process(delta: float) -> void:
	# Add the gravity.
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

	if is_jumping and is_on_coyote_floor:
		is_jumping = false
		is_on_coyote_floor = false
		velocity.y = -jump_velocity

	if direction:
		velocity.x = direction * get_speed()
	else:
		velocity.x = move_toward(velocity.x, 0, get_speed())

func anim_sprite():
	if is_on_floor():
		can_anim_jump = true
		if direction:
			if abs(velocity.x) > move_speed:
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

func get_speed() -> float:
	var mobility_modifier = mobility_curve.sample(weight_capacity)
	if Input.is_action_pressed("sprint"):
		return sprint_speed * mobility_modifier
	return move_speed * mobility_modifier

func handle_backpack_change(p: PrefabricateResource, count: int) -> void:
	weight_capacity = p.prefabricate_weight
