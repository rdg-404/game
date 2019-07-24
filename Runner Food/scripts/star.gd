extends Node2D

signal finished

func _ready():
	pass

func play():
	$animation.play("fadein") #executa a animação 
	yield($animation, "animation_finished") #espera a animação acabar 
	emit_signal("finished") #emite o sinal