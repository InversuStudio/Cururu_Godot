extends Area2D

## Item a ser adicionado ao inventário
@export var tipo_item: Inventario.Amuletos

@export_group("Tela de Item")
## Nome que irá aparecer na tela de item coletado
@export var nome_tela:String = ""
## Descrição que irá aparecer na tela de item coletado
@export_multiline var descricao_tela:String = ""
## Imagem que irá aparecer na tela de item coletado
@export var imagem_tela:Texture2D = null

func _ready() -> void:
	for am:Array in Inventario.amuletos:
		if am[0] == Inventario.AmuletosString[tipo_item]:
			queue_free()
	connect("body_entered", _on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		Inventario.AddAmuleto(Inventario.AmuletosString[tipo_item])
		AvisoItem.Mostra(nome_tela, descricao_tela, imagem_tela)
		queue_free()
