extends Control

func _ready() -> void:
	# Conecta UpdateMoeda ao sinal de mudança na quintidade de moedas
	GameData.update_moeda.connect(UpdateMoeda)
	# Se houver arquivo SAVE, atualiza contador de moedas com o número salvo
	var file = OS.get_executable_path().get_base_dir()+"/savedata.cfg"
	if FileAccess.file_exists(file):
		GameData.moedas = GameData.config.get_value("save", "moedas")
		%CounterMoeda.text = str(GameData.moedas)
	# Senão, reseta
	else: GameData.moedas = 0

# Função para atualizar contador de moedas
func UpdateMoeda() -> void:
	%CounterMoeda.text = str(GameData.moedas)
