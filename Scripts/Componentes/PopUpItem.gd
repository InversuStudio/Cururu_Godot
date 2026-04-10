class_name PopUp extends TextureRect

func _ready() -> void:
	await get_tree().create_timer(2.0).timeout
	var t:Tween = create_tween()
	t.tween_property(self, "modulate", Color.TRANSPARENT, .2)
	await t.finished
	queue_free()

func Setup(img:Texture2D, nome:String) -> void:
	%Img.texture = img
	%Nome.text = "[wave]" + nome
