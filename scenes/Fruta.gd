extends Area2D

var tileSize = 20
var positionGrid = Vector2.ZERO

signal fruta_liberada

func set_position(pos):
	positionGrid = pos
	position = grid_to_global(positionGrid)

func grid_to_global(vector):
	return Vector2(1, 1) * tileSize / 2 + (vector - Vector2(1, 1)) * tileSize

func name():
	return "Fruta"

func libera_fruta():
	emit_signal("fruta_liberada")
	queue_free()
