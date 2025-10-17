extends Node2D

## Possíveis itens a serem dropados pelo baú
@export var drop_item: Array[PackedScene] = []

var aberto:bool = false

func _on_hurt_box_hurt(_h:Array[HitBox]) -> void:
	if not aberto and drop_item.size() > 0:
		aberto = true
		$Sprite.play("Abre")
		var rand:int = randi_range(0, drop_item.size() - 1)
		var item:Node2D = drop_item[rand].instantiate()
		add_child(item)
		item.global_position = $PosItem.global_position
		
