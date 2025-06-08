extends Area2D

@export var textbar : ColorRect
@export var rich_text_label : RichTextLabel
@export var area_2d : Area2D
@export var typing_sound : AudioStreamPlayer2D

var dialogue_list = [
	["dialogue", 3]
]
var dialogue_index = -1
@export var dialogue_path = 'sequence_1'

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("area_entered", _on_area_entered)
	connect("area_exited", _on_area_exited)
	dialogue_list = Global.load_from_file('assets/dialogue/'+dialogue_path+'.txt').split('\n')
	print_rich(dialogue_list)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

var player_interacting = false

func _input(event):
	if event.is_action_released("ui_accept") and player_interacting:
		dialogue_index += 1
		if not dialogue_index == dialogue_list.size() - 1:
			textbar.visible = true
			rich_text_label.text = dialogue_list[dialogue_index].split('|')[0]
			var time = 3
			var dialogue_event
			if dialogue_list[dialogue_index].split('|').size() > 1:
				time = dialogue_list[dialogue_index].split('|')[1].to_float()
			else:
				if dialogue_list[dialogue_index].split('|')[0] == 'open.terminal':
					dialogue_event = 'startTerminal'
				elif dialogue_list[dialogue_index].split('|')[0] == 'arcade.open':
					# dialogue_event = 'startArcade'
					pass
			if not dialogue_event:
				tween_visible_ratio(rich_text_label, time, 0)
			elif dialogue_event == 'startTerminal':
				closeDialogue()
				print("switch to terminal")
				get_tree().change_scene_to_file("res://scenes/EDFT.tscn")
			# elif dialogue_event == 'startArcade':
				# closeDialogue()
				# print("switch to emulator")
				# get_tree().change_scene_to_file("res://scenes/monitor.tscn")
		else:
			closeDialogue()
			
func closeDialogue():
	rich_text_label.text = ''
	textbar.visible = false
	dialogue_index = -1
	if tween and tween.is_running():
		tween.stop()
	typing_sound.stop()

func _on_area_entered(area):
	if area == area_2d:
		print('yo')
		player_interacting = true

func _on_area_exited(area):
	if area == area_2d:
		print('bye')
		player_interacting = false
		
		if textbar.visible:
			closeDialogue()

var tween

#region TYPEWRITER EFFECT
func tween_visible_ratio(text_node, duration = 3.0, delay = 1.0) -> void:
	text_node.visible_ratio = 0.0

	if tween and tween.is_running():
		tween.stop()

	if typing_sound and typing_sound.stream:
		if typing_sound.playing:
			typing_sound.stop()
		typing_sound.play()

	if delay > 0:
		call_timer(delay, Callable(self, "_start_tween").bind(text_node, duration))
	else:
		_start_tween(text_node, duration)

func _start_tween(text, duration):
	tween = create_tween()
	tween.tween_property(text, "visible_ratio", 1.0, duration).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	tween.connect("finished", Callable(self, "_on_tween_finished").bind(text))

func _on_tween_finished(text_node):
	if typing_sound and typing_sound.playing:
		typing_sound.stop()
#endregion

func call_timer(time = 10, endfunc = Callable(self, "")):
	var timer = Timer.new()
	timer.wait_time = time
	timer.one_shot = true
	add_child(timer)
	timer.start()
	timer.timeout.connect(endfunc)
