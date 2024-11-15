extends PanelContainer

var tile: Tile

@onready var white_label = $VBoxContainer2/VBoxContainer/White
@onready var black_label = $VBoxContainer2/VBoxContainer/Black
@onready var color_rect = $VBoxContainer2/MarginContainer/ColorRect

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	tile.connect("state_changed", _tile_state_changed)
	tile.connect("validity_changed", _tile_validity_changed)

func _tile_state_changed(state: Tile.STATE):
	match state:
		Tile.STATE.BLACK:
			color_rect.color = Color.BLACK
		Tile.STATE.WHITE:
			color_rect.color = Color.WHITE

func _tile_validity_changed(valid_for: Tile.VALID_FOR):
	
	#if tile.state == Tile.STATE.EMPTY:
		#white_label.visible = false
		#black_label.visible = false
		#return
	
	match valid_for:
		Tile.VALID_FOR.BOTH:
			white_label.visible = true
			black_label.visible = true
		Tile.VALID_FOR.BLACK:
			white_label.visible = false
			black_label.visible = true
		Tile.VALID_FOR.WHITE:
			white_label.visible = true
			black_label.visible = false
