extends Node2D

onready var tilemap : TileMap = get_parent().get_node("TileMap")
var map_position

signal player_moved

func _ready():
	map_position = tilemap.world_to_map(position)

func _unhandled_input(event):
	if Input.is_action_just_pressed("ui_up"):
		if process_movement(Vector2.UP): map_position += Vector2.UP
		
	if Input.is_action_just_pressed("ui_down"):
		if process_movement(Vector2.DOWN): map_position += Vector2.DOWN
		
	if Input.is_action_just_pressed("ui_left"):
		if process_movement(Vector2.LEFT): map_position += Vector2.LEFT
		
	if Input.is_action_just_pressed("ui_right"):
		if process_movement(Vector2.RIGHT): map_position += Vector2.RIGHT
	
	position = tilemap.map_to_world(map_position)
	emit_signal("player_moved")

func process_movement(direction):
	var tile_type = tilemap.get_cellv(map_position + direction)
	if tile_type == 1:
		return false
	else:
		return true
