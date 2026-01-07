# ItemSlot.gd
extends Control

@onready var texture_rect = $TextureRect
@onready var label = $Label

var comecar_selecionado: bool = false
# FUNÇÃO DE ATUALIZAR A IMAGEM DO SLOT
func atualizar_slot(nova_imagem, qtd):
	# A variável 'nova_imagem' já é o arquivo de imagem (CompressedTexture2D)
	# Por isso, apenas atribuímos ela diretamente ao nó TextureRect
	$TextureRect.texture = nova_imagem 
	
	$Label.text = str(qtd)
	$Label.visible = qtd >= 1
