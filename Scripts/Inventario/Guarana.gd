extends ScriptItemInventario

# SCRIPT DUPLICADO POR CAUSA DE BUG DA GODOT
# EU FIQUEI MUITO TEMPO TENTANDO RESOLVER SÓ PRA DESCOBRIR QUE NÃO TEM JEITO
# AGORA É ESPERAREM CONSERTAR NA PRÓXIMA ATUALIZAÇÃO

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
