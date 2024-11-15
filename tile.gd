extends Resource
class_name Tile
## Representation of a tile

enum STATE {
	EMPTY,
	BLACK,
	WHITE
}

enum VALID_FOR {
	NONE,
	BLACK,
	WHITE,
	BOTH
}

signal state_changed 
signal validity_changed

## Current state of a tile
@export var state: STATE = STATE.EMPTY :
	set(value):
		state = value
		state_changed.emit(value)

## True if the tile has been generated, false if it has been placed by a player
@export var is_generated: bool = false

## For generation, holds a valid value for possible state
var valid_for: VALID_FOR = VALID_FOR.BOTH :
	set(value):
		valid_for = value
		validity_changed.emit(value)
