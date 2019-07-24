extends Node2D

signal stars_finished #sinal de mostrar as estrelas

func _ready():
	#play(0) #quantidades de estrelas que aparecerão
	pass

func play(stars):
	stars = clamp(stars , 0 , 3) #garante que vai aparecer somente 1 ou 3 estrelas
	for s in range (stars):  #passa pegando as estrelas filhas
		var star = get_child(s) #pega as estrelas filhas
		star.play() #metodo de aparecer as estrelas
		yield(star, "finished") # espera a animação de cada estrela aparecendo
	emit_signal("stars_finished") #emite o sinal de mostrar as estelas