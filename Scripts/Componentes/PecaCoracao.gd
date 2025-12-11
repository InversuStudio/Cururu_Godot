extends Area2D

#@export var id:Mundos.PecasCoracao
## ID único ao ser salvo após ser coletado
@export var nome_id:String = ""

@export_group("Tela de Item")
## Nome que irá aparecer na tela de item coletado
@export var nome_tela:String = ""
## Descrição que irá aparecer na tela de item coletado
@export_multiline var descricao_tela:String = ""
## Imagem que irá aparecer na tela de item coletado
@export var imagem_tela:Texture2D = null

func _ready() -> void:
	for i:String in Mundos.pecas_coracao:
		if i == nome_id: queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		#Mundos.pecas_coracao[id] = true
		if nome_id != "":
			Mundos.pecas_coracao.append(nome_id)
		GameData.peca_coracao += 1
		# Lança aviso
		AvisoItem.Mostra(nome_tela, descricao_tela, imagem_tela)
		# Deleta
		queue_free()

func SfxTocou(s:AudioStreamPlayer) -> void:
	s.queue_free()
	call_deferred("queue_free")
