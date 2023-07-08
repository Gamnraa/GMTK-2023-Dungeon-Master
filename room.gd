extends Node2D

var num_monsters = 0
var next_rooms: Array
var prev_rooms: Array
var has_party
var has_trap
var has_treasure

signal send_to_room(room)

# Called when the node enters the scene tree for the first time.
func _ready():
	start()

func start():
	$button.disabled = true
	$button.mouse_filter = 2
	
func on_gain_focus():
	$button.disabled = false
	$button.mouse_filter = 0
	
func on_lose_focus():
	$button.disabled = true
	$button.mouse_filter = 2
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_pressed():
	send_to_room.emit(self)
	on_lose_focus()
