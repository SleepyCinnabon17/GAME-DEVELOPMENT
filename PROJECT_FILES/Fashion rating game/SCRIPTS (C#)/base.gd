extends Sprite2D
## add all variants for your base character here, skin color, etc
@export var base_variants: Array[Texture]
var currenttexture = 0

func switch() -> void:
	currenttexture += 1
	if currenttexture >= base_variants.size():
		currenttexture = 0
	self.texture = self.base_variants[currenttexture]
	
