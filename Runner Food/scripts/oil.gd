extends Area2D

func _ready():
	pass


func _on_oil_body_entered(body):
	body.killed()
