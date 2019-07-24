extends Button

export(String, FILE) var stage #faz se possivel voce selecionar qual fase inicia se clicar no botao 
export(String, FILE) var music
#export var stage_name = "stg00"

func _ready():
	pass


func _on_button_pressed():
	get_tree().call_group("game", "stage_selected", self) #chama o grupo game, enviando o proprio botao como parametro
