extends Resource

class_name PrefabricateResource

@export var prefabricate_material: Prefabricate.PrefabricateMaterial
@export var prefabricate_type: Prefabricate.PrefabricateType
var prefabricate_weight: float = PrefabricateWeight.get_weight(prefabricate_material, prefabricate_type)

static func init(mat: Prefabricate.PrefabricateMaterial, type: Prefabricate.PrefabricateType) -> PrefabricateResource:
  var resource = PrefabricateResource.new()
  resource.prefabricate_material = mat
  resource.prefabricate_type = type
  return resource