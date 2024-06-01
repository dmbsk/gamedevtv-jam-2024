extends Sprite2D
class_name PointsScreen

var last_points := 0.0

var time_diff := 0.0

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var timer: Timer = $Timer
@onready var points_label: Label = %Value

func _ready() -> void:
	GlobalPoints.Update.connect(handle_score_update)
	timer.timeout.connect(handle_timer_timeout)
	points_label.text = str(0)

func _process(delta: float) -> void:
	if !timer.is_stopped():
		time_diff += delta
		var lerped = lerpf(last_points, GlobalPoints.total_points, time_diff / timer.wait_time)
		points_label.text = str(int(lerped))

func handle_score_update(current_points: float, _last_points: float) -> void:
	animation_player.stop()
	timer.stop()
	time_diff = 0
	if current_points:
		timer.start()
		last_points = _last_points
	animation_player.play("Increase")

func handle_timer_timeout():
	animation_player.stop()
	time_diff = 0;
	last_points = GlobalPoints.total_points
