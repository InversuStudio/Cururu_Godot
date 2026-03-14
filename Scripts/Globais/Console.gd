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
			if Mundos.player:
				Mundos.player.pode_mover = true
				Mundos.player.pode_ataque = true
				Mundos.player.pode_dash = true
				Mundos.player.pode_item = true
		else:
			%Console.show()
			%LinhaComando.grab_focus()
			if Mundos.player:
				Mundos.player.pode_mover = false
				Mundos.player.pode_ataque = false
				Mundos.player.pode_dash = false
				Mundos.player.pode_item = false
			await get_tree().create_timer(.1).timeout
			%LinhaComando.text = ""

func _Print(txt:Variant) -> void:
	if %Console.visible:
		%TextoConsole.text += str(txt) + "[br]"

func _State(txt:String) -> void:
	if %Console.visible:
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
		
		"save":
			GameData.Save()
		
		"load":
			GameData.leu_data = false
			if await GameData.Load():
				Console._Print("[color=dark_green]Save carregado[/color]")
			else:
				Console._Print("[color=dark_red]Save não encontrado[/color]")
		
		"kill":
			Mundos.player.vida.RecebeDano(Mundos.player.vida.vida_max)
		
		"speed":
			Engine.time_scale = float(cmd[1])
			
	
	%LinhaComando.text = ""
