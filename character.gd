extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 12

func _physics_process(delta: float) -> void:
	
	# Rotate the camera left / right
	if Input.is_action_just_pressed("cam_left"):
		$CameraController.rotate_y(deg_to_rad(-30))
	if Input.is_action_just_pressed("cam_right"):
		$CameraController.rotate_y(deg_to_rad(30))
		
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	# New Vector3 direction, taking into account the user arrow inputs and the camera rotation
	var direction = ($CameraController.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	# Rotate the character mesh so it is oriented towards the direction of movement
	if direction != Vector3.ZERO:
		# Calculate the angle the character should face based on the movement direction
		var target_angle = atan2(direction.x, direction.z)
		$MeshInstance3D.rotation.y = target_angle
	
	# Apply movement
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
	
	# Make camera controller match the position of the character
	$CameraController.position = lerp($CameraController.position, position, 0.15)


func _on_fall_zone_body_entered(body: Node3D) -> void:
	get_tree().change_scene_to_file("res://level_1.tscn")
