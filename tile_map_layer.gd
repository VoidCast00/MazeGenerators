extends TileMapLayer

@export var MAZE_SIZE:Vector2i = Vector2i(50,50)

@export var flood: Flood
@export var maze_generator: MazeGenerator
@export var room_generator: Node
const WALL_ATLAS := Vector2i(1, 0)


func _ready() -> void:
	resetMaze(true)
	#room_generator.generateRandomRooms(10)
	#await get_tree().create_timer(8).timeout
	maze_generator.MazeRecursiveDivision()
	flood.startFlood(Vector2i(0,0))



func resetMaze(empty: bool) -> void:
	clear()
	for x in range(-MAZE_SIZE.x, MAZE_SIZE.x + 1):
		for y in range(-MAZE_SIZE.y, MAZE_SIZE.y + 1):
			var pos := Vector2i(x, y)
			var is_border = abs(x) == MAZE_SIZE.x or abs(y) == MAZE_SIZE.y
			if is_border:
				set_cell(pos, 0, WALL_ATLAS)
			elif not empty:
				set_cell(pos, 0, Vector2i(0, 0))
