extends Resource
class_name Tile

enum STATE {
	EMPTY,
	BLACK,
	WHITE
}

@export var state: STATE = STATE.EMPTY
@export var is_generated: bool = false
