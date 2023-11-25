extends CharacterBody2D


@export var speed : float = 200.0
@export var jump_velocity : float = -200.0
@export var jump_double_v : float = -150.0
@onready var animated_sprite : AnimatedSprite2D = $AnimatedSprite2D


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = 500
#ProjectSettings.get_setting("physics/2d/default_gravity")
var has_double_jump : bool = false
var was_in_air : bool = true
var direction : Vector2 = Vector2.ZERO
var in_animation : bool = false

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		was_in_air = true
	else:
		has_double_jump = false
		if was_in_air == true:
			land()
		was_in_air = false

	# Handle Jump.
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			jump()
		elif not has_double_jump:
			double_jump()

	# Get the input direction and handle the movement/deceleration.
	direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if direction.x != 0 && animated_sprite.animation != "jump_end":
		velocity.x = direction.x * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
	move_and_slide()
	update_animation()


func update_animation():
	if not in_animation:
		if not is_on_floor():
			animated_sprite.play("jump_loop")
		else:
			if direction.x != 0:
				animated_sprite.play("run")
			else:
				animated_sprite.play("idle")
	update_direction_direction()

func update_direction_direction():
	if direction.x > 0:
		animated_sprite.flip_h = false
	elif direction.x < 0:
		animated_sprite.flip_h = true

func jump():
	velocity.y = jump_velocity
	animated_sprite.play("jump_start")
	in_animation = true

func land():
	animated_sprite.play("jump_end")
	in_animation = true

func double_jump():
	velocity.y += jump_double_v
	has_double_jump = true
	# put in_animation locked + play other animation

func _on_animated_sprite_2d_animation_finished():
	if (animated_sprite.animation == "jump_end"):
		in_animation = false
	if (animated_sprite.animation == "jump_start"):
		in_animation = false
	# (["differen animation"]).has(animated_spirite.animation):
		#in_animation = false

