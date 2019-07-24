extends KinematicBody2D

const gravity = 2000 # gravidade
#var velX = 500 # velocidade em x
var velocity = Vector2(0, 0) # define uma velocidade do player
var jump = false #controle de salto
var jump_release = false #esta pressionado o botão pular
var was_on_floor = false #estava no chão
var controled_jump = false # controle do salto

onready var mask = collision_mask #para o player parar de colidir com objetos 
onready var layer = collision_layer #para o player parar de colidir com objetos

enum {IDLE, RUNNING, DEAD, SPEED, VICTORY} #estados do player

var status = IDLE #estado atual do player

func _ready():
	add_to_group("player")
	set_process_input(true) #processo de teclar ou tocar

func _physics_process(delta):
	
	if status == RUNNING: 
		running(delta)
		
	elif status == SPEED:
		speeding(delta)
	
	elif status == DEAD:
		dead(delta)
		
	jump = false # para de pular
	jump_release = false  #estar pulando
	
	
	
#função do player correndo
func running(delta):
	velocity.y += gravity * delta # add gravidade e controla a velocidade da queda
	velocity.x = 500 # a velocidade normal do player
	velocity = move_and_slide(velocity, Vector2(0, -1)) # controla a movimentação e a direção do chão
	
	if is_on_floor(): # quando estiver no chão
		if not was_on_floor:
			$animation_landed.play("boing")
			$dust/animation.play("dust")
		$sprite.play("walk")#executa a animação walk
		if jump: #se pular 
			jump(1200, true) # controla a altura do salto e se esta sendo controlado
	else: # se nao estiver no chão
		$sprite.play("jump") # animação pulando
		if jump_release and velocity.y < 0 and controled_jump: #se parar de apertar o botão pular 
			velocity.y *= .6 #toque mais suave no mouse
	
	was_on_floor = is_on_floor()

#função de estado morto do player
func dead(delta):
	$sprite.play("idle")
	#movimento do player morrendo
	translate(velocity * delta) 
	velocity.y += gravity * delta


#função para quando pegar o power up de correr
func speeding(delta):
	velocity.y += gravity * delta # add gravidade e controla a velocidade da queda
	velocity.x = 900 # a velocidade do player aumenta
	velocity = move_and_slide(velocity, Vector2(0, -1)) # controla a movimentação e a direção do chão
	
	
	if is_on_floor(): # quando estiver no chão
		if not was_on_floor:
			$animation_landed.play("boing")
			$dust/animation.play("dust")
		$sprite.play("walk")#executa a animação walk
		if jump: #se pular 
			jump(1200, true) # controla a altura do salto e se esta sendo controlado
	else: # se nao estiver no chão
		$sprite.play("jump") # animação pulando
		if jump_release and velocity.y < 0 and controled_jump: #se parar de apertar o botão pular 
			velocity.y *= .6 #toque mais suave no mouse
	
	was_on_floor = is_on_floor()
		


func _input(event):
	if event is InputEventMouseButton or event.is_action("jump"): # se o evento for um toque no mouse  ou um toque na tecla de pular(space)
		if event.pressed:
			jump = true # pula
		else:
			jump_release = true #parou de pular



func jump(force, controled): #função de pulo
	velocity.y = -force #velocidade recebe a força ja definida
	controled_jump = controled # controla o salto
	
	
	
#função morte do player
func killed():
	if status != DEAD: #se ele nao estiver morto
		status = DEAD #ele morre
		collision_mask = 0 #para de colidir 
		collision_layer = 0 #para de colidir 
		velocity = Vector2(0, -1000) #animação de morte estilo mario
		$dead.play() # som da morte
		get_tree().call_group("game", "player_dead")
		get_tree().call_group("power_up_bar", "stop")
		get_tree().call_group("game", "player_dying")



#velocidade com que se move quando pega o power up
func speed():
	#velX = 700
	status = SPEED
	
	
	
func victory():
	status = VICTORY
	$sprite.play("idle")
	get_tree().call_group("game", "player_victory")
	
	
	
func power_up_finished(): #quando a barra de energia acabar 
	if status != DEAD: # se nao estiver morto
		status = RUNNING #status muda
		#velX = 500  #velocidade diminui
		
		
func start():
	status = RUNNING


func _on_areaColision_body_entered(body): 
	if body.name == "bullet_enemy_air": #no caso o projetil inimigo do ar 
		self.killed() #o player morre
		
