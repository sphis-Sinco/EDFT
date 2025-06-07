extends Node

# funcs
func save_to_file(path, content):
	var file = FileAccess.open(path, FileAccess.WRITE)
	file.store_string(content)

func load_from_file(path):
	var file = FileAccess.open(path, FileAccess.READ)
	var content = file.get_as_text()
	return content

# command responses
const COMMAND_UNKNOWN = '"$cmd" is not a known command or has not been implemented, type "help" for a list of commands'
var COMMAND_HELP = 'HELP - Send a list of commands\nLIST - Print a list of all the files in the current directory\nOPEN - Open a directory or file\nCLOSE - Close the file open on the right panel\nBACK - Head to the home directory'
const COMMAND_LIST = ''
const COMMAND_LOGIN_SUCCESS = 'Successfully logged into $acc\'s account'
const COMMAND_LOGIN_FAILURE = 'Failed to log into $acc\'s account'
const COMMAND_OPEN = ''
const COMMAND_CLOSE = 'Closed file content'

# file stuff
const FILE_EXT_MARKDOWN = 'MARKDOWN'
const FILE_EXT_FOLDER = 'FOLDER'
const FILE_EXT_TEXT = 'TEXT'
const FILE_EXT_SYSTEM = 'SYSTEM'

var FILE_PRIVATE_FOLDER = "[ERROR][EDF-T01] ACCESS DENIED: Target directory is locked by Sector Security Protocols.\n\n>> Unable to read contents of folder: /private\n>> Reason: FOLDER LOCKED — ADMIN Clearance Level required.\n\n\nContact Central Command or override with valid credentials."
var FILE_PRIVATE_FOLDER_GRANTED = "[INFO][EDF-T01] ACCESS GRANTED: Target directory unlocked by Sector Security Protocols.\n\n>> Reading contents of folder: /private\n>> Clearance Level Verified: ADMIN\n\nAccess authorized. Proceed with caution.\n\nContact Central Command for further instructions or audit logs."

# terminal stuff
var DIRECTORY_HOME = [
	['test.md', FILE_EXT_MARKDOWN, "auto", "auto", '6/12/2013'],
	['secrets.txt', FILE_EXT_TEXT, "auto", "auto", '8/23/2016'],
	['private', FILE_EXT_FOLDER, FILE_PRIVATE_FOLDER, 'unknown', '8/2/2016'],
	['manual.md', FILE_EXT_MARKDOWN, "auto", "auto", '8/23/2016']
]
var DIRECTORY_HOME_ALT = [
	['test.md', FILE_EXT_MARKDOWN, "auto", "auto", '6/12/2013'],
	['secrets.txt', FILE_EXT_TEXT, "auto", "auto", '8/23/2016'],
	['private', FILE_EXT_FOLDER, FILE_PRIVATE_FOLDER_GRANTED, 'unknown', '8/2/2016'],
	['manual.md', FILE_EXT_MARKDOWN, "auto", "auto", '8/23/2016']
]
var DIRECTORY_PRIVATE = [
	['log_entry_2048.log', FILE_EXT_TEXT, "auto", "auto", '11/30/2016'],
	['device_limits.md', FILE_EXT_MARKDOWN, "auto", "auto", '4/15/2015'],
	['device_limits_courtcase.md', FILE_EXT_MARKDOWN, "auto", "auto", '6/15/2015'],
	['project_nightfall.md', FILE_EXT_MARKDOWN, "auto", "auto", '11/30/2016'],
	["original_creator_removal.md", FILE_EXT_MARKDOWN, "auto", "auto", '8/5/2013'],
	["rollback.sys", FILE_EXT_SYSTEM, "auto", "auto", '4/17/2013'],
	["facility_snapshot.txt", FILE_EXT_TEXT, "auto", "auto", '4/17/2013'],
	
	["watchdog_fragment.log", FILE_EXT_TEXT, "auto", "auto", '01/16/2014'],
	["clearance_overrides.sys", FILE_EXT_SYSTEM, "auto", "auto", '06/10/2014'],
	["memo_unsent_specter.md", FILE_EXT_MARKDOWN, "auto", "auto", '12/05/2015'],
	["specter_ghostdir.ref", FILE_EXT_TEXT, "auto", "auto", '03/12/2016'],
	["rollback_backup.note", FILE_EXT_TEXT, "auto", "auto", '04/17/2013'],
	["command_test.dump", FILE_EXT_SYSTEM, "auto", "auto", '05/13/2016'],
	["trace_warning_internal.eml", FILE_EXT_TEXT, "auto", "auto", '02/22/2016'],
	["RUNME.sys", FILE_EXT_SYSTEM, "auto", "auto", '8/18/2016']
]
var DIRECTOR_SPECTOR = [
	['truth.txt', FILE_EXT_TEXT, "auto", "auto", '4/23/2017']
]
var DIRECTORY = []

# qol
const SIDE_SPACING_20 = '________________________________________'
var SIDE_SPACING_10 = SIDE_SPACING_20.left(10)

# random
var ADMIN = false
var CAN_CHANGE_CLEARANCE = false
var CAN_DO_ENDING = false

# LORE

# funcs
func _init():
	ADMIN = false
	CAN_CHANGE_CLEARANCE = false

func _ready():
	if StringSizeChecker == null:
		print("ERROR: StringSizeChecker singleton is null")
	else:
		print("StringSizeChecker singleton loaded successfully")
		var test = StringSizeChecker.get_string_file_size_json("test string")
		
	DIRECTORY = DIRECTORY_HOME

func filesize(your_string):
	var size_data = StringSizeChecker.get_string_file_size_json(your_string)
	var smallest = StringSizeChecker.get_smallest_nonzero_unit(size_data)

	return smallest

func parse_directory_entry(entry, dir = true):
	var parsedvalue = "["+entry[1].to_upper()+"]"
	parsedvalue += ' '+entry[0]
	
	var filecont = entry[2]
	
	if entry[2] == "auto":
		var txtEnding = '.txt'
		match entry[0].split('.')[1]:
			'md', 'txt', 'log':
				txtEnding = ''
		filecont = load_from_file('assets/files/'+entry[0]+txtEnding)
		
	# parsedvalue += ' - '+filecont
		
	parsedvalue += ' - '
	
	var filsize = entry[3]
	
	if entry[3].to_lower() == "auto":
		filsize = filesize(filecont)
		
	parsedvalue += filsize
	parsedvalue += ' - '+entry[4]
	
	if dir:
		return parsedvalue
	else:
		return [entry[0], entry[1], filecont, filsize, entry[4]]
