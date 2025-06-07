extends LineEdit

var cheats = false

@onready var leftText = $"../Left"
@onready var rightText = $"../Right"

@onready var left_type = $"../LeftType"
@onready var unknown_cmd = $"../UnknownCmd"
@onready var known_cmd = $"../KnownCmd"

@onready var crt = $"../Camera2D/CanvasLayer/CRT"

var history = []
var history_entry = -1

func _input(event):
	if event is InputEventKey and event.pressed and !event.echo:
		if left_type and left_type.stream:
			if left_type.playing:
				left_type.stop()
			left_type.play()
			
	var up = event.is_action_released("ui_up")
	var down = event.is_action_released("ui_down")
	
	if up or down:
		if up:
			history_entry -= 1
		if down:
			history_entry += 1
	
		var hs = history.size()
		var hsp = hs + 1
		var valid = true
		
		match history_entry:
			-1:
				valid = false
				history_entry = 0
			hs, hsp:
				valid = false
				history_entry = hs - 1

		if valid:
				text = history[history_entry]
		else:
			text = ""

func _on_text_submitted(new_text):
	history.append(new_text)
	history_entry = history.size()
	
	print_rich('> '+new_text)
	clear()
	
	var response = Global.COMMAND_UNKNOWN.replace('$cmd', new_text)
	var args = new_text.split(' ')	
	var input = args[0].to_lower()
	
	match input:
		"help":
			response = Global.SIDE_SPACING_10+' HELP '+Global.SIDE_SPACING_10+'\n'+Global.COMMAND_HELP
		"list":
			response = Global.SIDE_SPACING_10+' DIRECTORY '+Global.SIDE_SPACING_10
			for item in Global.DIRECTORY:
				response += '\n'+Global.parse_directory_entry(item)
		"open":
			if args.size() > 1:
				response = '"'+args[1]+'"'
				# print_rich(Global.DIRECTORY)
				var cantfind = true
				
				for item in Global.DIRECTORY:
					var parseditem = Global.parse_directory_entry(item, false)
					
					if parseditem[0] == args[1]:
						cantfind = false
						response += ' has been opened on the right panel'
						rightText.text = parseditem[2]
						
						if parseditem[0] == 'private' and Global.ADMIN and Global.DIRECTORY == Global.DIRECTORY_HOME_ALT:
								Global.DIRECTORY = Global.DIRECTORY_PRIVATE
								
						tween_visible_ratio()
						
				if cantfind:
					response += ' doesn\'t exist'
			else:
				response = 'Missing first argument'
		"close":
			response = Global.COMMAND_CLOSE
			rightText.text = ""
		"back":
			response = "Returned to Home directory"
			match Global.DIRECTORY:
				Global.DIRECTORY_PRIVATE:
					print('alt home dir')
					Global.ALT_HOME_DIR = true
					Global.DIRECTORY = Global.DIRECTORY_HOME_ALT
		"deez", "deez nuts", "gyatt", "rizz", "sigma", "based", "slay", "cap", "no cap", "mid", "sus", "bet", "drip", "goofy", "npc", "delulu", "fanum tax", "ate", "he/she/they ate", "it's giving", "corecore", "rizzler", "skibidi", "skibidi toilet", "gigachad", "slop", "brainrot", "ohio", "zesty", "bussin", "bop", "shmacked", "glo-up", "sussy", "brokie", "glazing", "nahhh", "sheesh", "pushin p", "mewing", "goblincore", "touch grass", "ratio", "malewife", "babygirl", "pookie", "yassified", "stan", "doomscroll", "trauma dump", "shidpost", "cope", "cringe", "hyperfixated", "villain arc", "main character energy", "quiet quitting", "feral", "oof", "yeet", "vibe check", "smol", "chonky", "slaps", "fyp", "npc behavior", "nah fam", "i fear", "i’m him", "they fell off", "screaming crying throwing up":
			response = 'This is an official government-funded terminal, this brain rotten response has been recorded and sent to the nearest supervisor, this is most likely a warning, but beware. You could get fired for this childish act.'
		"permissions", "perms":
			if Global.ADMIN:
				response = "You are an ADMIN"
			else:
				response = "You are not an ADMIN"
		"tjaf":
			response = "Go read TJ and friends on Webtoons"
		"terminal.sys.permissions.can_change_clearance=true":
			response = "can_change_clearance is now true"
			Global.CAN_CHANGE_CLEARANCE = true
		"terminal.clearance_level=terminal.clearance_levels.admin":
			if Global.CAN_CHANGE_CLEARANCE:
				Global.ADMIN = true
				Global.DIRECTORY = Global.DIRECTORY_HOME_ALT
				print('alt home dir')
				response = "Clearance level changed"
			else:
				response = "You cannot change your clearance level. This action has been logged."
		"5secretcheat":
			if cheats:
				Global.CAN_CHANGE_CLEARANCE = true
				Global.ADMIN = true
				Global.DIRECTORY = Global.DIRECTORY_PRIVATE
				response = "Sinco cheat"
		"specter.trace":
			if Global.CAN_DO_ENDING:
				response = "Secret command unlocked"
				rightText.text = Global.load_from_file('assets/files/specter_trace.txt')
				Global.DIRECTORY = Global.DIRECTOR_SPECTOR
				tween_visible_ratio()
		"run":
			if args.size() > 1:
				var errortxt = '[ERROR] '+args[1]+': File not found or inaccessible — reference checksum mismatch (code: 0xRBK404)'
				response = errortxt
				match args[1]:
					'RUNME.sys':
						if Global.DIRECTORY == Global.DIRECTORY_PRIVATE:
							response = 'specter.trace enabled'
							Global.CAN_DO_ENDING = true
					'rollback.sys':
						pass
					'command_test.dump':
						if Global.DIRECTORY == Global.DIRECTORY_PRIVATE:
							response = 'command_test.dump loaded into memory'
							rightText.text = '[INFO] Executing test command list...\n> home/private/\n> test.commandlist/run_protocol.sh\n> ...\n> specter.trace\n[WARNING] \'specter.trace\' is a flagged operation.\n[STATUS] SYSTEM OVERWRITE DETECTED\n[HALT] Execution paused — Administrative input required. Proceed? (Y/N)'
							tween_visible_ratio()
					'clearance_overrides.sys':
						if Global.DIRECTORY == Global.DIRECTORY_PRIVATE:
							response = '[LOCKOUT TRIP] clearance_overrides.sys flagged as immutable. Override attempts will be logged and traced.'
					_:
						response = '[ERROR] '+args[1]+': File not a system filetype'
						if args[1].split('.').size() > 1:
							match args[1].split('.')[1]:
								'sys', 'dump':
									response = errortxt
			else:
				response = 'Missing first argument'
		_:
			if unknown_cmd and unknown_cmd.stream:
				if unknown_cmd.playing:
					unknown_cmd.stop()
				unknown_cmd.play()
	
	if not unknown_cmd.playing:
		if known_cmd and known_cmd.stream:
				if known_cmd.playing:
					known_cmd.stop()
				known_cmd.play()
	
	leftText.add_text('\n'+response)

@onready var typing_sound = $"../RightTypin"

func tween_visible_ratio(text = rightText, duration = 3.0, delay = 1.0) -> void:
	text.visible_ratio = 0.0
	if tween:
		if tween.is_running():
			tween.stop()
	if typing_sound and typing_sound.stream:
		typing_sound.play()

	if delay > 0.0:
		var timer = Timer.new()
		timer.wait_time = delay
		timer.one_shot = true
		add_child(timer)
		timer.start()
		timer.timeout.connect(Callable(self, "_start_tween").bind(text, duration))
	else:
		_start_tween(text, duration)

var tween

func _start_tween(text, duration) -> void:
	var tween2 = create_tween()
	tween2.tween_property(text, "visible_ratio", 1.0, duration).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	tween2.connect("finished", Callable(self, "_on_tween_finished"))
	tween = tween2

func _on_tween_finished() -> void:
	if typing_sound and typing_sound.playing:
		typing_sound.stop()
		
	if rightText.text == Global.load_from_file('assets/files/truth.txt'):
		var timer = Timer.new()
		timer.wait_time = 30
		timer.one_shot = true
		add_child(timer)
		timer.start()
		timer.timeout.connect(Callable(self, "end_game"))
		
@onready var line_edit = $"."

func end_game():
	print_rich("It's over")
	
	line_edit.editable = false
	
	Global.DIRECTORY = []
	
	rightText.text = Global.load_from_file('assets/credits.txt')
	tween_visible_ratio()
