extends Node2D

var pontos
var tileSize = 20

const LIMITEX = 16
const LIMITEY = 9

onready var cabecaScene = load("res://scenes/Cabeça.tscn")
onready var frutaScene = load("res://scenes/Fruta.tscn")
onready var UINode = $UI
onready var gameNode = $Node

signal upVelocity

func grid_to_global(vector):
	return Vector2(1, 1) * tileSize / 2 + (vector - Vector2(1, 1)) * tileSize

func iniciaJogo():
	randomize()
	pontos = 0
	for x in gameNode.get_child_count():
		gameNode.get_child(x).queue_free()
	var new_cabeca = cabecaScene.instance()
	new_cabeca.connect("GameOver", self, "finalizaJogo")
	new_cabeca.connect("Fruta", self, "adiciona_pontos")
# warning-ignore:return_value_discarded
	connect("upVelocity", new_cabeca, "pump_velocity")
	gameNode.add_child(new_cabeca)
	cria_fruta()
	get_tree().paused = false

func finalizaJogo():
	get_tree().paused = true
	UINode.visible = true
	UINode.game_over(pontos)

func adiciona_pontos():
	pontos += 200
	if pontos % 1000 == 0:
		emit_signal("upVelocity")

func cria_fruta():
	var new_instance = frutaScene.instance()
	new_instance.set_position(random_position())
	new_instance.connect("fruta_liberada", self, "cria_fruta")
	gameNode.call_deferred("add_child", new_instance)

func random_position():
	return Vector2((randi() % LIMITEX) + 1, (randi() % LIMITEY) + 1)

func _on_UI_cliqueBotao():
	UINode.visible = false
	iniciaJogo()
