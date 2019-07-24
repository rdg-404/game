extends KinematicBody2D

onready var player = get_parent().get_node("player") #liga a esta cena a cena do player 

var vel = Vector2(0, 0) 

var grav = 2000 #gravidade sob o inimigo(mesma do player)
var max_grav = 3000 #gravidade maxima

var react_time = 100 #tempo de reação do inimigo
var dir = 0 
var next_dir = 0
var next_dir_time = 0
var target_player_dist = 20

var eye_reach = 250
var vision = 600

var next_jump_time = -1

func _ready():
	$animation.play("move")
	set_process(true)
	
func set_dir(target_dir):
	if next_dir != target_dir:
		next_dir = target_dir
		next_dir_time = OS.get_ticks_msec() + react_time
	
	
# Visao do inimigo sobre o player 
func sees_player():
	var eye_center = get_global_position()
	var eye_top = eye_center + Vector2(0, -eye_reach)
	var eye_left = eye_center + Vector2(-eye_reach, 0)
	var eye_right = eye_center + Vector2(eye_reach, 0)

	var player_pos = player.get_global_position()
	var player_extents = player.get_node("shape").shape.extents - Vector2(1, 1)
	var top_left = player_pos + Vector2(-player_extents.x, -player_extents.y)
	var top_right = player_pos + Vector2(player_extents.x, -player_extents.y)
	var bottom_left = player_pos + Vector2(-player_extents.x, player_extents.y)
	var bottom_right = player_pos + Vector2(player_extents.x, player_extents.y)

	var space_state = get_world_2d().direct_space_state

	for eye in [eye_center, eye_top, eye_left, eye_right]:
		for corner in [top_left, top_right, bottom_left, bottom_right]:
			if (corner - eye).length() > vision:
				continue
			var collision = space_state.intersect_ray(eye, corner, [], 1)
			if collision and collision.collider.name == "player":
				return true
	return false

	
func _process(delta):
	
	if player.position.x < position.x - target_player_dist and sees_player(): #faz o inimigo seguir o player se ele estiver o vendo
		set_dir(-1)
	elif player.position.x > position.x + target_player_dist and sees_player(): #faz o inimigo seguir o player se ele estiver o vendo
		set_dir(1)
	else:
		set_dir(0)
		
	if OS.get_ticks_msec() > next_dir_time:
		dir = next_dir
		
	if OS.get_ticks_msec() > next_jump_time and next_jump_time != -1: 
		if player.position.y < position.y - 64 and sees_player(): #faz o inimigo pular no player se ele estiver o vendo
			vel.y = -800  #velocidade do pulo
		next_jump_time = -1
		
	vel.x = dir * 550 # velocidade do inimigo para seguir o player
	
	if player.position.y < position.y - 64 and next_jump_time == -1 and sees_player(): #faz o inimigo pular  (64 altura do pulo) se ele estiver vendo o player
		next_jump_time = OS.get_ticks_msec() + react_time

	vel.y += grav * delta;
	if vel.y > max_grav:
		vel.y = max_grav
		
	if is_on_floor() and vel.y > 0:
		vel.y = 0
		
	vel = move_and_slide(vel, Vector2(0, -1))



func _on_body_body_entered(body):
	body.killed()
