extends Node

func _ready() -> void:
	%LinhaComando.connect("text_submitted", Comando)
	%Console.hide()
	MudaAbaSelect()

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("console"):
		if %Console.visible:
			%Console.hide()
			%TextoConsole.text = ""
			%StatePlayer.text = ""
		else:
			%Console.show()

func _Print(txt:Variant) -> void:
	%TextoConsole.text += str(txt) + "[br]"

func _State(txt:String) -> void:
	%StatePlayer.text += "State: " + txt + "[br]"

func MudaAbaSelect() -> void:
	%Fase.text = Mundos.fase_atual

func Comando(line:String) -> void:
	var cmd:PackedStringArray = line.split(" ")
	match cmd[0]:
		"fase":
			for p:Array in Mundos.lista_fases:
				if cmd[1] == p[1].get_slice(".", 0):
					var place:String = "res://Cenas/%s/%s/" % [p[0], p[1]]
					Mundos.CarregaFase(place)
					_Print(
						"[color=dark_green]Trocou de fase: %s[/color]" % [cmd[1]])
					break
	%LinhaComando.text = ""
