## One run at the game: the board and the dragon on it, from the first tick until the
## run ends. Rules that involve more than the dragon (food, score, what the dragon can
## run into) belong here, so Dragon stays about movement and app/ only draws.
class_name Session
extends RefCounted

var board: Board
var dragon: Dragon
var food_location: Vector2i
var score := 0
var game_over := false
var _rng := RandomNumberGenerator.new()


func _init(grid_size: Vector2i) -> void:
	board = Board.bordered(grid_size)
	dragon = Dragon.new(grid_size)
	_rng.seed = 1

	place_food()


func place_food() -> void:
	var available_cells: Array[Vector2i] = []

	for x in board.size.x:
		for y in board.size.y:
			var cell := Vector2i(x, y)
			if !(cell in dragon.body) and !(board.is_solid(cell)):
				available_cells.append(cell)

	if available_cells.is_empty():
		return

	var index := _rng.randi_range(0, available_cells.size() - 1)
	food_location = available_cells[index]


## One step of the rules. TODO for D4: food, growth, and collisions with the dragon's
## own body and with solid tiles (board.is_solid). Each needs the dragon and something
## else, which is why they go here rather than in Dragon.tick.


func tick() -> void:
	if game_over:
		return
	dragon.tick()
	var head := dragon.body[0]
	if board.is_solid(head) or dragon.body.slice(1).has(head):
		game_over = true
		return
	if head == food_location:
		dragon.grow()
		score += 1
		place_food()
