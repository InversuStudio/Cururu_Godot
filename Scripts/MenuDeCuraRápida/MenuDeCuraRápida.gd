extends Control

@export var item_slot_scene : PackedScene
@onready var container = $ItemBar/HBoxContainer

var current_index : int = 0
var slot_width : float = 70.0 

func _ready():
	# Conecta os sinais que você já tem no inventário
	Inventario.add_item.connect(_on_inventario_alterado)
	Inventario.del_item.connect(_on_inventario_alterado)
	
	atualizar_barra()
	
# Função auxiliar para o sinal não precisar de parâmetros
func _on_inventario_alterado(_item = null, _qtd = null):
	atualizar_barra()

func _input(event):
	#Se o inventário estiver aberto trava o menu de cura
	
	# Girar para a direita
	if event.is_action_pressed("bumper_direito"):
		mudar_item(1)
	
	# Girar para a esquerda
	elif event.is_action_pressed("bumper_esquerdo"):
		mudar_item(-1)
	
	# Usar o item selecionado
	elif event.is_action_pressed("usar_item"):
		usar_item_selecionado()

# FUNÇÃO PARA ATUALIZAR A BARRA DE ITENS
func atualizar_barra():
	# 1. Limpa a barra
	for child in container.get_children():
		child.queue_free()
	
	# 2. Cria os slots (sua versão funcional)
	for i in range(Inventario.inventario.size()):
		var dados_item = Inventario.inventario[i]
		var quantidade = dados_item[1]
		var novo_slot = item_slot_scene.instantiate()
		container.add_child(novo_slot)
		
		var cena_item = Inventario.lista_itens[dados_item[0]]
		var item_temp = cena_item.instantiate()
		
		# Passa os dados para o slot
		novo_slot.atualizar_slot(item_temp.sprite_normal, quantidade)
		item_temp.queue_free()

	# 3. O SEGREDO DO INÍCIO DO JOGO:
	# Esperamos o frame para o Godot calcular o 'size' dos slots recém-criados
	await get_tree().process_frame
	current_index = 0
	atualizar_destaque_visual()
	mudar_item(0) # Posiciona a barra

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
		
#FUNÇÃO PARA ATUALIZAR O DESTAQUE DO ITEM
func atualizar_destaque_visual():
	for i in range(container.get_child_count()):
		var slot = container.get_child(i)
		
		if i == current_index:
			# Item selecionado: Aumenta e fica brilhante
			slot.scale = Vector2(1.0, 1.0)
			slot.modulate.a = 1.0
		else:
			# Itens laterais: Diminui e fica transparente
			slot.scale = Vector2(0.8, 0.8)
			slot.modulate.a = 0.5
			slot.pivot_offset = slot.size / 2

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
	
	# Atualiza o visual dos ícones (opcional, mas fica lindo)
	atualizar_destaque_visual()
