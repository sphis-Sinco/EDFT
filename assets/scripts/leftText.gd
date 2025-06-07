extends RichTextLabel

func _ready():
	text = 'Earth Defence Force Terminal v'+ProjectSettings.get_setting("application/config/version")+'\nRunning on Godot v'+Engine.get_version_info()["string"]
	Global.DIRECTORY = Global.DIRECTORY_HOME

func _unhandled_input(event):
	pass
