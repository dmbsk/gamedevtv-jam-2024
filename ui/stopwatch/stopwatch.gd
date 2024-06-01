extends Label

var minutes: int = 0
var seconds: int = 0

var timer: Timer = Timer.new()

func _ready() -> void:
	GlobalSignals.RoundStart.connect(handle_round_start)
	timer.one_shot = true
	timer.autostart = true
	timer.timeout.connect(handle_round_end)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	seconds = int(timer.time_left) % 60
	minutes = int(timer.time_left / 60)
	text = get_time_formatted()

func handle_round_start(time_in_seconds: float) -> void:
	timer.wait_time = time_in_seconds
	add_child(timer)
	GlobalSignals.RoundStart.disconnect(handle_round_start)

func get_time_formatted() -> String:
	return "%2d:%02d" % [minutes, seconds]

func handle_round_end() -> void:
	GlobalSignals.RoundEnd.emit()
