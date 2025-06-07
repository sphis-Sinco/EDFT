extends RichTextLabel

func _ready():
	text = 'Earth Defence Force Terminal v'+Global.GAME_VERSION
	Global.DIRECTORY = Global.DIRECTORY_HOME

func _unhandled_input(event):
	pass
