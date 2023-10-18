extends Node2D

# Retrieve references to the tile maps for the game's terrain/fog and player.
onready var tile_map : TileMap = get_node("TileMap")
onready var fog : TileMap = get_node("Fog")
onready var player = get_node("Hero")

# Define the player's view distance.
var view_distance = 12

# Dictionary to store tiles that the player has discovered.
var discovered_tiles = {}

func _ready():
	# Update the field of view when the game starts.
	update_fov()
	OS.set_window_title("Raycasting FOV algorithm")

func _on_Hero_player_moved():
	# Update the field of view each time the player moves.
	update_fov()

# Handle mouse click events to add/remove walls.
func _unhandled_input(event):
	if Input.is_mouse_button_pressed(BUTTON_LEFT):
		var tile_position = $TileMap.world_to_map(event.position)
		$TileMap.set_cellv(tile_position, 1)

	if Input.is_mouse_button_pressed(BUTTON_RIGHT):
		var tile_position = $TileMap.world_to_map(event.position)
		$TileMap.set_cellv(tile_position, 0)

	if Input.is_key_pressed(KEY_ESCAPE):
		get_tree().change_scene("res://scenes/Main.tscn")

func update_fov():
	# Get the player's position in tile map coordinates.
	var player_position = tile_map.world_to_map(player.global_position)

	# Set previously discovered tiles back to soft-fog.
	for tile in discovered_tiles.keys():
		fog.set_cellv(tile, 1)

	# Perform raycasting from the player's position.
	raycast_fov(player_position)

func raycast_fov(origin : Vector2):
	# Raycasting in all directions around the player.
	for x in range(-view_distance, view_distance + 1):
		for y in range(-view_distance, view_distance + 1):
			# Ignore the origin point.
			if x == 0 and y == 0: continue
			# Determine the endpoint for this ray.
			var end_tile = origin + Vector2(x, y)
			# If the tile is within view range, perform line tracing towards it.
			if end_tile.distance_to(origin) <= view_distance:
				bresenham_line(origin, end_tile)

func bresenham_line(start, end):
	# Implementation of Bresenham's line drawing algorithm on a tile map.
	var x0 = start.x
	var y0 = start.y
	var x1 = end.x
	var y1 = end.y

	var dx = abs(x1 - x0)
	var dy = abs(y1 - y0)
	var sx = 1 if x0 < x1 else -1
	var sy = 1 if y0 < y1 else -1
	var err = dx - dy

	while true:
		# Set the current tile as visible and mark it as discovered.
		var tile = Vector2(x0, y0)
		fog.set_cellv(tile, -1)
		discovered_tiles[tile] = true

		# If an obstacle is encountered in the line of sight, terminate line tracing.
		if tile_map.get_cellv(tile) == 1: return
		
		# If the endpoint is reached, end the loop.
		if x0 == x1 and y0 == y1: break
		
		# Update the current position based on the accumulated error.
		var e2 = 2 * err
		if e2 > -dy:
			err -= dy
			x0 += sx
		if e2 < dx:
			err += dx
			y0 += sy
