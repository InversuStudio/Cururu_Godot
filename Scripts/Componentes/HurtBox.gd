class_name HurtBox
extends Area2D

## Componente Vida
@export var comp_vida : Vida
## Distância do knockback, em metros
@export var distancia_knockback : float = 0.0
## Duração do knockback, em segundos
@export var tempo_knockback : float = 0.0
## Cooldown para receber dano novamente
@export var cooldown_dano: float = 0.0
## Som de acerto
@export var hit_sfx : AudioStream = null
## Recebe o node pai
@export var parent: Node2D = null
## Recebe o sprite do pai
@export var sprite: Node2D = null

var hit_shader: Shader = preload("res://Scripts/Shaders/HitFlash.gdshader")
var s_material: ShaderMaterial = null
var material_sprite: ShaderMaterial= null

signal hurt
signal counter

var col:CollisionShape2D = null

func _ready() -> void:
	if hit_sfx: %SFX.stream = hit_sfx
	if cooldown_dano > 0.0:
		%Timer.wait_time = cooldown_dano
	for c:Node in get_children():
		if c is CollisionShape2D:
			col = c
	if sprite:
		s_material = ShaderMaterial.new()
		s_material.shader = hit_shader
		sprite.material = s_material
		material_sprite = sprite.material

# FUNÇÃO DE RECEBER DANO
func RecebeDano(dano:int, pos_target:Vector2):
	# Se houver componente de vida, recebe dano
	if comp_vida:
		comp_vida.RecebeDano(dano)
	# Aplica knockback, se for definido
	if distancia_knockback > 0.0 and parent != null:
		CalcKnockback(distancia_knockback, tempo_knockback, pos_target)
		
	call_deferred("AchaHit")
	if cooldown_dano > 0.0:
		# Desabilita colisão
		col.set_deferred("disabled", true)
		# Inicia cooldown
		%Timer.start()
	# Toca som de dano
	if hit_sfx: %SFX.play()
	# VFX dano
	if sprite:
		#var coisa:ShaderMaterial = sprite.material
		material_sprite.set_shader_parameter("valor", 1.0)
		await get_tree().create_timer(.2).timeout
		material_sprite.set_shader_parameter("valor", 0.0)
		#sprite.material.shader.valor = 1.0# set_instance_shader_parameter("valor", 1.0)
		#sprite.material.set_instance_shader_parameter("valor", 0.0)

func AchaHit() -> void:
	var areas:Array[Area2D] = get_overlapping_areas()
	var hitbox:Array[HitBox] = []
	for a:Area2D in areas:
		if a is HitBox:
			hitbox.append(a)
	hurt.emit(hitbox)

func CalcKnockback(dist:float, time:float, pos_target:Vector2) -> void:
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
		var c:float = ((2.0 * dist) / pow(time, 2)) * 128
		counter.emit(c, dir)

func _on_timer_timeout() -> void:
	col.set_deferred("disabled", false)
