# Maze Generator

A small Godot 4 project that generates and animates mazes on a `TileMapLayer`.

## Algorithms

- **Recursive backtracker**: carves the maze step by step from a starting cell (this is the default).
- **Recursive division**: splits the area into rooms. Each key press runs another division step.
- **Random rooms**: places walled rooms in the grid. This one is still experimental.

## Running

1. Open the project in Godot 4.7 or newer.
2. Press **F5** to run `game.tscn`.

You can change the maze size with `MAZE_SIZE` on the `TileMapLayer` node in the inspector.

## Files

- `tile_map_layer.gd`: sets up the grid and starts generation.
- `algorithms.gd`: the maze generation algorithms.
- `room_generator.gd`: random room placement.
