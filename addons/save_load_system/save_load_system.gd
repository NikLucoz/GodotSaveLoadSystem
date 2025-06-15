extends Node

var file_manager: FileManager
var nodes_to_save: Array[Node] = []

signal save_triggered
signal savefile_number_changed
signal save_done
signal save_error(err: Error)

func _initial_configuration(save_folder_path: String, file_number: int = 1) -> void:
	file_manager = FileManager.new(save_folder_path, file_number)

func change_savefile_number(number: int) -> void:
	file_manager.set_file_number(number)
	savefile_number_changed.emit()

func get_savefile() -> ConfigFile:
	return file_manager.get_file()
	
func add_save_object(node: Node) -> void:
	if node.has_method("save_to_file") and not nodes_to_save.has(node):
		nodes_to_save.append(node)

func trigger_save() -> void:
	save_triggered.emit()
	nodes_to_save = nodes_to_save.filter(func(n): return n != null)

	var file = file_manager.get_file()
	if file == null:
		return
	
	for node in nodes_to_save:
		node.save_to_file(file)
	
	var res = file_manager.save_file(file)
	if res != OK:
		save_error.emit(res)
		return
	
	save_done.emit()
