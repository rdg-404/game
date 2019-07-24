extends Area2D

func _ready():
	pass


func _on_limit_game_body_entered(body):
	body.victory()
