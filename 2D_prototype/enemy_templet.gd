extends CharacterBody2D

@export var speed : int= 100

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
	move_left()
	move_and_slide()
	if velocity.x == 0:
		queue_free()

func _on_area_2d_area_entered(area):
	pass # Replace with function body.
