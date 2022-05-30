extends Navigation2D# this is put on a navigation2d object, so it automatically does this. Could just be extends Node or extends Node2D if we wanted



# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	for child in get_children(): #loop through all child nodes
		if child is TileMap && child.get_meta("tilemaptype") == "floor": #check if the child is a tilemap, and if i have set it to be a floor (this is set in the floor.gd script)
			var newtilemap = TileMap.new() #make new tilemap
			#
			newtilemap.tile_set = child.tile_set
			newtilemap.cell_size = child.cell_size
			newtilemap.mode = child.mode
			newtilemap.centered_textures = child.centered_textures
			newtilemap.cell_tile_origin = child.cell_tile_origin
			# these three lines above make the new tileset act exactly like the floor tileset (use same tileset, same tile size, make it isometric)
			var tiles = child.get_used_cells()#get list of all the non-empty cells on the tilemap
			var collidertile = newtilemap.tile_set.find_tile_by_name("Collider")# get the id of the collider tile that will stop things from going through walls
			for tile in tiles: # loop through non empty tiles
				if child.get_cell(tile.x-1, tile.y) == TileMap.INVALID_CELL: # check is cell to the left (in isometric coords) is empty
					newtilemap.set_cell(tile.x-1, tile.y,collidertile) #put collider there
				if child.get_cell(tile.x, tile.y-1)  == TileMap.INVALID_CELL:#these do the same for the other close positions
					newtilemap.set_cell(tile.x, tile.y-1,collidertile)
				if child.get_cell(tile.x+1, tile.y)  == TileMap.INVALID_CELL:
					newtilemap.set_cell(tile.x+1, tile.y,collidertile)
				if child.get_cell(tile.x, tile.y+1)  == TileMap.INVALID_CELL:
					newtilemap.set_cell(tile.x, tile.y+1,collidertile)

			self.add_child(newtilemap)# add the new tilemap into the actual game
			move_child(newtilemap,0)# make it first child (just so it will be drawn under floor when visible)
			newtilemap.visible = false;



