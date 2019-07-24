extends StaticBody2D

var vel = 900 #velocidade de bala 
var dir = Vector2(0, 1) setget set_dir #direção da bala
var max_dist = 700 #distancia max que a bala pode percorrer
onready var init_posit = global_position  # posição inicial da bala

func _ready():
	self.dir = Vector2(0, 1) #controla a direção da bala

func _physics_process(delta):
	translate( dir * vel * delta) #faz a bala se movimentar
	if global_position.distance_to(init_posit) > max_dist: # se a bala passar do limite max 
		queue_free() # ela se destroi
		
func set_dir(val):
	dir = val #controla a direção da bala
	rotation = val.angle() #faz a bala cair sempre para baixo