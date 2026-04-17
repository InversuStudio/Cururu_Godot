extends ScriptItemInventario

@export var valor_magia: int = 50

func Logica() -> void:
	if GameData.magia_atual >= GameData.magia_max: return
	GameData.magia_atual = min(GameData.magia_atual + valor_magia, GameData.magia_max)
	GameData.update_magia.emit()
	Inventario.RemoveItem(pai.id_inventario)
