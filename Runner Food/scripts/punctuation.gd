extends Node2D

var fruits = 0 setget set_fruit

func _ready():
	update_label()
	add_to_group("punctuation")
	pass
func pick_fruit():
	self.fruits += 1

func update_label():
	$counter.text = str(fruits) # pega o contador de moedas e converte em textos
	
func set_fruit(val):
	fruits = val 
	update_label()