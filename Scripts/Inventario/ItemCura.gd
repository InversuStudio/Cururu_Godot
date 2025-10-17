extends ScriptItemInventario

## Valor a ser adicionado à vida atual do player
@export var valor_cura:int = 1

func Logica() -> void:
	var vida:Vida = get_tree().get_first_node_in_group("Player").vida
	vida.RecebeCura(valor_cura)
	Inventario.RemoveItem(parent.id_inventario)
	
	#parent.disabled = true
	#Inventario.HabilitaItem(parent.id_inventario, true)
	#Inventario.inventario[parent.id_inventario][1] = true

func HabilitaBotao() -> void:
	parent.disabled = false
	Inventario.HabilitaItem(parent.id_inventario, false)
