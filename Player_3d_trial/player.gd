extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 5.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
@onready var camerapivot = $CameraPivot

func _physics_process(delta: float) -> void:
	# Get the input direction to handle camera_rotation
	var rotate = Input.get_vector("rotate_left", "rotate_right", "rotate_up", "rotate_down")
	#var rotate = (transform.basis * Vector3(input_rotate.x, 0, input_rotate.y)).normalized()
	if rotate:
		camerapivot.rotation.x -= (rotate.y * 1)
		camerapivot.rotation.x = clamp(camerapivot.rotation.x, deg_to_rad(-90), deg_to_rad(90))
		rotation.y -= deg_to_rad(rotate.x * 1)
		#CameraPivot.rotation.x = wrapf(cam_rotation_h, 0.0, PI*2)
		#CameraPivot = wrapf(cam_rotation_v, 0.0, PI*2)
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
