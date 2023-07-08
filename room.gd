extends Area2D

var num_monsters
var next_rooms
var prev_rooms
var has_party

# Called when the node enters the scene tree for the first time.
func _ready():
	start()

func start():
	$button.disabled = true
	
func on_gain_focus():
	$button.disabled = false
	
func on_lose_focus():
	$button.disabled = false
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_pressed():
	on_lose_focus()
