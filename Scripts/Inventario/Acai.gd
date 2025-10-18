extends ScriptItemInventario

## Valor a ser adicionado à vida atual do player
@export var valor_cura:int = 1

func _ready() -> void:
	pai.connect("pressed", func(): Logica())

func Logica() -> void:
	var vida:Vida = get_tree().get_first_node_in_group("Player").vida
	if vida:
		vida.RecebeCura(valor_cura)
		Inventario.RemoveItem(pai.id_inventario)

#func HabilitaBotao() -> void:
	#parent.disabled = false
	#Inventario.HabilitaItem(parent.id_inventario, false)
