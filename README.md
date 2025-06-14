
# SaveLoadSystem Plugin for Godot Engine 4.1^

## Overview

The **SaveLoadSystem** plugin is a utility class designed to simplify saving game data in the Godot Engine. It manages a list of nodes that implement a `save_to_file()` method and provides an easy-to-use interface for triggering and handling save operations. <br>The plugin also allows switching between multiple save files, making it ideal for managing different game states, save slots, or profiles.
<br>No need to instantiate the class, the plugin create an Autoload for you, simply call the function by using the the node `SaveLoadSystem`.

## Features

* **Centralized Save System**: Manage all saveable nodes in one place.
* **Dynamic Savefile Management**: Switch between different savefile numbers to support multiple game slots.
* **Automatic Node Filtering**: Filters out `null` nodes before saving to prevent errors.
* **Signal Emissions**: Provides signals to hook into various points of the save process:

  * `save_triggered`: Emitted right before saving starts.
  * `savefile_number_changed`: Emitted when the active savefile number changes.
  * `save_done`: Emitted when saving is successfully completed.
  * `save_error(err: Error)`: Emitted when an error occurs during the save process.
* **File Encryption Ready**: Uses an instance of `FileManager` that supports encrypted saves (with an encryption key).

## Usage

### Adding Nodes to Save

Any node you want to save must implement a function called `save_to_file(file: ConfigFile)`. This function will be called during the save process and provides a `ConfigFile` object where you can store your data.

Example:

```gdscript
# Example: player_controller.gd
extends CharacterBody3D

func _ready():
    SaveLoadSystem.add_save_object(self)

func save_to_file(file: ConfigFile):
    file.set_value("Player", "position", position)
```

### Triggering a Save

To perform a save operation from anywhere in your code do:

```gdscript
SaveLoadSystem.trigger_save()
```

This will write all saveable nodes to a file.

### Changing the Save Slot

To change the active save file number:

```gdscript
SaveLoadSystem.change_savefile_number(new_number)
```

### Loading Data from Savefile

To load data previously saved in a savefile, use the `get_savefile()` function.
This function returns a `ConfigFile` object containing the latest data from the save file.

```gdscript
# Example: player_controller.gd
extends CharacterBody3D

func _ready():
    load_data()

func load_data():
    var config: ConfigFile = SaveLoadSystem.get_savefile()
    position = config.get_value("Player", "position", Vector3(0, 1, 0))
```

### Handling Save Events

You can connect to the following signals for custom behavior:

```gdscript
SaveLoadSystem.connect("save_triggered", self, "_on_save_triggered")
SaveLoadSystem.connect("save_done", self, "_on_save_done")
SaveLoadSystem.connect("save_error", self, "_on_save_error")
```

### Change Encryption Key

If you want to change the default encryption key or disable encryption, modify the first lines in the `_ready()` function of `save_load_system.gd`.
You can enable or disable encryption with a boolean flag and set a custom key as needed.

## Notes

This system uses Godot's `ConfigFile` object. Refer to the [ConfigFile Docs](https://docs.godotengine.org/en/stable/classes/class_configfile.html) to learn how to read and write data to a ConfigFile.

## Contributing
Contributions are welcome! If you want to improve the SaveLoadSystem plugin, fix bugs, or suggest new features, feel free to contribute.

The only thing I ask is:
- Keep the code style consistent with the rest of the project.
- Write clear and concise commit messages.
- Update or add documentation if your changes affect usage.
- If you’re not sure about something, feel free to open an issue to discuss it before starting to work on it.