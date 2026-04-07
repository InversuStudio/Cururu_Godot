extends InteractObject

var tela:Node = null
# Recebe a RichTextLabel que contém o texto
var texto:RichTextLabel = null

func _ready() -> void:
	for c:Node in get_parent().get_children():
		if c is Sprite2D or c is AnimatedSprite2D or c is Control:
			tela = c
			for ch:Node in c.get_children():
				if ch is RichTextLabel:
					ch.bbcode_enabled = true
					texto = ch
			#break
		
	if tela:
		tela.modulate = Color.TRANSPARENT
	if texto:
		texto.text = texto.text.replace(
			"BTN", "[img]%s[/img]" % GameData.GetUiButtonImage(texto.name))

func Extra(dentro:bool) -> void:
	if tela == null: return
	var tween:Tween = create_tween()
	if dentro:
		tween.tween_property(tela, "modulate", Color.WHITE, .3)
		tela.show()
	else:
		tween.tween_property(tela, "modulate", Color.TRANSPARENT, .3)
