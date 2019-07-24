extends Node


var pre_stars_won = preload("res://scenes/stars_won.tscn") # chama a cena stars_won para dentro da cena game

#dicionario mostrando quantas estrelas o jogador ganha se pegar determinada qunatidade de moeda
var prize_stars = [
	{
		average = .3, 
		prize = 1
	},
	
	{
		average = .7, 
		prize = 2
	},
	
	{
		average = 1, 
		prize = 3
	}
	
]

var stars_won #variavel de estrelas ganhas 

enum{MENU, LOADING, LOADED} #status do game

var status = MENU
var current_music
var current_stage
#var current_stage_name
var loaded_stage 
var ref_stage
var stage_fruits


func _ready():
	$HUD/controls.hide() #esconde a pontuação e power up 
	$HUD/stage_exit.hide()
	add_to_group("game") # add o game a um grupo


func stage_selected(button):
	if status == MENU: #se o status estiver em menu
		status = LOADING # muda o status para o modo loading
		current_stage = button.stage #stage atual recebe o que foi clicado no botao
		current_music = button.music #music atual recebe o que foi clicado no botao
		#current_stage_name = button.stage_name
		$interface.hide() #faz o menu sumir ao iniciar o game
		load_stage() #chama a função carregar jogo
		$HUD/controls.show() #mostra os controles quando inicia o jogo
		$HUD/stage_exit.show() #mostra o botao para sair da fase quando inicia o jogo
		$HUD/countdown.show() #mostra a contagem regressiva quando inicia o jogo
		status = LOADED #jogo carregado
		
		
func load_stage():
	stage_fruits = 0 #quantidade de frutas no game
	$HUD/controls/punctuation.fruits = 0 #zera a pontuação ao morrer
	if loaded_stage != null && ref_stage.get_ref() != null: # se nao tiver vazio e se a fase ainda estiver salva na memoria
		loaded_stage.queue_free() #apaga o load_stage
	loaded_stage = load(current_stage).instance() #load_stage carrega a fase atual clicada no butao
	ref_stage = weakref(loaded_stage) #guarda a fase na memoria
	if current_music: #verifica se tem uma musica
		$music.stream = load(current_music) #carrega  a musica se existir
	add_child(loaded_stage) #add a fase carregada a cena
	$HUD/countdown/animation.play("count") #executa a animação de contagem regressiva
	yield($HUD/countdown/animation, "animation_finished") #executa a animação ate acabar só depois chama o metodo seguinte
	get_tree().call_group("player", "start") #chama o metodo start que esta dentro do grupo player
	play_music() #inicia a music assim que termina a contagem 
	#print(stage_fruits)
	
	
#se o player morrer recarrega a fase
func player_dead():
	stop_music() #para a musica
	var time = get_tree().create_timer(1.5) #cria um timer dentro do script onde pode definir tempo de execução
	yield(time, "timeout") #espera o tempo t terminar para terminar a animação
	load_stage() 
	#$HUD/controls/punctuation.fruits = 0

#
#func player_dying(): #quando o player estiver morrendo 
#	stop_music()  #para a musica
	
	
	
func player_victory(): # se o player chegar no final da fase 
	stop_music()
	$stream_victory.play() #toca musica de vitoria
	
	var average = float($HUD/controls/punctuation.fruits) / float(stage_fruits) #media de quantas estrelas ganha se pegar tantas frutas
	var prize = 0 #quantidade de estrelas
	
	for ps in prize_stars: #passa pelo dicionario
		if average >= ps.average: #se a media for maior ou igual ao valor que estar no dicionario
			prize = ps.prize #quantidade de estrelas sera o que esta no dicionario
			
	#print("prize: " + str(prize))
	#GAME_DATA.save_prize(current_stage_name, prize)
	stars_won = pre_stars_won.instance() # cria uma nova instancia
	
	$HUD.add_child(stars_won) # add a cena stars_ won dentro da cena game
	stars_won.play(prize) #executa a cena stars_won
	yield(stars_won, "stars_finished") #espera a cena stars_won acabar 
	
	var t = get_tree().create_timer(3) #cria um timer dentro do script onde pode definir tempo de execução
	yield(t, "timeout") #espera o tempo t terminar para terminar a animação
	exit_stage() #chama a função sair da fase

func _on_stage_exit_pressed(): #se o player pressionar o botao para sair da fase
	exit_stage()  #chama a função sair da fase
	
	
	
func exit_stage():
	stop_music() #para de tocar a music
	get_tree().call_group("power_up_bar", "stop") #some com a barra de power up quando sair da fase
	loaded_stage.queue_free()  #apaga a tela principal
	$interface.show() #mostra o menu
	$HUD/controls.hide() #esconde os controles
	$HUD/stage_exit.hide() #esconde o botao sair da fase
	$HUD/countdown.hide() #esconde a contagem regressiva
	status = MENU #menu fica selecionavel
	
	if stars_won != null and weakref(stars_won): # verifica se nao é nulo e se ja foi excluido
		stars_won.queue_free()
	
	
	
func play_music():
	if current_music: #se tiver uma musica 
		$music.play() #toca a musica
		
#funcao para parar a musica
func stop_music(): 
	$music.stop()
	
func add_stage_fruits():
	stage_fruits += 1 
	