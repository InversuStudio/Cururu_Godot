extends ScriptItemInventario

@export var tempo_ate_recuperar:float = 10.0

func _ready() -> void:
	%Timer.connect("timeout", Tempo)
	
	if Inventario.amuletos[pai.id_inventario][1] == true:
		%Timer.start(tempo_ate_recuperar)
	
	%Timer.start(tempo_ate_recuperar)
	
func Logica() -> void:
	var result:bool = Inventario.SetAmuleto(Inventario.AmuletosString[pai.item])
	print(result)
	if result: %Timer.start()
	else: %Timer.stop()

func Tempo() -> void:
	GameData.magia_atual += 1
