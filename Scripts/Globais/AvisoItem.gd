extends CanvasLayer

var ativo:bool = false

signal tela_item

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

func Mostra(nome:String, desc:String, img:Texture2D) -> void:
	get_tree().paused = true
	%NomeItemAviso.text = nome
	%DescItemAviso.text = desc
	%ImgItemAviso.texture = img
	%Anim.play("TelaOn")
	%ColorRect.visible = true
	await %Anim.animation_finished
	ativo = true
