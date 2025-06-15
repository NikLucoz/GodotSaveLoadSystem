@tool
extends EditorPlugin

const AUTOLOAD_NAME = "SaveLoadSystem"
const USE_ENCRYPTION_SETTING_NAME: String = "save_load_system/use_encryption"
const ENCRYPTION_KEY_SETTING_NAME: String = "save_load_system/encryption_key"

func _enable_plugin() -> void:
	if not Engine.has_singleton(AUTOLOAD_NAME):
		add_autoload_singleton(AUTOLOAD_NAME, "res://addons/save_load_system/save_load_system.gd")
	
	var error = DirAccess.make_dir_recursive_absolute(SAVE_PATH) 
	if error != OK:
		push_warning("Error creating the save folder: %s" % error_string(error))

func _disable_plugin() -> void:
	remove_autoload_singleton(AUTOLOAD_NAME)
	if ProjectSettings.has_setting(USE_ENCRYPTION_SETTING_NAME):
		ProjectSettings.set_setting(USE_ENCRYPTION_SETTING_NAME, null)
		
	if ProjectSettings.has_setting(ENCRYPTION_KEY_SETTING_NAME):
		ProjectSettings.set_setting(ENCRYPTION_KEY_SETTING_NAME, null)
	
	var dir = DirAccess.open(SAVE_PATH)
	if not dir: return
	
	for file in dir.get_files():
		dir.remove(file)
	
	DirAccess.remove_absolute(SAVE_PATH)

func _enter_tree():
	if not ProjectSettings.has_setting(USE_ENCRYPTION_SETTING_NAME):
		ProjectSettings.set_setting(USE_ENCRYPTION_SETTING_NAME, false)
	
	ProjectSettings.add_property_info({
		"name": USE_ENCRYPTION_SETTING_NAME,
		"type": TYPE_BOOL,
		"hint": PROPERTY_HINT_FLAGS,
		"hint_string": "if enable all save files will be encrypted using the provided key"
	})
	ProjectSettings.set_initial_value(USE_ENCRYPTION_SETTING_NAME, false)
	ProjectSettings.set_as_basic(USE_ENCRYPTION_SETTING_NAME, true)

	if not ProjectSettings.has_setting(ENCRYPTION_KEY_SETTING_NAME):
		ProjectSettings.set_setting(ENCRYPTION_KEY_SETTING_NAME, "un2IAd9ShlecsmvQZVdJsnxya2Abmft3")
	ProjectSettings.add_property_info({
		"name": ENCRYPTION_KEY_SETTING_NAME,
		"type": TYPE_STRING,
	})
	ProjectSettings.set_initial_value(ENCRYPTION_KEY_SETTING_NAME, "un2IAd9ShlecsmvQZVdJsnxya2Abmft3")
	ProjectSettings.set_as_basic(ENCRYPTION_KEY_SETTING_NAME, true)
	ProjectSettings.save()

func _exit_tree():
	pass

	if ProjectSettings.has_setting(USE_ENCRYPTION_SETTING_NAME):
		ProjectSettings.set_setting(USE_ENCRYPTION_SETTING_NAME, null)
		
	if ProjectSettings.has_setting(ENCRYPTION_KEY_SETTING_NAME):
		ProjectSettings.set_setting(ENCRYPTION_KEY_SETTING_NAME, null)
	
	var dir = DirAccess.open("user://saves/")
	if not dir: return
	
	for file in dir.get_files():
		dir.remove(file)
	
	DirAccess.remove_absolute("user://saves/")