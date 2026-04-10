extends Node2D

## Porcentagem da magia total a ser recuperada
@export_range(1, 100, 1, "suffix:%") var magia_a_recuperar:float = 50

func Morte() -> void:
	var result:int = roundi((magia_a_recuperar / 100) * GameData.magia_max)
	GameData.magia_atual += result
	$Vida.MorteFX()
