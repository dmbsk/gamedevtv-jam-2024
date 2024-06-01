extends AudioStreamPlayer2D

class_name LoopedAudioStreamPlayer2D

func _ready() -> void:
	finished.connect(play)
