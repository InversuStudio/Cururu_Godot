extends Control

func _ready() -> void:
	var file = OS.get_executable_path().get_base_dir()+"/savedata.cfg"
	if FileAccess.file_exists(file):
		GameData.moedas = GameData.config.get_value("save", "moedas")
		GameData.update_moeda.connect(UpdateMoeda)
		%CounterMoeda.text = str(GameData.moedas)

func UpdateMoeda() -> void:
	%CounterMoeda.text = str(GameData.moedas)
	print(GameData.moedas)
