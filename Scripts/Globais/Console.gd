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
			DisablePlayer(true)
		else:
			%Console.show()
			%LinhaComando.grab_focus()
			DisablePlayer()
			$Timer.start(.1)
			await $Timer.timeout
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
					await Mundos.fase_mudou
					DisablePlayer()
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
	%LinhaComando.grab_focus()

func DisablePlayer(val:bool = false) -> void:
	if Mundos.player == null: return
	Mundos.player.pode_mover = val
	Mundos.player.input_move.x = 0.0
	Mundos.player.velocity.x = 0.0
	Mundos.player.pode_ataque = val
	Mundos.player.pode_dash = val
	Mundos.player.pode_item = val
