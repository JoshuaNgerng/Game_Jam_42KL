extends Node2D

var enemy_node = preload("res://enemy_templet.tscn")
var counter = 0

func spawn_enemy() -> void:
	var new_obj = enemy_node.instantiate()
	new_obj.position = position
	get_parent().add_child(new_obj)

func _ready() -> void:
	spawn_enemy()
	$Timer.start()

func _on_timer_timeout() -> void:
	spawn_enemy()

func _process(_delta) -> void:
	if counter == 0:
		spawn_enemy()
		counter = 1
