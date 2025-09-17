class_name DebugConsole
extends Control

func _ready() -> void:
	if Console.ativo:
		%Console.show()
	else: %Console.hide()

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("console"):
		if %Console.visible:
			Console.ativo = false
			%Console.hide()
		else:
			Console.ativo = true
			%Console.show()

func AddTexto(txt:String) -> void:
	%TextoConsole.text += txt + "[br]"

func StatePlayer(txt:String) -> void:
	%StatePlayer.text += "State: " + txt + "[br]"
