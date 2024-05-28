extends Node

var max_items := 9
var min_items := 0
var max_total_count := 6

var total_weight := 0.0

var prefabricate_counts: Dictionary = {
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

signal CountUpdated(p: PrefabricateResource, count: int)

func update_count(p: PrefabricateResource) -> void:
  var currentCount = prefabricate_counts[p.prefabricate_material][p.prefabricate_type]
  var nextCount = clamp(currentCount + 1, min_items, max_items)

  if prefabricate_counts[p.prefabricate_material][p.prefabricate_type] == nextCount:
    return
    
  prefabricate_counts[p.prefabricate_material][p.prefabricate_type] = nextCount
  total_weight += p.prefabricate_weight
  CountUpdated.emit(p, nextCount)
