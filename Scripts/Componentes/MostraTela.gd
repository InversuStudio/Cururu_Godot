extends InteractObject

var tela:Node2D = null

func _ready() -> void:
	for c:Node in get_parent().get_children():
		if c is Sprite2D or c is AnimatedSprite2D:
			tela = c
			break
	if tela:
		tela.modulate = Color.TRANSPARENT

func Extra(dentro:bool) -> void:
	if tela == null: return
	var tween:Tween = create_tween()
	if dentro:
		tween.tween_property(tela, "modulate", Color.WHITE, .3)
		tela.show()
	else:
		tween.tween_property(tela, "modulate", Color.TRANSPARENT, .3)
