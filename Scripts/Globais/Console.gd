extends Node

func _ready() -> void:
	%Console.hide()
	for fase:String in Mundos.NomeFase:
		%Fase.add_item(fase)
	%Fase.select(Mundos.fase_atual)
	%Fase.connect("item_selected", func(id:int):
		Mundos.CarregaFase(id))

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("console"):
		if %Console.visible:
			%Console.hide()
		else:
			%Console.show()

func _Print(txt:Variant) -> void:
	%TextoConsole.text += str(txt) + "[br]"

func _State(txt:String) -> void:
	%StatePlayer.text += "State: " + txt + "[br]"

func MudaAbaSelect() -> void:
	%Fase.select(Mundos.fase_atual)
