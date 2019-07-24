extends Area2D

var flip = true
var posicao_inicial 
var posicao_final
var distancia_perc = 400
var velocidade = 2

func _ready():
	posicao_inicial = $".".position.x
	posicao_final = posicao_inicial + distancia_perc
	pass

#func para ficar andando de um lado para outro
func _process(delta):
	if(posicao_inicial <= posicao_final and  flip):
		$".".position.x += velocidade
		$sprite.flip_h = false
		if($".".position.x >= posicao_final):
			flip = false
	if($".".position.x >= posicao_inicial and !flip):
		$".".position.x -= velocidade
		$sprite.flip_h = true
		if($".".position.x <= posicao_inicial):
			flip = true
			

func _on_mola_body_entered(body):
	$sprite.play("action")
	$action.play()
	body.jump(1500, false)