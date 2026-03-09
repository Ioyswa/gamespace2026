#MapManager.gd
extends Node

@export var width: int = 10
@export var height: int = 10

@export var tile_size: int = 32
@export var tilemap: TileMapLayer


var grid: Array = []

func _ready():
	generate_grid()
	
func generate_grid():
	grid.clear()
	tilemap.clear()
	
	for y in height:
		var row: Array = []
		
		for x in width:
			row.append(0)
			
			tilemap.set_cell(Vector2i(x, y), 0, Vector2i(0, 0), 0)
		grid.append(row)
