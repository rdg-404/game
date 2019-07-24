extends Area2D

export var time = 10.0

func _ready():
	pass


func _on_speed_power_up_body_entered(body):
	get_tree().call_group("power_up_bar", "start", time) #chama o grupo, usa o metodo start e determina o tempo do power up
	body.speed() # chama a função do power up de correr
	queue_free()



