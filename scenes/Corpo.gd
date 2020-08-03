extends Area2D

var direction = Vector2.ZERO
var tileSize = 20
export var velocity = 0.5
export var initialPosition = Vector2.ZERO

onready var positionGrid = initialPosition
onready var lookingAt = initialPosition

func _ready():
	position = grid_to_global(positionGrid)

func _process(_delta):
	if positionGrid.is_equal_approx(lookingAt):
		lookingAt = lookingAt + direction
	move()

func move():
	positionGrid = lerp(positionGrid, lookingAt, velocity)
	position = grid_to_global(positionGrid)

func grid_to_global(vector):
	return Vector2(1, 1) * tileSize / 2 + (vector - Vector2(1, 1)) * tileSize

func name():
	return "Corpo"
