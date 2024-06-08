extends Label

@export var prefabricate: PrefabricateResource

func _ready() -> void:
	var current_count = GlobalBackpack.prefabricate_counts[prefabricate.prefabricate_material][prefabricate.prefabricate_type]
	update_label(prefabricate, current_count, false)
	GlobalBackpack.CountUpdated.connect(update_label)
	GlobalSignals.RoundStart.connect(_on_round_start)

func update_label(p: PrefabricateResource, count: int, fromDeposit: bool) -> void:
	var pm = prefabricate.prefabricate_material
	var pt = prefabricate.prefabricate_type

	if p.prefabricate_material != pm or p.prefabricate_type != pt:
		return

	text = str(count)

func _on_round_start(time: float) -> void:
	text = str(0)