extends Button

@export var hero_pos_x: int
@export var monster_pos_x: int

var num_monsters = 0
var monsters: Array
var next_rooms: Array
var prev_rooms: Array
var has_party
var has_trap
var treasure
var has_treasure

signal send_to_room(room)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func start():
	self.disabled = true
	self.mouse_filter = 2
	monsters = []
	num_monsters = 0
	has_party = false
	has_trap = false
	has_treasure = false
	$MoveLabel.hide()
	
func on_gain_focus():
	self.disabled = false
	self.mouse_filter = 0
	
func on_lose_focus():
	self.disabled = true
	self.mouse_filter = 2
	$MoveLabel.hide()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_pressed():
	send_to_room.emit(self)
	on_lose_focus()


func _on_mouse_entered():
	if not self.disabled: $MoveLabel.show()


func _on_mouse_exited():
	$MoveLabel.hide()
