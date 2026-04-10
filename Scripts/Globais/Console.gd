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
	if Input.is_action_pressed("ui_cancel") and GameData.tipo_input == 0:
		var e:Array[InputEvent] = InputMap.action_get_events("ui_cancel")
		var key:String = ""
		for ie: InputEvent in e:
			if ie is InputEventKey:
				key = OS.get_keycode_string(ie.physical_keycode)
				break
		if !Input.is_physical_key_pressed(KEY_SHIFT):
			key = key.to_lower()
		%LinhaComando.text += key
		%LinhaComando.release_focus()
		await get_tree().create_timer(.1).timeout
		%LinhaComando.grab_focus()
		%LinhaComando.caret_column = %LinhaComando.text.length()
		

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
			for p:PackedStringArray in Mundos.lista_fases:
				if cmd[1] == p[1].get_slice(".", 0):
					var place:String = "res://Cenas/%s/%s/" % [p[0], p[1]]
					LoadCena.Load(place)
					_Print(
						"[color=dark_green]Trocou de fase: %s[/color]" % [cmd[1]])
					await get_tree().scene_changed
					DisablePlayer()
					break
		
		"save":
			GameData.Save()
		
		"load":
			GameData.leu_data = false
			if GameData.Load():
				Console._Print("[color=dark_green]Save carregado[/color]")
			else:
				Console._Print("[color=dark_red]Save não encontrado[/color]")
		
		"kill":
			Mundos.player.vida.RecebeDano(Mundos.player.vida.vida_max)
		
		"speed":
			Engine.time_scale = float(cmd[1])
			
	%LinhaComando.text = ""
	%LinhaComando.grab_focus()

func DisablePlayer(pode_mover:bool = false) -> void:
	if Mundos.player == null: return
	Mundos.player.pode_mover = pode_mover
	Mundos.player.input_move.x = 0.0
	Mundos.player.velocity.x = 0.0
	Mundos.player.pode_ataque = pode_mover
	Mundos.player.pode_dash = pode_mover
	Mundos.player.pode_item = pode_mover
