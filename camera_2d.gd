extends Camera2D

var velocity = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.x += velocity
	position.x = clamp(position.x, 250, 1500)


func _on_left_bound_mouse_entered():
	velocity = -6
	print("left")


func _on_left_bound_mouse_exited():
	velocity = 0


func _on_right_bound_mouse_entered():
	velocity = 6


func _on_right_bound_mouse_exited():
	velocity = 0
	print("right")
