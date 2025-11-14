extends ScriptItemInventario

@export var ataque_speed:float = .7

func _ready() -> void:
	GameData.ataque_anim_speed = 1.3

func Logica() -> void:
	var result:bool = Inventario.SetAmuleto(Inventario.AmuletosString[pai.item])
	GameData.ataque_anim_speed = 1.3 if result else 1.0
