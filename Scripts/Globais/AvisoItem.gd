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
	%DescItemAviso.text = desc
	%ImgItemAviso.texture = img
	if action != "":
		var btn:Array[StringName] = GameData.GetUiButtonImage(action)
		%ImgBtn.texture = load(btn[0])
		%ImgBtn.get_child(0).text = btn[1]
		%Comando.show()

	else: %Comando.hide()
			
	%Anim.play("TelaOn")
	%ColorRect.visible = true
	await %Anim.animation_finished
	ativo = true
