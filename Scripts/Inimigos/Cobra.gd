extends CharacterBody2D

@export var velocidade: float = 0.0
var dir: int = 1

var id:String = ""

var tomou_dano:bool = false
var morreu:bool = false

func _ready() -> void:
	# Gera ID
	id = str(Mundos.fase_atual) + name
	# Checa se já foi morto
	for i:String in Mundos.lista_inimigos:
		if i == id:
			queue_free()
			
	$Vida.alterou_vida.connect(func(_v_new, _v_old) -> void:
		tomou_dano = true
		await get_tree().create_timer(.2).timeout
		tomou_dano = false)
	
	velocidade *= 128
	var rand: int = randi_range(0,1)
	match rand:
		0:
			dir = -1
		1:
			dir = 1
	
	%Flip.scale.x = dir
	%HitBoxMordida.set_deferred("monitoring", false)

func _physics_process(delta: float) -> void:
	if !is_on_floor():
		velocity.y += 10 * 128 * delta
	
	if !tomou_dano:
		velocity.x = move_toward(velocity.x, velocidade * dir, velocidade / 8.0)
	
	if %RayDireita.is_colliding() or !%RayVazioDireita.is_colliding():
		if dir == 1:
			dir = -1
			print("virou1")
			%Sprite.play("virada")
			await %Sprite.animation_finished
			%Sprite.play("default")
			# Como o sprite não é centralisado, o flip_h fica ruim, como se
			# tivesse um offset. Alinhar com todas as Hit/Hurt boxes é um saco.
			# Por isso, é melhor colocar tudo como filho de um node e flipar ele.
			%Flip.scale.x = 1
	
	if %RayEsquerda.is_colliding() or !%RayVazioEsquerda.is_colliding():
		if dir == -1:
			dir = 1
			print("virou2")
			%Sprite.play("virada")
			await %Sprite.animation_finished
			%Sprite.play("default")
			%Flip.scale.x = -1
	
	move_and_slide()

func Morte() -> void:
	morreu = true
	%SomMorte.play()
	Mundos.lista_inimigos.append(id)
	%HurtBox.process_mode = PROCESS_MODE_DISABLED
	%HitBox.process_mode = PROCESS_MODE_DISABLED
	%Sprite.play("morte")
	await %Sprite.animation_finished
	queue_free()


func _on_area_range_ataque_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player") and !morreu:
		var old_dir = dir
		dir = 0
		%Sprite.play("ataque")
		# Espera um pouquinho só pra animação fazer sentido
		await get_tree().create_timer(.5).timeout
		if morreu: return
		# Como Area2D faz checagem física, tem que chamar/setar as coisas
		# usando o deferred. Basicamente, isso espera o processamento entrar
		# em idle pra executar o código, o que evita erro.
		%HitBoxMordida.set_deferred("monitoring", true)#disabled = false
		await %Sprite.animation_finished
		if morreu: return
		%HitBoxMordida.set_deferred("monitoring", false)#.disabled = true
		dir = old_dir
		%Sprite.play("default")
		
