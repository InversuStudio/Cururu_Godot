class_name HurtBox
extends Area2D

## Componente Vida
@export var comp_vida : Vida
## Valor substraído do dano recebido
@export var defesa:int = 0
## Distância do knockback, em metros
@export var distancia_knockback : float = 0.0
## Duração do knockback, em segundos
@export var tempo_knockback : float = 0.0
## Cooldown para receber dano novamente
@export var cooldown_dano: float = 0.0
## Som de acerto
@export var hit_sfx : AudioStream = null
## Recebe o node pai. Usado para knockback
@export var parent: Node2D = null
## Recebe o sprite do pai. Usado para efeito de hit flash
@export var sprite: Node2D = null

var hit_shader: Shader = preload("res://Scripts/Shaders/HitFlash.gdshader")
var s_material: ShaderMaterial = null
var material_sprite: ShaderMaterial= null
var ativo:bool = true

signal hurt
signal counter

var last_hit:HitBox = null

func _ready() -> void:
	if hit_sfx: %SFX.stream = hit_sfx
	if cooldown_dano > 0.0:
		%Timer.wait_time = cooldown_dano
		
	if sprite:
		if sprite.material == null:
			s_material = ShaderMaterial.new()
			s_material.shader = hit_shader
			sprite.material = s_material
		material_sprite = sprite.material

# FUNÇÃO DE RECEBER DANO
func RecebeDano(dano:int, pos_target:Vector2) -> void:
	if !ativo: return
	# Se houver componente de vida, recebe dano
	if comp_vida:
		# Rebe dano subtraído da defesa
		if defesa >= 0:
			comp_vida.RecebeDano(dano - defesa)
		# Se defesa for negativa, recebe dano crítico
		else: comp_vida.RecebeDano(dano * 2)
		# Se vida chegar a zero, e não houver função de morte especificada...
		if comp_vida.vida_atual <= 0 and !comp_vida.parent.has_method("Morte"):
			# ...remove shader para realizar procedimento padrão.
			sprite.material = null
	# Aplica knockback, se for definido
	if distancia_knockback > 0.0 and parent != null:
		CalcKnockback(distancia_knockback, tempo_knockback, pos_target)
		
	call_deferred("AchaHit")
	if cooldown_dano > 0.0:
		# Desabilita colisão
		ativo = false
		# Inicia cooldown
		%Timer.start()
	# Toca som de dano
	if hit_sfx:
		%SFX.pitch_scale = randf_range(.9, 1.1) 
		%SFX.play()
	# VFX dano
	if sprite:
		if sprite.material == null: return
		material_sprite.set_shader_parameter("valor", 1.0)
		await get_tree().create_timer(.2).timeout
		material_sprite.set_shader_parameter("valor", 0.0)

func AchaHit() -> void:
	var areas:Array[Area2D] = get_overlapping_areas()
	var hitbox:Array[HitBox] = []
	for a:Area2D in areas:
		if a is HitBox:
			hitbox.append(a)
	if hitbox.size() > 0:
		last_hit = hitbox[0]
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
	ativo = true
	if last_hit and overlaps_area(last_hit):
		RecebeDano(last_hit.dano, global_position)
