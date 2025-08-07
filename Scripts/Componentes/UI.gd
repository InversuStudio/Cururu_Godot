extends Control

# Recebe se o player morreu
var player_morreu: bool = false

func _ready() -> void:
	var player:CharacterBody2D = get_tree().get_first_node_in_group("Player")
	# Se achar Player na cena...
	if player:
		# Inicializa valores da barra de vida
		var vida:int = player.vida.vida_max
		%BarraVida.max_value = vida
		if GameData.vida_atual > 0:
			%BarraVida.value = GameData.vida_atual
		else: %BarraVida.value = vida
		# Conecta sinais de dano, cura e morte
		player.vida.connect("recebeu_dano", UpdateVida.bind(player))
		player.vida.connect("recebeu_vida", UpdateVida.bind(player))
		player.vida.connect("morreu", PlayerMorreu)
	# Conecta UpdateMoeda ao sinal de mudança na quintidade de moedas
	GameData.update_moeda.connect(UpdateMoeda)
	# Se ainda não leu o arquivo de save...
	if GameData.leu_data == false:
		# ...e houver arquivo de save...
		if GameData.config.has_section_key("save", "moedas"):
		# ...atualiza contador de moedas com o número salvo
			GameData.moedas = GameData.config.get_value("save", "moedas")
			GameData.leu_data = true
	# Atualiza contador pela primeira vez
	UpdateMoeda()

# Funcção para sinalizar que player morreu
func PlayerMorreu() -> void:
	player_morreu = true

# Função para atualizar contador de moedas
func UpdateMoeda() -> void:
	# Funciona apenas se o player não estiver morto
	if player_morreu == false:
		%CounterMoeda.text = str(GameData.moedas)

# Função para alterar valor da barra de vida
func UpdateVida(player:CharacterBody2D) -> void:
	%BarraVida.value = player.vida.vida_atual
