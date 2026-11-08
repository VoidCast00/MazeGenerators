extends Node

@export var tile_map: TileMapLayer
var roomsPositions:Array[Vector2i] = []
const MAX_ATTEMPTS := 100
const WALL_ATLAS := Vector2i(1, 0)
@onready var MAZE_SIZE :Vector2i= tile_map.MAZE_SIZE


func tryGetRoomCells(pos: Vector2i, size: Vector2i) -> Array[Vector2i]:
	var cells: Array[Vector2i] = []
	for x in range(size.x):
		for y in range(size.y):
			var cellpos := Vector2i(x, y) + pos
			if tile_map.get_cell_source_id(cellpos) == -1:
				return []  # invalid
			cells.append(cellpos)
	return cells

func isWall(cell: Vector2i, pos: Vector2i, size: Vector2i) -> bool:
	return cell.x == pos.x or cell.x == pos.x + size.x - 1  or cell.y == pos.y or cell.y == pos.y + size.y - 1

func generateRandomRooms(roomsCount: int) -> void:
	for room in range(roomsCount):

		for attempt in range(MAX_ATTEMPTS):
			var pos := Vector2i(randi_range(-MAZE_SIZE.x, MAZE_SIZE.x), randi_range(-MAZE_SIZE.y, MAZE_SIZE.y))
			var size := Vector2i(randi_range(3, 20), randi_range(3, 10))
			for otherRoom:Vector2i in roomsPositions:
				print(tile_map.tile_set.tile_size.x)
				if(otherRoom.distance_to(pos) < (size.x + size.y + 5)*16): 
					continue
			var cells := tryGetRoomCells(pos, size)
			if not cells.is_empty():
				roomsPositions.append( Vector2i(pos.x + size.x /2, pos.y + size.y/2)) #middle
				var wallCells:Array[Vector2i]
				for cell in cells:
					if isWall(cell, pos, size):
						wallCells.append(cell)
						tile_map.set_cell(cell,  tile_map.get_cell_source_id(cell), WALL_ATLAS)
					else:
						tile_map.erase_cell(cell)
				for doors in range(2):
					var cell= wallCells.pick_random()
					if cell is Vector2i:
						tile_map.erase_cell(cell)
						#set_cell(cell,get_cell_source_id(cell), Vector2i(0,0) )
				break  
