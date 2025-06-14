class_name FileManager
extends Object

const USE_ENCRYPTION_SETTING_NAME: String = "save_load_system/use_encryption"
const ENCRYPTION_KEY_SETTING_NAME: String = "save_load_system/encryption_key"

var path: String
var file_number: int

func _init(path: String, file_number: int = 1):
	self.path = path
	self.file_number = file_number

func set_file_number(number: int) -> void:
	file_number = number

func get_file() -> ConfigFile:
	var file = ConfigFile.new()
	var filename = "%ssf_%d.ini" % [path, file_number]
	var encrypt := ProjectSettings.get_setting(USE_ENCRYPTION_SETTING_NAME, false)
	var password := ProjectSettings.get_setting(ENCRYPTION_KEY_SETTING_NAME, "un2IAd9ShlecsmvQZVdJsnxya2Abmft3")
	
	var err = file.load_encrypted_pass(filename, password) if encrypt else file.load(filename)
	if err != OK:
		push_warning("Config loading error: %d" % err)
	return file

func save_file(file: ConfigFile) -> Error:
	var filename = "%ssf_%d.ini" % [path, file_number]
	var encrypt := ProjectSettings.get_setting(USE_ENCRYPTION_SETTING_NAME, false)
	var password := ProjectSettings.get_setting(ENCRYPTION_KEY_SETTING_NAME, "un2IAd9ShlecsmvQZVdJsnxya2Abmft3")
	
	var err = file.save_encrypted_pass(filename, password) if encrypt else file.save(filename)
	if err != OK:
		push_warning("Config save error: %d" % err)
		return err
	return OK
