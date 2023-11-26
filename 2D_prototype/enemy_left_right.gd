extends CharacterBody2D

@export var speed : int = 100

var direction_right : bool = false

func move_up():
	velocity.y = speed * -1

func move_down():
	velocity.y = speed

func move_left():
	velocity.x = speed * -1

func move_right():
	velocity.x = speed

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if direction_right == false:
		move_left()
	else:
		move_right()
	move_and_slide()
	if velocity.x == 0:
		if direction_right == false:
			direction_right = true
		else:
			direction_right = false
