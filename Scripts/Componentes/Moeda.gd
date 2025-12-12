extends RigidBody2D

## Valor a ser somado a quantia total
@export var valor_moeda: int = 1
## Efeito sonoro aoser coletado
@export var sfx: AudioStream = null
## Força do impulso aplicado ao item quando spawnado
@export var forca_impulso:float = 10.0

#var dir: Vector2 = Vector2.ZERO
var velocity: Vector2 = Vector2.ZERO

func _ready() -> void:
	var dir:Vector2 = Vector2(randf_range(-1, 1), randf_range(-1, -0.5)).normalized()
	velocity = dir * forca_impulso

func _physics_process(_delta: float) -> void:
	velocity = velocity.move_toward(Vector2.ZERO, 0.1)
	move_and_collide(velocity)

func SfxTocou(s:AudioStreamPlayer) -> void:
	s.queue_free()
	call_deferred("queue_free")

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		# Desabilita colisão
		set_deferred("monitoring", false)
		# Soma valor ao total obtido
		GameData.moedas += valor_moeda
		Console._Print(GameData.moedas)
		
		#Eleva a moeda e deixa o sprite transparente, depois deleta
		var tweenPos = get_tree().create_tween()
		var tweenMod = get_tree().create_tween()
		
		tweenPos.tween_property(self, "position", position - Vector2(0, 75), 0.3)
		tweenMod.tween_property(self, "modulate:a", 0, 0.3)
		
		tweenPos.tween_callback(queue_free)
		
		# Toca som
		if sfx:
			var s:AudioStreamPlayer = AudioStreamPlayer.new()
			s.bus = "SFX"
			s.stream = sfx
			get_tree().current_scene.add_child(s)
			s.finished.connect(SfxTocou.bind(s))
			s.volume_db = -5.0
			s.play()
			#return
