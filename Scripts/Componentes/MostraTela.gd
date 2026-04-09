extends InteractObject

var tela:Node = null
# Recebe a RichTextLabel que contém o texto
var texto:RichTextLabel = null
var og_txt:String = ""

func _ready() -> void:
	GameData.connect("tipo_input_mudou", UpdateInput)
	for c:Node in get_parent().get_children():
		if c is Sprite2D or c is AnimatedSprite2D or c is Control:
			tela = c
			for ch:Node in c.get_children():
				if ch is RichTextLabel:
					ch.bbcode_enabled = true
					texto = ch
					og_txt = texto.text
			#break
		
	if tela:
		tela.modulate = Color.TRANSPARENT
	if texto:
		var path = GameData.GetUiButtonImage("dash")
		print("PATH DASH: ", path)
		print("TIPO INPUT: ", GameData.tipo_input)
		UpdateInput()

func UpdateInput() -> void:
	if texto:
		texto.text = og_txt.replace(
			"BTN", "[img]%s[/img]" % GameData.GetUiButtonImage(texto.name))

func Extra(dentro:bool) -> void:
	if tela == null: return
	var tween:Tween = create_tween()
	if dentro:
		tween.tween_property(tela, "modulate", Color.WHITE, .3)
		tela.show()
	else:
		tween.tween_property(tela, "modulate", Color.TRANSPARENT, .3)
