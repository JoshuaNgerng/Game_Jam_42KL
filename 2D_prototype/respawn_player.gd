extends Node2D

var player_node = preload("res://player.tscn")
var player = null

func _process(_delta : float) -> void:
	if player == null:
		var new_obj = player_node.instantiate()
		new_obj.position = position
		get_parent().add_child(new_obj)
		player = new_obj
