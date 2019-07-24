extends Node2D

onready var size = $bar.rect_size # guardando tamanho da barra assim que a cena iniciar

func _ready():
	add_to_group("power_up_bar")
	hide() #esconde a barra de power up
	#visible = false
	


func start(time):
	show() #mostra a barra de power up
	$tween.interpolate_method(self, "count", 1, 0, time, Tween.TRANS_LINEAR, Tween.EASE_IN, 0)
	$tween. start()
	#visible = true
	print(time)

func stop():
	$tween.stop_all()
	hide()
	
	
func count(val):
	$bar.rect_size = Vector2(size.x * val, size.y)


func _on_tween_tween_completed(object, key):
	stop()
	get_tree().call_group("player", "power_up_finished")
