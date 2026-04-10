class_name HitBox
extends Area2D

## Dano aplicado a uma HurtBox
@export var dano: int = 1
## Hurtbox a ser ignorada
@export var ignore: Array[HurtBox] = []
## Efeito sonoro
@export var sfx : AudioStream = null
## Recebe o node pai
@export var parent: Node2D = null
## O quanto a câmera vai tremer ao acertar
@export var camera_shake:float = 20.0
## Tempo que jogo congela ao acertar
@export var hit_freeze:float = .05

@export var vfx:PackedScene = null

signal hit
#signal pushback

func _ready() -> void:
	if sfx: $SFX.stream = sfx

func _on_area_entered(area: Area2D) -> void:
	if area is HurtBox: # Se a colisão for uma HurtBox
		for h:HurtBox in ignore:
			if area == h: return
		if !area.ativo: return
		hit.emit(area.global_position, self, area.collision_layer)
		area.RecebeDano(dano, global_position)
		if vfx and parent:
			HitVFX(area)
		Mundos.HitFreeze(hit_freeze)
		if get_tree().get_first_node_in_group("MainCamera"):
			get_tree().get_first_node_in_group("MainCamera").Shake(camera_shake)
		# Toca som
		if sfx:
			$SFX.play()

func HitVFX(area:Area2D) -> void:
	var self_shape:Shape2D = null
	var self_xform:Transform2D
	var other_shape:Shape2D = null
	var other_xform:Transform2D

	for c:Node in get_children():
		if c is CollisionObject2D:
			self_shape = c.shape
			self_xform = c.transform
			break
		elif c is CollisionPolygon2D:
			var shape:ConcavePolygonShape2D = ConcavePolygonShape2D.new()
			shape.segments = c.polygon
			self_shape = shape
			self_xform = c.transform
	
	for c:Node in area.get_children():
		if c is CollisionShape2D:
			other_shape = c.shape
			other_xform = c.transform
			break
		elif c is CollisionPolygon2D:
			var shape:ConcavePolygonShape2D = ConcavePolygonShape2D.new()
			shape.segments = c.polygon
			other_shape = shape
			other_xform = c.transform
	
	var points:PackedVector2Array = self_shape.collide_and_get_contacts(
		self_xform, other_shape, other_xform)
	
	var fx:Node2D = vfx.instantiate()
	var ponto:Vector2 = Vector2(0,0)
	for p:Vector2 in points:
		if p > ponto: p = ponto
	
	fx.global_position = to_global(ponto)#area.get_child(0).global_position
	parent.get_parent().add_child(fx)
	if fx is GPUParticles2D:
		fx.finished.connect(fx.queue_free)
		fx.restart()
	elif fx is AnimatedSprite2D:
		fx.animation_finished.connect(fx.queue_free)

func CalcPushback(dist:float, time:float, pos_target:Vector2) -> void:
	# Define direção do knockback
	var dir:Vector2 = (global_position - pos_target).normalized()
	# Define a força do knockback
	var knockback:float = ((2.0 * dist) / time) * 128
	# Calcula a velocidade a ser aplicada
	var result_vel:Vector2 = dir * knockback
	if parent is CharacterBody2D:
		# Aplica velocidade
		parent.velocity = result_vel
		# Calcula força oposta (desaceleração)
		#var c:float = ((2.0 * dist) / pow(time, 2)) * 128
		#pushback.emit(c, dir)
