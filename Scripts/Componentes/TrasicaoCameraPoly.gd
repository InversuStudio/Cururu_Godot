class_name TransicaoCamera extends Polygon2D

@export var de:Camera2D = null
@export var para:Camera2D = null

func _ready() -> void:
	hide()

func _physics_process(_delta: float) -> void:
	if Mundos.player:
		if Geometry2D.is_point_in_polygon(Mundos.player.global_position, self.polygon):
			print(name)
			if de:
				de.enabled = false
			if para:
				para.enabled = true
