@tool
extends EditorPlugin


const PLUGIN_NAME := "theme switcher"
const PLUGIN_PATH := "addons/theme_switcher/"
const THEME_DEFAULT := "Default"
const PATH_PRESET := "interface/theme/preset"
const PATH_ACCENT_COLOR := "interface/theme/accent_color"

var plugin_path_light := PLUGIN_PATH.path_join("light_theme")
var plugin_path_dark := PLUGIN_PATH.path_join("dark_theme")
var plugin_path_color := PLUGIN_PATH.path_join("accent_color")
var settings = EditorInterface.get_editor_settings()


func _enter_tree() -> void:
	add_tool_menu_item(PLUGIN_NAME, _do_work)
	
	_create_theme_setting(plugin_path_dark, THEME_DEFAULT)
	_create_theme_setting(plugin_path_light, THEME_DEFAULT)
	_create_color_setting(plugin_path_color, Color.ALICE_BLUE)
	
	var os_theme_path := plugin_path_dark if DisplayServer.is_dark_mode() else plugin_path_light
	var theme = settings.get_setting(os_theme_path)
	var current_theme = settings.get_setting(PATH_PRESET)
	var accent_color = settings.get_setting(plugin_path_color)
	
	if theme != current_theme:
		print("[Theme Switcher] Setting the theme to \"%s\"" % theme)
		
		settings.set_setting(PATH_PRESET, theme)


func _exit_tree() -> void:
	remove_tool_menu_item(PLUGIN_NAME)


func _do_work() -> void:
	print(settings.get_setting(plugin_path_color))
	settings.set_setting(PATH_ACCENT_COLOR, settings.get_setting(plugin_path_color))


func _create_theme_setting(path: String, value: Variant) -> void:
	var property_info := {
		"name": path,
		"type": TYPE_STRING,
		"hint": PROPERTY_HINT_ENUM,
		"hint_string": "Default,Breeze Dark,Godot 2,Gray,Light,Solarized (Dark),Solarized (Light),Black (OLED)"
	}
	
	_create_setting(path, value, property_info)


func _create_color_setting(path: String, value: Variant) -> void:
	var property_info := {
		"name": path,
		"type": TYPE_COLOR,
		"hint": PROPERTY_HINT_COLOR_NO_ALPHA,
	}
	
	_create_setting(path, value, property_info)


func _create_setting(path: String, value: Variant, property_info: Dictionary) -> void:
	if settings.has_setting(path):
		return
	
	settings.set_setting(path, value)
	settings.add_property_info(property_info)
