extends ScriptItemInventario

@export var valor_magia: int = 1

func Logica() -> void:
	GameData.magia_atual = min(GameData.magia_atual + valor_magia, GameData.magia_max)
	GameData.update_magia.emit()
	Inventario.RemoveItem(pai.id_inventario)
