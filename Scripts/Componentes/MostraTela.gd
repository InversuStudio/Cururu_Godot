extends InteractObject

var tela:Node2D = null

func _ready() -> void:
	for c:Node in get_parent().get_children():
		if c is Node2D:
			tela = c
			break
	if tela:
		tela.modulate = Color.TRANSPARENT

func Extra(dentro:bool) -> void:
	print_rich("[color=red]EU FUNCIONO[/color]")
	if tela == null: return
	var tween:Tween = create_tween()
	if dentro:
		tween.tween_property(tela, "modulate", Color.WHITE, .3)
		tela.show()
		return
	tween.tween_property(tela, "modulate", Color.TRANSPARENT, .3)
