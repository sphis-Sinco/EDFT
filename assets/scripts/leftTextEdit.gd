extends LineEdit

#region brainrot.
const BRAINROT_COMMANDS = [
	"deez", "deez nuts", "gyatt", "rizz", "sigma", "based", "slay", "cap", "no cap",
	"mid", "sus", "bet", "drip", "goofy", "npc", "delulu", "fanum tax", "ate", 
	"he/she/they ate", "it's giving", "corecore", "rizzler", "skibidi", "skibidi toilet",
	"gigachad", "slop", "brainrot", "ohio", "zesty", "bussin", "bop", "shmacked",
	"glo-up", "sussy", "brokie", "glazing", "nahhh", "sheesh", "pushin p", "mewing",
	"goblincore", "touch grass", "ratio", "malewife", "babygirl", "pookie", "yassified",
	"stan", "doomscroll", "trauma dump", "shidpost", "cope", "cringe", "hyperfixated",
	"villain arc", "main character energy", "quiet quitting", "feral", "oof", "yeet",
	"vibe check", "smol", "chonky", "slaps", "fyp", "npc behavior", "nah fam", "i fear",
	"i’m him", "they fell off", "screaming crying throwing up"
]
#endregion

#region PANELS
@onready var leftText = $"../Left"
@onready var rightText = $"../Right"
#endregion

#region SFX VARIABLES
@onready var left_type = $"../LeftType"
@onready var unknown_cmd = $"../UnknownCmd"
@onready var known_cmd = $"../KnownCmd"
@onready var typing_sound = $"../RightTypin"
#endregion

@onready var this = $"."

var cheats = false

#region HISTORY VARIABLES
var history = []
var history_entry = -1
#endregion

func _ready():
	rightText.text = 'Type "Help" for a list of commands.'
	Global.typing_sound = typing_sound
	Global.tween_visible_ratio(rightText)

func _input(event):
	if event is InputEventKey and event.pressed and !event.echo:
		_play_sound(left_type)
		
		if event.is_action_released("ui_up"):
			_update_history(-1)
		elif event.is_action_released("ui_down"):
			_update_history(1)

#region UPDATE HISTORY
func _update_history(direction: int):
	history_entry += direction
	history_entry = clamp(history_entry, 0, history.size() - 1)

	if history_entry < history.size():
		text = history[history_entry]
	else:
		text = ""
#endregion

#region ENTER COMMAND
func _on_text_submitted(new_text):
	history.append(new_text)
	history_entry = history.size()
	print_rich("> " + new_text)
	clear()

	var args = new_text.split(" ")
	var cmd = args[0].to_lower()
	var response = Global.COMMAND_UNKNOWN.replace('$cmd', new_text)

#region COMMAND CHECK
	match cmd:
		"help":
			response = Global.SIDE_SPACING_10 + " HELP " + Global.SIDE_SPACING_10 + "\n" + Global.load_from_file("assets/commands/help.txt")
		"list":
			response = Global.SIDE_SPACING_10 + " DIRECTORY " + Global.SIDE_SPACING_10
			for item in Global.DIRECTORY:
				response += "\n" + Global.parse_directory_entry(item)
		"open":
			response = _handle_open(args)
		"close":
			rightText.text = ""
			response = Global.COMMAND_CLOSE
		"back":
			if Global.DIRECTORY == Global.DIRECTORY_PRIVATE:
				Global.ALT_HOME_DIR = true
				Global.DIRECTORY = Global.DIRECTORY_HOME_ALT
				response = "Returned to Home directory"
		"permissions", "perms":
			response = "You are an ADMIN" if Global.ADMIN else "You are not an ADMIN"
		"tjaf":
			response = "Go read TJ and friends on Webtoons"
		"terminal.sys.permissions.can_change_clearance=true":
			Global.CAN_CHANGE_CLEARANCE = true
			response = "can_change_clearance is now true"
		"terminal.clearance_level=terminal.clearance_levels.admin":
			if Global.CAN_CHANGE_CLEARANCE:
				Global.ADMIN = true
				Global.DIRECTORY = Global.DIRECTORY_HOME_ALT
				response = "Clearance level changed"
			else:
				response = "You cannot change your clearance level. This action has been logged."
		"5secretcheat":
			if cheats:
				Global.ADMIN = true
				Global.CAN_CHANGE_CLEARANCE = true
				Global.DIRECTORY = Global.DIRECTORY_PRIVATE
				response = "Sinco cheat"
		"specter.trace":
			if Global.CAN_DO_ENDING:
				rightText.text = Global.load_from_file("assets/files/specter_trace.txt")
				Global.DIRECTORY = Global.DIRECTOR_SPECTOR
				Global.tween_visible_ratio(rightText)
				response = "Secret command unlocked"
		"run":
			response = _handle_run(args)
		"clear":
			leftText.text = ""
			response = "Screen cleared"
		_:
			if cmd in BRAINROT_COMMANDS:
				response = "This is an official government-funded terminal, this brain rotten response has been recorded and sent to the nearest supervisor. You could get fired for this childish act."
			else:
				play_unknown_cmd()
#endregion

	if not unknown_cmd.playing:
		play_known_cmd()

	leftText.add_text("\n" + response)
#endregion

#region OPEN COMMAND
func _handle_open(args):
	if args.size() <= 1:
		return Global.MISSING_X_ARGS

	var target = args[1]
	var found = false
	for item in Global.DIRECTORY:
		var parsed = Global.parse_directory_entry(item, false)
		if parsed[0] == target:
			rightText.text = parsed[2]
			Global.tween_visible_ratio(rightText)
			found = true

			if parsed[0] == "private" and Global.ADMIN and Global.DIRECTORY == Global.DIRECTORY_HOME_ALT:
				Global.DIRECTORY = Global.DIRECTORY_PRIVATE

			return '"' + target + '" has been opened on the right panel'

	return '"' + target + '" doesn\'t exist'
#endregion

#region RUN COMMAND
func _handle_run(args):
	if args.size() <= 1:
		return Global.MISSING_X_ARGS

	var file = args[1]
	if Global.DIRECTORY != Global.DIRECTORY_PRIVATE:
		return "[ERROR] " + file + ": File not found or inaccessible"

	match file:
		"RUNME.sys":
			Global.CAN_DO_ENDING = true
			return "specter.trace enabled"
		"command_test.dump":
			rightText.text = "[INFO] Executing test command list...\n> home/private/\n> test.commandlist/run_protocol.sh\n> ...\n> specter.trace\n[WARNING] 'specter.trace' is a flagged operation.\n[STATUS] SYSTEM OVERWRITE DETECTED\n[HALT] Execution paused — Administrative input required. Proceed? (Y/N)"
			Global.tween_visible_ratio(rightText)
			return "command_test.dump loaded into memory"
		"clearance_overrides.sys":
			return "[LOCKOUT TRIP] clearance_overrides.sys flagged as immutable. Override attempts will be logged and traced."
		_:
			if file.get_extension() in ["sys", "dump"]:
				return "[ERROR] " + file + ": File not found or inaccessible"
			return "[ERROR] " + file + ": File not a system filetype"
#endregion

func end_game():
	print_rich("It's over")
	this.editable = false
	Global.DIRECTORY.clear()
	rightText.text = Global.load_from_file("assets/credits.txt")
	Global.tween_visible_ratio(rightText)

func _play_sound(player):
	if player and player.stream:
		if player.playing:
			player.stop()
		player.play()

func play_unknown_cmd(): _play_sound(unknown_cmd)
func play_known_cmd(): _play_sound(known_cmd)
