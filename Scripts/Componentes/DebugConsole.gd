class_name DebugConsole
extends Control

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("console"):
		if %Console.visible:
			%Console.hide()
		else: %Console.show()

func AddTexto(txt:String) -> void:
	%TextoConsole.text += txt + "[br]"
