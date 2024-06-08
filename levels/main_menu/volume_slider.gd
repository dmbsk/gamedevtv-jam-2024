extends HSlider

func _ready():
	value_changed.connect(on_value_changed)

func on_value_changed(new_value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), new_value)
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), new_value == min_value)