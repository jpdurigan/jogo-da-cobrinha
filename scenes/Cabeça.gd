extends Area2D
class_name Cabeca

var direction = Vector2.ZERO
var tileSize = 20
var posicoesCorpo = []

export var velocity = 0.5
export var initialPosition = Vector2.ZERO

onready var positionGrid = initialPosition
onready var lookingAt = initialPosition
onready var corpoScene = load("res://scenes/Corpo.tscn")
onready var spriteNode = $Sprite
onready var corpoNode = $Corpo

signal GameOver
signal Fruta

func _ready():
	position = grid_to_global(positionGrid)
	pass # Replace with function body.

func _process(_delta):
	var input_vector = get_input_direction()
	if input_vector:
		direction = input_vector
		direciona_cabeca()
	if positionGrid.is_equal_approx(lookingAt):
		adiciona_posicao_na_lista(lookingAt)
		atualiza_corpo()
		lookingAt = lookingAt + direction
	
	move()

func get_input_direction():
	var inputVec = Vector2()
	inputVec = Vector2(float(Input.is_action_pressed("ui_right")) - float(Input.is_action_pressed("ui_left")),
			float(Input.is_action_pressed("ui_down")) - float(Input.is_action_pressed("ui_up")))
	
	if inputVec:
		if abs(inputVec.x) == abs(direction.x):
			inputVec.x = 0
		if abs(inputVec.y) == abs(direction.y):
			inputVec.y = 0
	
	return inputVec

func move():
	positionGrid = lerp(positionGrid, lookingAt, velocity)
	position = grid_to_global(positionGrid)

func adiciona_posicao_na_lista(pos):
	posicoesCorpo.push_front(pos)
	posicoesCorpo.pop_back()

func adiciona_corpo():
	var ultimaPos
	if posicoesCorpo.size() < 1:
		ultimaPos = lookingAt
	else:
		ultimaPos = posicoesCorpo.back()
	posicoesCorpo.push_back(ultimaPos - direction)
	var new_corpo = corpoScene.instance()
	new_corpo.initialPosition = ultimaPos - direction
	corpoNode.call_deferred("add_child", new_corpo)
	call_deferred("atualiza_corpo")

func atualiza_corpo():
	for x in posicoesCorpo.size():
		corpoNode.get_child(x).lookingAt = posicoesCorpo[x]

func pump_velocity():
	velocity = lerp(velocity, 1.0, 0.2)
	for x in posicoesCorpo.size():
		corpoNode.get_child(x).velocity = velocity

func grid_to_global(vector):
	return Vector2(1, 1) * tileSize / 2 + (vector - Vector2(1, 1)) * tileSize

func direciona_cabeca():
	match direction:
		Vector2(1, 0):
			spriteNode.rotation_degrees = -90
		Vector2(0, 1):
			spriteNode.rotation_degrees = 0
		Vector2(-1, 0):
			spriteNode.rotation_degrees = 90
		Vector2(0, -1):
			spriteNode.rotation_degrees = 180

func _on_Cabea_area_shape_entered(_area_id, area, _area_shape, _self_shape):
	match area.name():
		"Corpo":
			emit_signal("GameOver")
		"Fruta":
			emit_signal("Fruta")
			area.libera_fruta()

func _on_Cabea_Fruta():
	adiciona_corpo()
