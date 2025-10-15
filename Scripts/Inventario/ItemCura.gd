extends ScriptItemInventario

## Valor a ser adicionado à vida atual do player
@export var valor_cura:int = 1

func Logica() -> void:
	var vida:Vida = get_tree().get_first_node_in_group("Player").vida
	vida.RecebeCura(valor_cura)
	parent.disabled = true

func HabilitaBotao() -> void:
	parent.disabled = false
