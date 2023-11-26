extends CharacterBody2D

@export var speed : float = 200.0
@export var jump_velocity : float = -300.0
@export var jump_double_v : float = -250.0
@export var dash_v : float = 1500.0
@export var dash_timer_max : float = 2
@export var dash_cooldown : float = 5
@onready var animated_sprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var interaction_list : Array = []
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = 500
#ProjectSettings.get_setting("physics/2d/default_gravity")
var in_dash : bool = false
var facing_right : bool = true
var dash_timer : float = 0
var next_dash : float = 0
var has_double_jump : bool = false
var was_in_air : bool = true
var direction : Vector2 = Vector2.ZERO
var in_animation : bool = false
var climb_status : bool = false
var swim_status : bool = false

func _physics_process(delta : float) -> void:

	# Handle Jump.
	if Input.is_action_just_pressed("jump"):
		if climb_status == true:
			has_double_jump = false
		if is_on_floor():
			jump()
			in_dash = false
		elif not has_double_jump:
			double_jump()
			in_dash = false

	if Input.is_action_just_pressed("dash") and in_dash == false and next_dash == 0:
		dash_init()

	# Add the gravity.
	if not is_on_floor():
		if in_dash == false or swim_status == false or climb_status == false:
			velocity.y += gravity * delta
		was_in_air = true
	else:
		next_dash = 0
		has_double_jump = false
		if was_in_air == true:
			land()
		was_in_air = false

	if in_dash == false:
		move_player()
	else:
		do_dash()
	if next_dash > 0:
		next_dash -= 1

	move_and_slide()
	update_animation()


func update_animation() -> void:
	if not in_animation:
		if not is_on_floor():
			animated_sprite.play("jump_loop")
		else:
			if direction.x != 0:
				animated_sprite.play("run")
			else:
				animated_sprite.play("idle")
	update_direction_direction()

func move_player() -> void:
	direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if direction:
		velocity.x = direction.x * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
	if swim_status == true or climb_status == true:
		velocity.y = direction.y * speed

func update_direction_direction() -> void:
	if direction.x > 0:
		animated_sprite.flip_h = false
		facing_right = true
	elif direction.x < 0:
		animated_sprite.flip_h = true
		facing_right = false

func jump() -> void:
	velocity.y = jump_velocity
	animated_sprite.play("jump_start")
	in_animation = true

func land() -> void:
	animated_sprite.play("jump_end")
	in_animation = true

func double_jump() -> void:
	velocity.y = jump_double_v
	animated_sprite.play("jump_start")
	has_double_jump = true
	# put in_animation locked + play other animation

func dash_init() -> void:
	in_dash = true
	dash_timer = dash_timer_max
	animated_sprite.play("dash")
	in_animation = true

func do_dash() -> void:
	var dash_vector : Vector2
	if facing_right == true:
		dash_vector = Vector2(1, 0)
	else:
		dash_vector = Vector2(-1, 0)
	velocity.x = dash_vector.normalized().x * dash_v
	if dash_timer > 0:
		dash_timer -= 1
	if dash_timer == 0:
		in_dash = false

func die() -> void:
	queue_free()

func interaction_state_init() -> void:
	print("length of list ", interaction_list.size())
	for i in interaction_list.size():
		var type = interaction_list[i].interact_type
		print("type ", type)
		if type == 0:
			die()
		elif type == 1:
			climb_status = true
		elif  type == 2:
			swim_status = true

func interaction_state_remove(area: Area2D) -> void:
	var type = area.interact_type
	if type == 1:
		climb_status = false
	elif type == 2:
		swim_status = false

func _on_animated_sprite_2d_animation_finished() -> void:
	if (["jump_start", "jump_end", "dash"]).has(animated_sprite.animation):
		in_animation = false

func _on_touch_box_area_entered(area: Area2D) -> void:
	interaction_list.insert(0, area)
	interaction_state_init()

func _on_touch_box_area_exited(area: Area2D) -> void:
	interaction_list.erase(area)
	interaction_state_remove(area)
	has_double_jump = false
