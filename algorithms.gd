extends Node

@export var tile_map: TileMapLayer
@onready var MAZE_SIZE :Vector2i= tile_map.MAZE_SIZE
var steps:Array[Vector2i] = []
var startingCell:= Vector2i.ZERO
signal any_input

const WALL_ATLAS := Vector2i(1, 0)


func _input(event):
	if event.is_pressed() and not event.is_echo():
		any_input.emit()


const SUR_CELLS =[
	Vector2i(0,2),
	Vector2i(2,0),
	Vector2i(-2,0),
	Vector2i(0,-2),
]

func getSurroundingCells(cell:Vector2i) -> Array[Vector2i]:
	var arr : Array[Vector2i] = []
	for i in SUR_CELLS:
		var pos :Vector2i = cell + i
		if pos.x < MAZE_SIZE.x and pos.y < MAZE_SIZE.y and pos.x > -MAZE_SIZE.x and pos.y > -MAZE_SIZE.y:
			if tile_map.get_cell_source_id(pos) != -1 :
				if tile_map.get_cell_atlas_coords(pos) != Vector2i(1,0):
					arr.append(cell + i)
	return arr



func MazeRecursiveBacktracker() -> void:
	var currentCell = startingCell;
	tile_map.erase_cell(startingCell)
	steps.append(startingCell)
	
	while (steps.size() > 0):
		await  get_tree().create_timer(0.01).timeout
		var surroundingCells:= getSurroundingCells(currentCell);
		
		if not surroundingCells.size() == 0:
			var nextCell: Vector2i = surroundingCells.pick_random()
			var middle : Vector2i= currentCell + (nextCell - currentCell) / 2

			tile_map.erase_cell(middle)   
			tile_map.erase_cell(nextCell)   

			currentCell = nextCell
			steps.append(currentCell)
		else:
			steps.pop_back()
			if steps.size() > 0:
				currentCell = steps.back()



func MazeRecursiveDivision() -> void:
	var maxRoomCount := 500
	var rooms:Array[Rect2i] = []
	rooms.append_array( await devideRoom(Rect2i(-MAZE_SIZE.x+1, -MAZE_SIZE.y+1, MAZE_SIZE.x*2-1, MAZE_SIZE.y*2-1)))
	print(rooms)
	while(true):
		await  any_input	
		var newRooms:Array[Rect2i]
		var deleteRooms:Array[Rect2i]
		for room in rooms:
			print(room)
			newRooms.append_array( await devideRoom(room))
			deleteRooms.append(room)
		
		for delRoom in deleteRooms:
			rooms.erase(delRoom)
		rooms.append_array(newRooms)



func devideRoom(room :Rect2i) -> Array[Rect2i]:
	var newRooms:Array[Rect2i]
	var horizontal:bool 
	
	if room.size.x > room.size.y:
		horizontal = true
	elif room.size.x < room.size.y:
		horizontal = false
	else:
		horizontal = randf() > 0.5
	
	
	if horizontal:
		var x := random_middle_even(room.position.x + 1, room.end.x - 2)
		var doorY: Array[int] = [random_odd(room.position.y, room.end.y - 1)]
		for y in range(room.position.y ,room.end.y, 1):
			var pos:= Vector2i(x,y)
			if doorY.has(y):
				continue
			#print(pos)
			tile_map.set_cell(pos,0,Vector2i(0,0))
			await  get_tree().create_timer(0.005).timeout
		newRooms.append_array([
			Rect2i(room.position, Vector2i(x - room.position.x,room.size.y)), 
			Rect2i(Vector2i(x+1,room.position.y), Vector2i(room.end.x - x - 1, room.size.y) ) ])
	else:
		var y := random_middle_even(room.position.y + 1, room.end.y - 2)
		var doorX:Array[int] = [random_odd(room.position.x, room.end.x - 1)]
		for x in range(room.position.x, room.end.x, 1):
			var pos:= Vector2i(x,y)
			if doorX.has(x):
				continue
			await  get_tree().create_timer(0.005).timeout
			tile_map.set_cell(pos, 0, Vector2i(0,0))
			#print(pos)
		newRooms.append_array([
				Rect2i(room.position, Vector2i(room.size.x, y - room.position.y)),
				Rect2i(Vector2i(room.position.x, y + 1), Vector2i(room.size.x, room.end.y - y - 1))])
	return newRooms




func random_middle_even(a: int, b: int, strength: int = 2) -> int:
	var lo := ceili(a / 2.0)
	var hi := floori(b / 2.0)
	var total := 0
	for i in strength:
		total += randi_range(lo, hi)
	return 2 * roundi(float(total) / strength)

func random_odd(a: int, b: int) -> int:
	var lo := ceili((a - 1) / 2.0)
	var hi := floori((b - 1) / 2.0)
	return 2 * randi_range(lo, hi) + 1

	#var divisions:= 100
	#for i in range (divisions):
		#await any_input
		#if (randf() >= 0.5): #horizontal wall
			#var wallCells:Array[Vector2i]
			#var y:int
			#while (y % 2 == 0):
				#y = randi_range(-MAZE_SIZE.y, MAZE_SIZE.y)
			#var x := MAZE_SIZE.x if randf() < 0.5 else -MAZE_SIZE.x
			#var step := -signi(x)
			#while true:
				#x+=step
				#if tile_map.get_cell_source_id(Vector2i(x,y)) != -1 :
						#break
				#if tile_map.get_cell_atlas_coords(Vector2i(x,y)) == WALL_ATLAS:
					#break
				#tile_map.set_cell(Vector2i(x,y), 0, Vector2i(0,0))
				#wallCells.append(Vector2i(x,y))
			#for l in range(randi_range(1,3)):
				#if !wallCells.is_empty():
					#var cell :Vector2i= wallCells.pick_random()
					#tile_map.erase_cell(cell)
					#wallCells.erase(cell)
		#else: #vertical wall
			#var wallCells:Array[Vector2i]
			#var x :int
			#while (x % 2 == 0):
				#x = randi_range(-MAZE_SIZE.x, MAZE_SIZE.x)
			#var y := MAZE_SIZE.y if randf() < 0.5 else -MAZE_SIZE.y
			#var step := -signi(y)
			#while true:
				#y += step
				#if tile_map.get_cell_source_id(Vector2i(x,y)) != -1 :
					#break
				#if tile_map.get_cell_atlas_coords(Vector2i(x,y)) == WALL_ATLAS:
					#break
				#tile_map.set_cell(Vector2i(x,y), 0, Vector2i(0,0))
				#wallCells.append(Vector2i(x,y))
			#for l in range(randi_range(1,3)):
				#if !wallCells.is_empty():
					#var cell :Vector2i= wallCells.pick_random()
					#tile_map.erase_cell(cell)
					#wallCells.erase(cell)
