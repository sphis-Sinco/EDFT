extends Node2D

@onready var left = $Left
@onready var right = $Right
@onready var flicker = $Flicker
@onready var animation_player = $Flicker/AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	animation_player.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
