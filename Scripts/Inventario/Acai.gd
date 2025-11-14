extends ScriptItemInventario

# SCRIPT DUPLICADO POR CAUSA DE BUG

## Valor a ser adicionado à vida atual do player
@export var valor_cura:int = 1

#func _ready() -> void:
	#pai.connect("pressed", func(): Logica())
	#Inventario.add_item.connect(func(_s:String, _i:int):
		#get_parent().UpdateNumItem()
		#print("UPDATE!!!"))

func Logica() -> void:
	var vida:Vida = get_tree().get_first_node_in_group("Player").vida
	if vida:
		vida.RecebeCura(valor_cura)
		Inventario.RemoveItem(pai.id_inventario)
