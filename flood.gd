class_name Flood
extends Node

var floodedCells:Array[Vector2i] = []

@export var tilemap: TileMapLayer


func startFlood(startPos:Vector2i) -> void:
	floodedCells.append(startPos);
	tilemap.set_cell(startPos, 0, Vector2i(1,1))
	spreadFlood();




func spreadFlood() -> void:
	var newFloodedCells:Array[Vector2i] = []
	for cell:Vector2i in floodedCells:
		var surroundingCells:= tilemap.get_surrounding_cells(cell);
		for sCell:Vector2i in surroundingCells:
			if tilemap.get_cell_source_id(sCell) == -1:
				newFloodedCells.append(sCell)
				tilemap.set_cell(sCell, 0,Vector2i(1,1))
	floodedCells.append_array(newFloodedCells)
	get_tree().create_timer(0.1).timeout.connect(spreadFlood)
