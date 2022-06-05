extends TileMap


func _ready():
	add_to_group("tilemaps")
	set_meta("tilemaptype","wall")
