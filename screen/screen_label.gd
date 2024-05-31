extends Label

@export var prefabricate: PrefabricateResource

func _ready() -> void:
	var current_count = GlobalNeeds.prefabricate_counts[prefabricate.prefabricate_material][prefabricate.prefabricate_type]
	update_label(prefabricate, current_count)
	GlobalNeeds.CountUpdated.connect(update_label)

func update_label(p: PrefabricateResource, count: int) -> void:
	var pm = prefabricate.prefabricate_material
	var pt = prefabricate.prefabricate_type

	if p.prefabricate_material != pm or p.prefabricate_type != pt:
		return

	text = str(count)
