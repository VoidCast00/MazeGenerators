class_name Flood
extends Node

var floodedCells:Array[Vector2i] = []
var sourceCell:Vector2i
@export var tilemap: TileMapLayer


func startFlood(startPos:Vector2i) -> void:
	sourceCell = startPos
	floodedCells.append(startPos);
	tilemap.set_cell(startPos, 0, Vector2i(1,1))
	spreadFlood();




func spreadFlood() -> void:
	var newFloodedCells:Array[Vector2i] = []
	for cell:Vector2i in floodedCells:
		var surroundingCells:= get_empty_surrounding_cells(cell)
		if surroundingCells.is_empty():
			tilemap.set_cell(cell, 0, Vector2i(0,1))
			continue;
		for sCell in surroundingCells:
			var chance:float = 0.6 + (int(cell.distance_to(sourceCell)/4)  * 0.02)
			chance = clampf(chance, 0.0, 0.9)
			print(chance	)
			if randf() < 0.6:
				continue
			newFloodedCells.append(sCell)
			tilemap.set_cell(sCell, 0,Vector2i(1,1))
	floodedCells.append_array(newFloodedCells)
	get_tree().create_timer(0.1).timeout.connect(spreadFlood)



func get_empty_surrounding_cells(cell:Vector2i) -> Array[Vector2i]:
	var cells:Array[Vector2i] = []
	var surroundingCells:= tilemap.get_surrounding_cells(cell);
	for sCell:Vector2i in surroundingCells:
		if tilemap.get_cell_source_id(sCell) == -1:
			cells.append(sCell)
	return cells
