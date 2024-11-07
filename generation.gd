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
	while !has_equal_ammount():
		fill_board()

func is_valid():
	var first
	var second
	for y in size:
		for x in size: 
			var current_tile = board_tiles[x*y]
			if x == 0:
				first = current_tile
				continue
			if x == 1:
				second = current_tile
				continue
			if current_tile.state == first.state && current_tile.state == second.state:
				return false
			first = board_tiles[(x-2)*y]
			second = board_tiles[(x-1)*y]
	return true

func has_equal_ammount():
	blacks = board_tiles.filter(func(tile): return tile.state == Tile.STATE.BLACK).size()
	whites = board_tiles.filter(func(tile): return tile.state == Tile.STATE.WHITE).size()
	return blacks == whites

func fill_board():
	var first
	var second
	var refill = true
	for i in size*size:
		board_tiles.append(Tile.new())
	while refill:
		refill = false
		for y in size:
			for x in size:
				var current_tile = board_tiles[x*y]
				current_tile.state = randi_range(1, 2)
				if x == 0:
					first = current_tile
					continue
				if x == 1:
					second = current_tile
					continue
				if current_tile.state == first.state && current_tile.state == second.state:
					refill = true
					break
				first = board_tiles[(x-2)*y]
				second = board_tiles[(x-1)*y]
			if refill:
				break

func print_board():
	var string = ""
	for y in size:
		for x in size:
			if board_tiles[x*y].state == Tile.STATE.BLACK:
				string += "X"
			elif board_tiles[x*y].state == Tile.STATE.WHITE:
				string += "O"
			else:
				string += "°"
		print(string)
		string = ""
