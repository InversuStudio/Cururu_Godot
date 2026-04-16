extends StaticBody2D

func _ready() -> void:
	$HurtBox.comp_vida.alterou_vida.connect(_on_vida_changed)

func _on_vida_changed(vida_atual:int, _vida_antiga:int) -> void:
	print("Vida: ", vida_atual)

func Morte() -> void:
	$HurtBox.comp_vida.vida_atual = $HurtBox.comp_vida.vida_max
