extends Node

onready var afterGameNode = $AfterGame

signal cliqueBotao

func game_over(pontos):
	afterGameNode.set_visible(true)
	afterGameNode.find_node("Score").set_text("Sua pontuação foi: " + String(pontos))


func _on_Button_pressed():
	emit_signal("cliqueBotao")
