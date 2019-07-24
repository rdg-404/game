extends Area2D

func _ready():
	pass


func _on_end_phase_body_entered(body):
	body.victory()
