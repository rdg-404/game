extends StaticBody2D

var flip = true
var posicao_inicial 
var posicao_final
var velocidade = 2
var distancia_perc = 400
const PRE_BULLET = preload("res://scenes/bullet_enemy_air.tscn") # chama a outra cena criada separadamente

func _ready():
	posicao_inicial = $".".position.x
	posicao_final = posicao_inicial + distancia_perc


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
			
func _on_shoot_timer_timeout(): #func para criar tiros sucessivos, cria-se usando o nó timer
	var bullet_enemy_air = PRE_BULLET.instance() #cria uma nova bala
	bullet_enemy_air.global_position = global_position #posiciona a bala no mesmo lugar que as outras
	bullet_enemy_air.dir = Vector2(cos(rotation), sin(rotation)) #direciona a bala na mesma direção que as outras
	get_parent().add_child(bullet_enemy_air) #add bala como filha do nó principal
	$animation.play("move")