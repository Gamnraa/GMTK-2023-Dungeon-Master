extends CanvasLayer

var messages = ["", "", ""]
var message_labels = [$Message1, $Message2, $Message3]
var goblin_cost = 50
var slasher_cost = 120
var ogre_cost = 90



# Called when the node enters the scene tree for the first time.
func _ready():
	#hide()
	message_labels = [$Message1, $Message2, $Message3]
	on_receive_message("")
	start()

func start():
	show()
	$ButtonX.hide()
	
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
	
func on_player_turn_end():
	disable_buy($ButtonGoblin)
	disable_buy($ButtonSlasher)
	disable_buy($ButtonOgre)
	
	$TurnMonsters.hide()
	$TurnHeroes.show()
	$MovesLabel.text = str(Global.TheDungeon.moves_left)
	
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
	
func on_receive_message(message):
	print(message)
	messages[2] = messages[1]
	messages[1] = messages[0]
	messages[0] = message
	var i = 0
	for text in messages:
		message_labels[i].text = messages[i]
		i += 1
	
