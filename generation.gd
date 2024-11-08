extends Node

var board_tiles: Array[Tile] = []
var blacks: int = 0
var whites: int = 0


@export var size: int = 0

func _ready():
	generate_board()
	print_board()
	blacks = board_tiles.filter(func(tile): return tile.state == Tile.STATE.BLACK).size()
	whites = board_tiles.filter(func(tile): return tile.state == Tile.STATE.WHITE).size()
	print("Blacks: ", blacks)
	print("Whites: ", whites)

func generate_board():
	fill_board()

func has_equal_amount():
	blacks = board_tiles.filter(func(tile): return tile.state == Tile.STATE.BLACK).size()
	whites = board_tiles.filter(func(tile): return tile.state == Tile.STATE.WHITE).size()
	return blacks == whites

func evaluate(curr_coord: Vector2i, direction: Vector2i):
	evaluate_next(curr_coord, direction)
	evaluate_line(curr_coord)

func evaluate_next(curr_coord: Vector2i, direction: Vector2i):
	var last_tile_coord = curr_coord - direction
	var last_tile = board_tiles[last_tile_coord.y * size + last_tile_coord.x]
	var curr_tile = board_tiles[curr_coord.y * size + curr_coord.x]
	var next_tile_coord = curr_coord + direction
	var behind_last_tile_coord = curr_coord - (direction*2)
	if (next_tile_coord.x < 0 || next_tile_coord.x >= size || next_tile_coord.y < 0 || next_tile_coord.y >= size):
		return
	var next_tile = board_tiles[next_tile_coord.y * size + next_tile_coord.x]
	if (last_tile.state == curr_tile.state):
		next_tile.valid_for = Tile.VALID_FOR.BLACK if curr_tile.state == Tile.STATE.WHITE else Tile.VALID_FOR.WHITE
		var behind_last_tile = board_tiles[behind_last_tile_coord.y * size + behind_last_tile_coord.x]
		if (behind_last_tile_coord.x < 0 || behind_last_tile_coord.x >= size || behind_last_tile_coord.y < 0 || behind_last_tile_coord.y >= size):
			return
		behind_last_tile.valid_for = Tile.VALID_FOR.BLACK if curr_tile.state == Tile.STATE.WHITE else Tile.VALID_FOR.WHITE

func evaluate_line_x(curr_coord: Vector2i):
	var tiles: Array[Tile] = []
	for i in size:
		tiles.append(board_tiles[curr_coord.y * size + i])
	var blacks = tiles.filter(func(tile): return tile.state == Tile.STATE.BLACK).size()
	var whites = tiles.filter(func(tile): return tile.state == Tile.STATE.WHITE).size()
	if (blacks == size/2):
		for i in size:
			if (board_tiles[curr_coord.y * size + i].state == Tile.STATE.EMPTY):
				board_tiles[curr_coord.y * size + i].valid_for = Tile.VALID_FOR.WHITE
	elif (whites == size/2):
		for i in size:
			if (board_tiles[curr_coord.y * size + i].state == Tile.STATE.EMPTY):
				board_tiles[curr_coord.y * size + i].valid_for = Tile.VALID_FOR.BLACK

	
func evaluate_line_y(curr_coord: Vector2i):
	var tiles: Array[Tile] = []
	for i in size:
		tiles.append(board_tiles[i * size + curr_coord.x])
	var blacks = tiles.filter(func(tile): return tile.state == Tile.STATE.BLACK).size()
	var whites = tiles.filter(func(tile): return tile.state == Tile.STATE.WHITE).size()
	if (blacks == size/2):
		for i in size:
			if (board_tiles[curr_coord.y * size + i].state == Tile.STATE.EMPTY):
				board_tiles[i * size + curr_coord.x].valid_for = Tile.VALID_FOR.WHITE
	elif (whites == size/2):
		for i in size:
			if (board_tiles[curr_coord.y * size + i].state == Tile.STATE.EMPTY):
				board_tiles[i * size + curr_coord.x].valid_for = Tile.VALID_FOR.BLACK


func evaluate_line(curr_coord:Vector2i):
	evaluate_line_x(curr_coord)
	evaluate_line_y(curr_coord)

func generate_tile(curr_tile: Tile):
	match (curr_tile.valid_for):
		Tile.VALID_FOR.BLACK:
			curr_tile.state = Tile.STATE.BLACK
		Tile.VALID_FOR.WHITE:
			curr_tile.state = Tile.STATE.WHITE
		Tile.VALID_FOR.BOTH:
			curr_tile.state = randi_range(1, 2)

func fill_board():
	for i in size*size:
		board_tiles.append(Tile.new())
	var coord = Vector2i((size/2)-1, (size/2)-1)
	var x_delta = 0
	var y_delta = 0
	var x_target
	var y_target
	
	generate_tile(board_tiles[coord.y * size + coord.x])
	print_board()
	for i in (size/2):
		x_delta += 1
		y_delta += 1
		x_target = clamp(coord.x + x_delta, 0, size-1)
		y_target = clamp(coord.y + y_delta, 0, size-1)
		while (coord.x < x_target):
			coord.x += 1
			generate_tile(board_tiles[coord.y * size + coord.x])
			evaluate(coord, Vector2i(1, 0))
		while (coord.y < y_target):
			coord.y += 1
			generate_tile(board_tiles[coord.y * size + coord.x])
			evaluate(coord, Vector2i(0, 1))
		print_board()
		
		x_delta += 1
		y_delta += 1
		x_target = clamp(coord.x - x_delta, 0, size - 1)
		y_target = clamp(coord.y - y_delta, 0, size - 1)
			
		while (coord.x > x_target):
			coord.x -= 1
			generate_tile(board_tiles[coord.y * size + coord.x])
			evaluate(coord, Vector2i(-1, 0))
		if (x_delta >= size):
			break;
		while (coord.y > y_target):
			coord.y -= 1
			generate_tile(board_tiles[coord.y * size + coord.x])
			evaluate(coord, Vector2i(0, -1))
		print_board()

func print_board():
	var string = ""
	for y in size:
		for x in size:
			if board_tiles[y * size + x].state == Tile.STATE.BLACK:
				string += "X"
			elif board_tiles[y * size + x].state == Tile.STATE.WHITE:
				string += "O"
			else:
				string += "°"
		print(string)
		string = ""
	for i in size:
		string += "-"
	print(string)
