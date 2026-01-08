extends Control

@export var item_slot_scene : PackedScene
@onready var container = $Seletor/ItemBar/HBoxContainer
@onready var label_quantidade_total = $Seletor/Label # Ajuste o nome conforme sua cena
@onready var seletor_img = $Seletor

var current_index : int = 0
var slot_width : float = 70.0 

var sprites_ui = {
	"Acai": preload("res://Sprites/UI/HUD/Menu_Rapido/Itens/ACAI.png"),
	"Guarana": preload("res://Sprites/UI/HUD/Menu_Rapido/Itens/GUARA.png")
}

var sprites_seletor ={
	"padrao": preload("res://Sprites/UI/HUD/Menu_Rapido/UIHUD - SELETOR DE ITEM.png"),
	"bumper_direito": preload("res://Sprites/UI/HUD/Menu_Rapido/UIHUD - SELETOR DE ITEM_RB.png"),
	"bumper_esquerdo": preload("res://Sprites/UI/HUD/Menu_Rapido/UIHUD - SELETOR DE ITEM_LB.png"),
	"usar_item": preload("res://Sprites/UI/HUD/Menu_Rapido/UIHUD - SELETOR DE ITEM_Y.png")
}

func _ready():
	# Conecta os sinais que você já tem no inventário
	Inventario.add_item.connect(_on_inventario_alterado)
	Inventario.del_item.connect(_on_inventario_alterado)
	
	atualizar_barra()
	
# Função auxiliar para o sinal não precisar de parâmetros
func _on_inventario_alterado(_item = null, _qtd = null):
	atualizar_barra()

func _input(event):
	# Girar para a direita
	if event.is_action_pressed("bumper_direito"):
		seletor_img.texture = sprites_seletor["bumper_direito"]
		navegar(1)
	
	# Girar para a esquerda
	elif event.is_action_pressed("bumper_esquerdo"):
		seletor_img.texture = sprites_seletor["bumper_esquerdo"]
		navegar(-1)
	
	# Usar o item selecionado
	elif event.is_action_pressed("usar_item"):
		seletor_img.texture = sprites_seletor["usar_item"]
		usar_item_selecionado()
		
	if (event.is_action_released("bumper_direito") 
	or event.is_action_released("bumper_esquerdo") 
	or event.is_action_released("usar_item")):
		seletor_img.texture = sprites_seletor["padrao"]

func navegar(direcao: int): # direcao pode ser 1 para frente e -1 para trás
	var total = container.get_child_count()
	if total <= 1: return

	# 1. Esconde o item que estava aparecendo
	container.get_child(current_index).visible = false
	
	# 2. Calcula o novo índice rotatório
	current_index = (current_index + direcao + total) % total
	
	# 3. Mostra o novo item
	var novo_item_visivel = container.get_child(current_index)
	novo_item_visivel.visible = true
	
	# 4. ATUALIZAÇÃO DO HUD (Importante)
	atualizar_barra()

# FUNÇÃO PARA ATUALIZAR A BARRA DE ITENS
func atualizar_barra():
	# 1. Limpa os slots
	for child in container.get_children():
		child.queue_free()
	
	# 2. Cria os slots baseados no inventário
	for i in range(Inventario.inventario.size()):
		var dados = Inventario.inventario[i]
		var item_id = dados[0]
		var novo_slot = item_slot_scene.instantiate()
		container.add_child(novo_slot)
		
		# 3. ATRIBUIÇÃO DA TEXTURA
		var sprite_alvo = sprites_ui.get(item_id)
		if sprite_alvo != null:
			# Procure o nó 'Icone' (TextureRect) dentro do seu ItemSlot
			var icone_node = novo_slot.get_node("Icone") 
			icone_node.texture = sprite_alvo # Força a aplicação da textura
		else:
			print("ERRO: ID '", item_id, "' não encontrado no dicionário sprites_ui!")
		
		# 4. Lógica de visibilidade: apenas o selecionado aparece
		novo_slot.visible = (i == current_index)

	# 5. Atualiza o Label que agora está no fundo (TextureRect pai)
	atualizar_valor_quantidade()

# FUNÇÃO PARA ATUALIZAR O NÚMERO DE ITENS 
func atualizar_valor_quantidade():
	var inventario = Inventario.inventario
	
	# 1. Verifica se há itens no inventário e se o índice é válido
	if inventario.size() > 0 and current_index < inventario.size():
		var dados_item = inventario[current_index]
		var quantidade = dados_item[1] # O segundo valor do array é a quantidade
		
		# 2. Atualiza o texto e garante que ele apareça
		label_quantidade_total.text = str(quantidade)
		label_quantidade_total.visible = (quantidade >= 1)
	else:
		# 3. Se o inventário estiver vazio, esconde o número
		label_quantidade_total.visible = false


# FUNÇÃO PARA APLICAR O EFEITO DO ITEM
func aplicar_efeito_item(nome):
	# Precisamos achar o Player para dar o item a ele
	# Certifique-se de que seu Player está no grupo "Player"
	var player = get_tree().get_first_node_in_group("Player")
	
	if player == null:
		push_error("ERRO: Nenhum nó encontrado no grupo 'Player'!")
		return

	# Aqui decidimos o que cada item faz
	match nome:
		"Acai":
			player.vida.RecebeCura(2)
			print("Recuperou vida com Açaí!")
		"Guarana":
			player.vida.RecebeCura(3)
			print("Recuperou fôlego com Guaraná!")
		_:
			print("Item sem efeito definido: ", nome)

#FUNÇÃO PARA USAR O ITEM SELECIONADO
func usar_item_selecionado():
	if Inventario.inventario.size() > 0:
		# Pega os dados do item antes de removê-lo
		var dados = Inventario.inventario[current_index]
		var nome_item = dados[0]
		
		# Agora a função abaixo vai existir e o erro sumirá!
		aplicar_efeito_item(nome_item)
		
		# Usa a função que você já tem no seu Inventário Global
		Inventario.RemoveItem(current_index)
		

#FUNÇÃO PARA MUDAR O ITEM SELECIONADO
func mudar_item(direction):
	var total_items = container.get_child_count()
	if total_items == 0: return

	# Atualiza o índice e trava entre 0 e o máximo de itens
	current_index = clamp(current_index + direction, 0, total_items - 1)
	
	# Cálculo de centralização:
	# Pegamos a largura do slot + a separação do HBoxContainer
	var separacao = container.get_theme_constant("separation")
	var largura_total = slot_width + separacao
	
	# O sinal negativo (-) faz a barra ir para a esquerda quando o índice aumenta
	var target_x = -(current_index * largura_total)
	
	# Move suavemente
	var tween = create_tween()
	tween.tween_property(container, "position:x", target_x, 0.15).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	
