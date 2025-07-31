extends Control

func _ready() -> void:
	# Conecta UpdateMoeda ao sinal de mudança na quintidade de moedas
	GameData.update_moeda.connect(UpdateMoeda)
	# Se houver arquivo SAVE, atualiza contador de moedas com o número salvo
	var file = OS.get_executable_path().get_base_dir()+"/savedata.cfg"
	if FileAccess.file_exists(file) and GameData.leu_data == false:
		GameData.moedas = GameData.config.get_value("save", "moedas")
		%CounterMoeda.text = str(GameData.moedas)
		GameData.leu_data = true
	# Senão, reseta
	else: %CounterMoeda.text = str(GameData.moedas)

# Função para atualizar contador de moedas
func UpdateMoeda() -> void:
	%CounterMoeda.text = str(GameData.moedas)
