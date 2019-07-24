tool 
extends Area2D

#export(int, "maca", "morango", "pera", "uva") var fruit = 3


var fruits = [
"res://sprites/Items/maca.png",
"res://sprites/Items/morango.png",
"res://sprites/Items/pera.png",
"res://sprites/Items/uva.png"
]

export(int, "maca", "morango", "pera", "uva") var fruit = 0 setget set_fruit # Deixa na area de edição nomes para editar a fruta

func _ready():
	$animation.play("move")
	get_tree().call_group("game", "add_stage_fruits")


func _draw():
	$sprite.texture = load(fruits[fruit]) # carrega a fruta alterada

#função para alterar a fruta
func set_fruit(val):
	fruit = val 
	if is_inside_tree() && Engine.editor_hint:
		update()
	
func _on_pickup_body_entered(body):
	if body.name == "player": #se for o player 
		$pickup.play()
		$sprite.visible = false # torna o sprite invisivel
		collision_mask = 0 # faz o sprite nao colidir com ninguem
		$queue_timer.start() #inicia o timer 
		$particles.emitting = true
		get_tree().call_group("punctuation", "pick_fruit")	

func _on_queue_timer_timeout(): #tempo para a fruta sumir 
	queue_free()
