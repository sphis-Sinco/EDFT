extends Area2D

@onready var textbar = $"../../Employee/Camera2D/Textbar"
@onready var rich_text_label = $"../../Employee/Camera2D/Textbar/RichTextLabel"

@export var dialogue_list = [
	["Boss: Ritok. Glad you made it.", 1],
	["Boss: You're probably going to regret coming here however.", 2],
	["Boss: You're fired.", 1],
	["Boss: Management has desided that you're too unstable to keep on the EDFT project."],
	["Boss: So we are firing you.", 1],
	["Boss: Sorry.", 0.5],
	["Ritok: ...", 2],
	["Ritok: Are you fucking kiding me?", 1]
]
var dialogue_index = -1

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.typing_sound = $"../../RightTypin"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

@onready var employee = $"../../Employee"
@onready var area_2d = $"../../Employee/Area2D"

var player_interacting = false

func _input(event):
	if event.is_action_released("ui_accept") and player_interacting:
		dialogue_index += 1
		if not dialogue_index == dialogue_list.size():
			textbar.visible = true
			rich_text_label.text = dialogue_list[dialogue_index][0]
			var time = 3
			if dialogue_list[dialogue_index].size() > 1:
				time = dialogue_list[dialogue_index][1]
			Global.tween_visible_ratio(rich_text_label, time, 0)
		else:
			get_tree().change_scene_to_file("res://scenes/EDFT.tscn")

func _on_area_entered(area):
	if area == area_2d:
		print('yo')
		player_interacting = true

func _on_area_exited(area):
	if area == area_2d:
		print('bye')
		player_interacting = false
