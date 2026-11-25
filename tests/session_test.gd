extends "res://tests/test_case.gd"


func test_a_tick_moves_the_dragon_head() -> void:
	var session := Session.new(Vector2i(10, 10))
	session.tick()
	assert_eq(session.dragon.body[0], Vector2i(6, 5))


func test_the_dragon_starts_on_open_floor_inside_a_wall() -> void:
	var session := Session.new(Vector2i(10, 10))
	assert_true(session.board.is_solid(Vector2i(0, 0)))
	assert_true(not session.board.is_solid(session.dragon.body[0]))


func test_that_eating_food_grows_dragon() -> void:
	var session := Session.new(Vector2i(10, 10))
	session.food_location = Vector2i(6, 5)

	session.tick()
	assert_eq(session.dragon.body.size(), 5)


func test_eating_food_increases_score() -> void:
	var session := Session.new(Vector2i(10, 10))
	session.food_location = Vector2i(6, 5)

	session.tick()
	assert_eq(session.score, 1)


func test_food_is_not_placed_on_body() -> void:
	var session := Session.new(Vector2i(10, 10))
	session.food_location = Vector2i(6, 5)

	session.tick()
	assert_true(not (session.food_location in session.dragon.body))
	assert_true(not (session.board.is_solid(session.food_location)))
