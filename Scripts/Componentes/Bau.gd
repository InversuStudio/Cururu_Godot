extends Node2D

## Itens a serem dropados pelo baú
@export var drop_item: Array[PackedScene] = []
## Se for verdadeiro, o baú irá dropar todos os itens da lista de drop.[br]
## Caso contrário, irá dropar um item aleatório da lista[br]
@export var multi_drop: bool = false

var aberto:bool = false

func _on_hurt_box_hurt(_h:Array[HitBox]) -> void:
	if not aberto and drop_item.size() > 0:
		aberto = true
		$Sprite.play("Abre")
		if multi_drop:
			for i:PackedScene in drop_item:
				var item:Node2D = i.instantiate()
				add_child(item)
				item.global_position = $PosItem.global_position
		else:
			var rand:int = randi_range(0, drop_item.size() - 1)
			var item:Node2D = drop_item[rand].instantiate()
			add_child(item)
			item.global_position = $PosItem.global_position
		
