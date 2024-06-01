extends Sprite2D
class_name PointsScreen

var total_points := 0.0:
		set(value):
			total_points = value
			points_label.text = str(int(value))

var next_points := 0.0

var time_diff := 0.0

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var timer: Timer = $Timer
@onready var points_label: Label = %Value

func _ready() -> void:
	GlobalSignals.PointsAdd.connect(handle_score_update)
	timer.timeout.connect(handle_timer_timeout)
	total_points = 0.0

func _process(delta: float) -> void:
	if !timer.is_stopped():
		time_diff += delta
		total_points = lerpf(total_points, next_points, time_diff / timer.wait_time)

func handle_score_update(points: float):
	animation_player.stop()
	timer.stop()
	time_diff = 0
	if points:
		next_points += points
		timer.start()
	animation_player.play("Increase")

func handle_timer_timeout():
	animation_player.stop()
	time_diff = 0;
	total_points = next_points