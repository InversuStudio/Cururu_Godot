extends Control

func _ready() -> void:
	GameData.moedas = GameData.config.get_value("save", "moedas")
	GameData.update_moeda.connect(UpdateMoeda)
	%CounterMoeda.text = str(GameData.moedas)

func UpdateMoeda() -> void:
	%CounterMoeda.text = str(GameData.moedas)
	print(GameData.moedas)
