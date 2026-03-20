extends CanvasLayer

var ativo:bool = false

signal tela_item

# Deixando aqui pra não perder
#Aperte B para usar o Pulso D'agua. Esse  ataque abre passagens com Miasma pelo mapa.

func _ready() -> void:
	%AvisoItem.modulate.a = 0.0
	%ColorRect.visible = false

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_accept") and ativo:
		%Anim.play("TelaOff")
		await %Anim.animation_finished
		%ColorRect.visible = false
		ativo = false
		get_tree().paused = false
		tela_item.emit()

func Mostra(nome:String, desc:String, img:Texture2D, action:StringName = "") -> void:
	get_tree().paused = true
	%SFX.play()
	%NomeItemAviso.text = nome
	%ImgItemAviso.texture = img
	
	if action != "":
		var path:StringName = GameData.GetUiButtonImage(action)
		print("Path: " + path)
		desc = desc.replace("BTN", "[img]%s[/img]" % path)
	
	%DescItemAviso.text = desc
	%Seguir.text = %Seguir.text.replace("BTN", "[img]%s[/img]" %
							GameData.GetUiButtonImage("ui_accept"))
	%Seguir.modulate.a = 0.0

	%Anim.play("TelaOn")
	%ColorRect.visible = true
	await %Anim.animation_finished
	var tween:Tween = create_tween()
	tween.tween_property(%Seguir, "modulate", Color.WHITE, .5)
	ativo = true
