extends TileMap


# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("tilemaps")
	set_meta("tilemaptype","floor")

