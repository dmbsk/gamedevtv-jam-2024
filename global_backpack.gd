extends Node

var max_items := 999
var min_items := 0

var weight := 0.0
var max_weight_capacity := calculate_max_weight()

var prefabricate_counts: Dictionary = {
  Prefabricate.PrefabricateMaterial.STEEL: {
  Prefabricate.PrefabricateType.ROD: 999,
  Prefabricate.PrefabricateType.WHEEL: 999,
  Prefabricate.PrefabricateType.PLATE: 999,
  },
  Prefabricate.PrefabricateMaterial.WOOD: {
  Prefabricate.PrefabricateType.ROD: 999,
  Prefabricate.PrefabricateType.WHEEL: 999,
  Prefabricate.PrefabricateType.PLATE: 999,
  }
}

signal CountUpdated(p: PrefabricateResource, count: int)

func update_count(p: PrefabricateResource, count: int) -> void:
  var currentCount = prefabricate_counts[p.prefabricate_material][p.prefabricate_type]
  var nextCount = clamp(currentCount + count, min_items, max_items)

  if prefabricate_counts[p.prefabricate_material][p.prefabricate_type] == nextCount:
    return
    
  prefabricate_counts[p.prefabricate_material][p.prefabricate_type] = nextCount
  weight += p.prefabricate_weight
  CountUpdated.emit(p, nextCount)

func calculate_max_weight() -> float:
  var temp_weigth := 0.0
  for material in Prefabricate.PrefabricateMaterial.values():
    for type in Prefabricate.PrefabricateType.values():
      temp_weigth += PrefabricateWeight.get_weight(material, type) * max_items
  return temp_weigth