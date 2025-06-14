class_name FileManager
extends Object

var encrypt: bool
var password: String
var path: String
var file_number: int

func _init(path: String, file_number: int = 1, encrypt: bool = false, password: String = ""):
	self.path = path
	self.file_number = file_number
	self.encrypt = encrypt
	self.password = password

func set_file_number(number: int) -> void:
	file_number = number

func get_file() -> ConfigFile:
	var file = ConfigFile.new()
	var filename = "%ssf_%d.ini" % [path, file_number]

	var err = file.load_encrypted_pass(filename, password) if encrypt else file.load(filename)
	if err != OK:
		push_warning("Config loading error: %d" % err)
	return file

func save_file(file: ConfigFile) -> Error:
	var filename = "%ssf_%d.ini" % [path, file_number]
	var err = file.save_encrypted_pass(filename, password) if encrypt else file.save(filename)
	if err != OK:
		push_warning("Config save error: %d" % err)
		return err
	return OK
