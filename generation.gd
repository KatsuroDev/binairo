extends Node

var board_tiles: Array[Tile] = []
var blacks: int = 0
var whites: int = 0


@export var size: int = 0

func _ready():
	generate_board()
	print_board()
	print("Blacks: ", blacks)
	print("Whites: ", whites)

func generate_board():
	fill_board()

func has_equal_amount():
	blacks = board_tiles.filter(func(tile): return tile.state == Tile.STATE.BLACK).size()
	whites = board_tiles.filter(func(tile): return tile.state == Tile.STATE.WHITE).size()
	return blacks == whites

func fill_board():
	for i in size*size:
		board_tiles.append(Tile.new())
	var coord = Vector2i((size/2)-1, (size/2)-1)
	var x_delta = 0
	var y_delta = 0
	var x_target
	var y_target
	board_tiles[coord.y * size + coord.x].state = Tile.STATE.BLACK
	print_board()
	for i in (size/2):
		x_delta += 1
		y_delta += 1
		x_target = clamp(coord.x + x_delta, 0, size-1)
		y_target = clamp(coord.y + y_delta, 0, size-1)
		while (coord.x < x_target):
			coord.x += 1
			board_tiles[coord.y * size + coord.x].state = Tile.STATE.BLACK

		while (coord.y < y_target):
			coord.y += 1
			board_tiles[coord.y * size + coord.x].state = Tile.STATE.WHITE
		print_board()
		
		x_delta += 1
		y_delta += 1
		x_target = clamp(coord.x - x_delta, 0, size - 1)
		y_target = clamp(coord.y - y_delta, 0, size - 1)
			
		while (coord.x > x_target):
			coord.x -= 1
			board_tiles[coord.y * size + coord.x].state = Tile.STATE.BLACK
		if (x_delta >= size):
			break;
		while (coord.y > y_target):
			coord.y -= 1
			board_tiles[coord.y * size + coord.x].state = Tile.STATE.WHITE
		
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
