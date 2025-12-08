extends State

@export var jump_state:State = null

func Update(_delta : float) -> State:
	if Input.is_action_just_pressed("pulo") and !parent.check_agua_up.is_colliding():
		#print("VAMOLA")
		return jump_state
	return null

func FixedUpdate(delta : float) -> State:
	var dir:Vector2 = parent.input_move.normalized()
	if dir.x:
		parent.velocity.x = move_toward(
			parent.velocity.x, dir.x * parent.speed, parent.accel * delta)
	else:
		parent.velocity.x = move_toward(parent.velocity.x, dir.x, parent.decel * delta)
	
	if dir.y:
		if dir.y > 0.0 or (dir.y < 0.0 and parent.check_agua_up.is_colliding()):
			parent.velocity.y = move_toward(
				parent.velocity.y, dir.y * parent.speed, parent.accel * delta)
	elif parent.check_agua_up.is_colliding():
		parent.velocity.y = move_toward(parent.velocity.y, -128.0, parent.accel * delta)
	else:
		parent.velocity.y = move_toward(parent.velocity.y, dir.y, parent.decel * delta)
			
			
	#if parent.check_agua.is_colliding():
		#if dir.y:
			#parent.velocity.y = move_toward(
				#parent.velocity.y, dir.y * parent.speed, parent.accel * delta)
		#else:
			#parent.velocity.y = move_toward(parent.velocity.y, -128.0, parent.accel * delta)
	#else:
		#parent.velocity.y = move_toward(parent.velocity.y, dir.y, parent.decel * delta)
	return null
