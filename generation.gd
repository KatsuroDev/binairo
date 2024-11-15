extends Node

var board_tiles = []
var blacks: int = 0
var whites: int = 0
var tile_ui = preload("res://Tile.tscn")

@onready var coord = Vector2i((size/2)-1, (size/2)-1)
var x_delta = 0
var y_delta = 0
var x_target
var y_target
var iteration = 0

signal pressed_enter

@export var size: int = 0

func _ready():
	$GridContainer.columns = size
	for i in size*size:
		var new_tile = tile_ui.instantiate()
		new_tile.tile = Tile.new()
		board_tiles.append(new_tile)
		$GridContainer.add_child(new_tile)
	#generate_board()
	#print_board()
	blacks = board_tiles.filter(func(tile): return tile.tile.state == Tile.STATE.BLACK).size()
	whites = board_tiles.filter(func(tile): return tile.tile.state == Tile.STATE.WHITE).size()
	print("Blacks: ", blacks)
	print("Whites: ", whites)
	generate_tile(board_tiles[coord.y * size + coord.x])

func _input(event):
	if event.is_action_pressed("ui_accept"):
		fill_board_input(iteration)
		iteration += 1

func generate_board():
	fill_board()

func has_equal_amount():
	blacks = board_tiles.filter(func(tile): return tile.tile.state == Tile.STATE.BLACK).size()
	whites = board_tiles.filter(func(tile): return tile.tile.state == Tile.STATE.WHITE).size()
	return blacks == whites

func evaluate(curr_coord: Vector2i):
	evaluate_tile(curr_coord, Vector2.UP)
	evaluate_tile(curr_coord, Vector2.DOWN)
	evaluate_tile(curr_coord, Vector2.RIGHT)
	evaluate_tile(curr_coord, Vector2.LEFT)
	evaluate_line(curr_coord)

func evaluate_tile(curr_coord: Vector2i, direction: Vector2i):
	var last_tile_coord = curr_coord - direction
	if (last_tile_coord.x < 0 || last_tile_coord.x >= size || last_tile_coord.y < 0 || last_tile_coord.y >= size):
		return
	var last_tile = board_tiles[last_tile_coord.y * size + last_tile_coord.x]
	var curr_tile = board_tiles[curr_coord.y * size + curr_coord.x]
	var next_tile_coord = curr_coord + direction
	if (next_tile_coord.x < 0 || next_tile_coord.x >= size || next_tile_coord.y < 0 || next_tile_coord.y >= size):
		return
	var next_tile = board_tiles[next_tile_coord.y * size + next_tile_coord.x]
	if (last_tile.tile.state == curr_tile.tile.state):
		match curr_tile.tile.state:
			Tile.STATE.WHITE:
				next_tile.tile.valid_for = Tile.VALID_FOR.BLACK
			Tile.STATE.BLACK:
				next_tile.tile.valid_for = Tile.VALID_FOR.WHITE
	var behind_last_tile_coord = curr_coord - (direction)*2
	if (behind_last_tile_coord.x < 0 || behind_last_tile_coord.x >= size || behind_last_tile_coord.y < 0 || behind_last_tile_coord.y >= size):
		return
	var behind_last_tile = board_tiles[behind_last_tile_coord.y * size + behind_last_tile_coord.x]
	if (last_tile.tile.state == curr_tile.tile.state):
		match curr_tile.tile.state:
			Tile.STATE.WHITE:
				behind_last_tile.tile.valid_for = Tile.VALID_FOR.BLACK
			Tile.STATE.BLACK:
				behind_last_tile.tile.valid_for = Tile.VALID_FOR.WHITE

func evaluate_line_x(curr_coord: Vector2i):
	var tiles = []
	for i in size:
		tiles.append(board_tiles[curr_coord.y * size + i])
	var line_blacks = tiles.filter(func(tile): return tile.tile.state == Tile.STATE.BLACK).size()
	var line_whites = tiles.filter(func(tile): return tile.tile.state == Tile.STATE.WHITE).size()
	if (line_blacks == size/2):
		for i in size:
			if (board_tiles[curr_coord.y * size + i].tile.state == Tile.STATE.EMPTY):
				board_tiles[curr_coord.y * size + i].tile.valid_for = Tile.VALID_FOR.WHITE
	elif (line_whites == size/2):
		for i in size:
			if (board_tiles[curr_coord.y * size + i].tile.state == Tile.STATE.EMPTY):
				board_tiles[curr_coord.y * size + i].tile.valid_for = Tile.VALID_FOR.BLACK

	
func evaluate_line_y(curr_coord: Vector2i):
	var tiles = []
	for i in size:
		tiles.append(board_tiles[i * size + curr_coord.x])
	var line_blacks = tiles.filter(func(tile): return tile.tile.state == Tile.STATE.BLACK).size()
	var line_whites = tiles.filter(func(tile): return tile.tile.state == Tile.STATE.WHITE).size()
	if (line_blacks == size/2):
		for i in size:
			if (board_tiles[curr_coord.y * size + i].tile.state == Tile.STATE.EMPTY):
				board_tiles[i * size + curr_coord.x].tile.valid_for = Tile.VALID_FOR.WHITE
	elif (line_whites == size/2):
		for i in size:
			if (board_tiles[curr_coord.y * size + i].tile.state == Tile.STATE.EMPTY):
				board_tiles[i * size + curr_coord.x].tile.valid_for = Tile.VALID_FOR.BLACK


func evaluate_line(curr_coord:Vector2i):
	evaluate_line_x(curr_coord)
	evaluate_line_y(curr_coord)

func generate_tile(curr_tile):
	match (curr_tile.tile.valid_for):
		Tile.VALID_FOR.BLACK:
			curr_tile.tile.state = Tile.STATE.BLACK
		Tile.VALID_FOR.WHITE:
			curr_tile.tile.state = Tile.STATE.WHITE
		Tile.VALID_FOR.BOTH:
			curr_tile.tile.state = randi_range(1, 2) as Tile.STATE

func fill_board():
	var coord = Vector2i((size/2)-1, (size/2)-1)
	var x_delta = 0
	var y_delta = 0
	var x_target
	var y_target
	
	generate_tile(board_tiles[coord.y * size + coord.x])
	#print_board()
	for i in (size/2):
		x_delta += 1
		y_delta += 1
		x_target = clamp(coord.x + x_delta, 0, size-1)
		y_target = clamp(coord.y + y_delta, 0, size-1)
		for j in range(coord.x, x_target):
			coord.x += 1
			generate_tile(board_tiles[coord.y * size + coord.x])
			evaluate(coord)
		for j in range(coord.y, y_target):
			coord.y += 1
			generate_tile(board_tiles[coord.y * size + coord.x])
			evaluate(coord)
		#print_board()
		
		x_delta += 1
		y_delta += 1
		x_target = clamp(coord.x - x_delta, 0, size - 1)
		y_target = clamp(coord.y - y_delta, 0, size - 1)
			
		for j in range(x_target, coord.x):
			coord.x -= 1
			generate_tile(board_tiles[coord.y * size + coord.x])
			evaluate(coord)
		if (x_delta >= size):
			break;
		for j in range(y_target, coord.y):
			coord.y -= 1
			generate_tile(board_tiles[coord.y * size + coord.x])
			evaluate(coord)
		#print_board()

func fill_board_input(i):
#print_board()
	x_delta += 1
	y_delta += 1
	x_target = clamp(coord.x + x_delta, 0, size-1)
	y_target = clamp(coord.y + y_delta, 0, size-1)
	for j in range(coord.x, x_target):
		coord.x += 1
		generate_tile(board_tiles[coord.y * size + coord.x])
		evaluate(coord)
	for j in range(coord.y, y_target):
		coord.y += 1
		generate_tile(board_tiles[coord.y * size + coord.x])
		evaluate(coord)
	#print_board()
	
	x_delta += 1
	y_delta += 1
	x_target = clamp(coord.x - x_delta, 0, size - 1)
	y_target = clamp(coord.y - y_delta, 0, size - 1)
		
	for j in range(x_target, coord.x):
		coord.x -= 1
		generate_tile(board_tiles[coord.y * size + coord.x])
		evaluate(coord)
	if (x_delta >= size):
		return;
	for j in range(y_target, coord.y):
		coord.y -= 1
		generate_tile(board_tiles[coord.y * size + coord.x])
		evaluate(coord)

#func print_board():
	#var string = ""
	#for y in size:
		#for x in size:
			#if board_tiles[y * size + x].state == Tile.STATE.BLACK:
				#string += "X"
			#elif board_tiles[y * size + x].state == Tile.STATE.WHITE:
				#string += "O"
			#else:
				#string += "°"
		#print(string)
		#string = ""
	#for i in size:
		#string += "-"
	#print(string)
