extends CanvasLayer

var messages = ["", "", ""]
var message_focus = 0
var message_labels = [$Message1, $Message2, $Message3]
var goblin_cost = 70
var slasher_cost = 400
var ogre_cost = 150



# Called when the node enters the scene tree for the first time.
func _ready():
	#hide()
	message_labels = [$Message1, $Message2, $Message3]
	on_receive_message("")
	start()

func start():
	show()
	$ButtonX.hide()
	$CancelLabel.hide()
	
func enable_buy(button):
	button.disabled = false
	button.mouse_filter = 0
	
func disable_buy(button):
	button.disabled = true
	button.mouse_filter = 2
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func on_player_turn_start():
	enable_buy($ButtonGoblin)
	enable_buy($ButtonSlasher)
	enable_buy($ButtonOgre)
	
	on_update_gold()
	#on_moves_change(Global.TheDungeon.moves_left)
	
	$TurnMonsters.show()
	$TurnHeroes.hide()
	$MovesLabel.text = str(Global.TheDungeon.moves_left)
	$EndTurnMessage.show()
	
func on_player_turn_end():
	disable_buy($ButtonGoblin)
	disable_buy($ButtonSlasher)
	disable_buy($ButtonOgre)
	
	$TurnMonsters.hide()
	$TurnHeroes.show()
	$MovesLabel.text = str(Global.TheDungeon.moves_left)
	$EndTurnMessage.hide()
	
func on_update_gold():
	var amount = Global.ThePlayer.gold
	if Global.ThePlayer.is_turn and Global.TheDungeon.get_rooms_open().size() > 0:
		if amount < goblin_cost:
			disable_buy($ButtonGoblin)
			disable_buy($ButtonSlasher)
			disable_buy($ButtonOgre)
		elif amount < ogre_cost:
			enable_buy($ButtonGoblin)
			disable_buy($ButtonSlasher)
			disable_buy($ButtonOgre)
		elif amount < slasher_cost:
			enable_buy($ButtonGoblin)
			disable_buy($ButtonSlasher)
			enable_buy($ButtonOgre)
		else:
			enable_buy($ButtonGoblin)
			enable_buy($ButtonSlasher)
			enable_buy($ButtonOgre)
	
	$Gold.text = str(amount)
	
func on_moves_changed():
	$MovesLabel.text = str(Global.TheDungeon.moves_left)
	
func update_messages():
	var len = 3
	print(message_focus)
	if messages.size() < len: len = messages.size()
	for i in range(len):
		message_labels[i].text = messages[i + message_focus]
	
func on_receive_message(message):
	print(message)
	messages.push_front(message)
	update_messages()
	


func _on_message_up_pressed():

	if message_focus + 3 < messages.size() - 1: message_focus += 1
	update_messages()


func _on_message_down_pressed():
	if message_focus > 0: message_focus -= 1
	update_messages()
