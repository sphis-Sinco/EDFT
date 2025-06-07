extends CharacterBody2D


@export var SPEED = 300.0

@onready var asset = $Asset


func _physics_process(delta):
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	
	var h_dir = Input.get_axis("ui_left", "ui_right")
	
	if h_dir > 0:
		asset.flip_h = false
	elif h_dir < 0:
		asset.flip_h = true
		
	if h_dir:
		velocity.x = h_dir * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
		
	var v_dir = Input.get_axis("ui_up", "ui_down")
	if v_dir:
		velocity.y = v_dir * SPEED
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED)

	move_and_slide()
