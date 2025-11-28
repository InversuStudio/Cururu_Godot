class_name MainCamera extends Camera2D

var forca_shake:float = 0.0
var fade_shake:float = 10.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if forca_shake > 0.0:
		forca_shake = lerpf(forca_shake, 0.0, fade_shake * delta)

		offset.x = randf_range(-forca_shake, forca_shake)
		offset.y = randf_range(-forca_shake, forca_shake)

func Shake(forca:float) -> void:
	forca_shake = forca
