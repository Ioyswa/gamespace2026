extends Node2D

var tile_scene = preload("res://Week3/Wee3Part3/tile.tscn")

@export var grid_width: int = 4
@export var grid_height: int = 4
@export var tile_size: int = 64
@export var opposite_rule_count: int = 1 

var grid_data = []
var opposite_pairs = []

func _ready():
	randomize()
	generate_grid()
	generate_opposite_rules()

func generate_grid():
	grid_data.resize(grid_width)
	
	for x in range(grid_width):
		grid_data[x] = []
		grid_data[x].resize(grid_height)
		
		for y in range(grid_height):
			grid_data[x][y] = -1 
			
			var new_tile = tile_scene.instantiate()
			new_tile.position = Vector2(x * tile_size, y * tile_size)
			new_tile.name = "Tile_%d_%d" % [x, y]
			
			var sprite = new_tile.get_node("Sprite2D")
			sprite.modulate = Color.GRAY
			
			new_tile.input_event.connect(_on_tile_clicked.bind(new_tile, x, y))
			
			$TilePivot.add_child(new_tile)

func generate_opposite_rules():
	var attempts = 0
	while opposite_pairs.size() < opposite_rule_count and attempts < 100:
		attempts += 1
		var x = randi() % grid_width
		var y = randi() % grid_height

		var dir = randi() % 2
		var nx = x + (1 if dir == 0 else 0)
		var ny = y + (0 if dir == 0 else 1)
		
		if nx < grid_width and ny < grid_height:
			var pair = [Vector2(x, y), Vector2(nx, ny)]
			
			var is_duplicate = false
			for existing_pair in opposite_pairs:
				if existing_pair[0] == pair[0] and existing_pair[1] == pair[1]:
					is_duplicate = true
					break
			
			if not is_duplicate:
				opposite_pairs.append(pair)
				var tile1 = $TilePivot.get_node("Tile_%d_%d" % [x, y])
				var tile2 = $TilePivot.get_node("Tile_%d_%d" % [nx, ny])
				
				red_border(tile1)
				red_border(tile2)

func red_border(tile_node):
	if tile_node.has_node("RedBorder"):
		return
		
	var border = ReferenceRect.new()
	border.name = "RedBorder"
	border.size = Vector2(tile_size, tile_size)
	
	border.border_color = Color.RED
	border.border_width = 4.0
	border.editor_only = false
	border.mouse_filter = Control.MOUSE_FILTER_IGNORE
	
	tile_node.add_child(border)

func _on_tile_clicked(viewport, event, shape_idx, tile_node, x, y):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			var sprite = tile_node.get_node("Sprite2D")
			
			if grid_data[x][y] == -1 or grid_data[x][y] == 1:
				grid_data[x][y] = 0
				sprite.modulate = Color.BLACK
			else:
				grid_data[x][y] = 1
				sprite.modulate = Color(18.892, 18.892, 18.892)
				
			check_grid_rules()

	#for x in range(grid_width):
		#var jumlah_hitam = 0
		#var jumlah_putih = 0
		#
		#for y in range(grid_height):
			#if grid_data[x][y] == 0:
				#jumlah_hitam += 1
			#elif grid_data[x][y] == 1:
				#jumlah_putih += 1
				#
		#if jumlah_hitam >= 3:
			#print("Kolom ", x + 1, " salah karena ada 3 hitam!")
			#illegal = true
		#elif jumlah_putih >= 3:
			#print("Kolom ", x + 1, " salah karena ada 3 putih!")
			#illegal = true
			#
	#for y in range(grid_height):
		#var jumlah_hitam = 0
		#var jumlah_putih = 0
		#
		#for x in range(grid_width):
			#if grid_data[x][y] == 0:
				#jumlah_hitam += 1
			#elif grid_data[x][y] == 1:
				#jumlah_putih += 1
			#
		#if jumlah_hitam >= 3:
			#print("Baris ", y + 1, " salah karena ada 3 hitam!")
			#illegal = true
		#elif jumlah_putih >= 3:
			#print("Baris ", y + 1, " salah karena ada 3 putih!")
			#illegal = true

func check_grid_rules():
	var illegal = false

	for pair in opposite_pairs:
		var p1 = pair[0]
		var p2 = pair[1]
		var val1 = grid_data[p1.x][p1.y]
		var val2 = grid_data[p2.x][p2.y]
		
		if val1 != -1 and val2 != -1:
			if val1 == val2:
				print("Tile pada ", p1, " dan ", p2, " memiliki warna sama!")
				illegal = true
			
	if not illegal:
		print("Anjay")
