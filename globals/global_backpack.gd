extends Node

var max_items := 9
var min_items := 0

var weight := 0.0
var max_weight_capacity := calculate_max_weight()

var default_prefabricate_counts: Dictionary = {
  Prefabricate.PrefabricateMaterial.STEEL: {
  Prefabricate.PrefabricateType.ROD: 0,
  Prefabricate.PrefabricateType.WHEEL: 0,
  Prefabricate.PrefabricateType.PLATE: 0,
  },
  Prefabricate.PrefabricateMaterial.WOOD: {
  Prefabricate.PrefabricateType.ROD: 0,
  Prefabricate.PrefabricateType.WHEEL: 0,
  Prefabricate.PrefabricateType.PLATE: 0,
  }
}

var prefabricate_counts := default_prefabricate_counts.duplicate(true)

signal CountUpdated(p: PrefabricateResource, count: int, fromDeposit: bool)

func _ready() -> void:
  GlobalSignals.RoundRestart.connect(_on_round_restart)
  GlobalSignals.RoundStart.connect(_on_round_start)
  pass

func update_count(p: PrefabricateResource, count: int, fromDeposit: bool) -> void:
  var currentCount = prefabricate_counts[p.prefabricate_material][p.prefabricate_type]
  var nextCount = clamp(currentCount + count, min_items, max_items)

  if prefabricate_counts[p.prefabricate_material][p.prefabricate_type] == nextCount:
    return
    
  prefabricate_counts[p.prefabricate_material][p.prefabricate_type] = nextCount
  weight += p.prefabricate_weight
  CountUpdated.emit(p, nextCount, fromDeposit)

func calculate_max_weight() -> float:
  var temp_weigth := 0.0
  for material in Prefabricate.PrefabricateMaterial.values():
    for type in Prefabricate.PrefabricateType.values():
      temp_weigth += PrefabricateWeight.get_weight(material, type) * max_items
  return temp_weigth

func _on_round_restart():
  prefabricate_counts = default_prefabricate_counts.duplicate(true)

func _on_round_start(time: float):
  prefabricate_counts = default_prefabricate_counts.duplicate(true)