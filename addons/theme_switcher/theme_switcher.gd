@tool
extends EditorPlugin


const PLUGIN_NAME := "theme switcher"
const PLUGIN_PATH := "addons/theme_switcher/"
const THEME_DEFAULT := "Default"
const GODOT_PATH_PRESET := "interface/theme/preset"
const GODOT_PATH_ACCENT_COLOR := "interface/theme/accent_color"

var plugin_path_theme := PLUGIN_PATH.path_join("current_theme")
var plugin_path_light := PLUGIN_PATH.path_join("light_theme")
var plugin_path_dark := PLUGIN_PATH.path_join("dark_theme")
var plugin_path_color := PLUGIN_PATH.path_join("accent_color")
var settings = EditorInterface.get_editor_settings()


func _enter_tree() -> void:
	_create_theme_setting(plugin_path_theme, "")
	_create_theme_setting(plugin_path_dark, THEME_DEFAULT)
	_create_theme_setting(plugin_path_light, THEME_DEFAULT)
	_create_color_setting(plugin_path_color, Color.BLACK)
	
	var os_theme_path := plugin_path_dark if DisplayServer.is_dark_mode() else plugin_path_light
	var plugin_new_theme = settings.get_setting(os_theme_path)
	var plugin_current_theme = settings.get_setting(plugin_path_theme)
	var godot_current_theme = settings.get_setting(GODOT_PATH_PRESET)
	
	if plugin_new_theme != godot_current_theme and plugin_new_theme != plugin_current_theme:
		print("[Theme Switcher] Setting the theme to \"%s\"" % plugin_new_theme)
		settings.set_setting(GODOT_PATH_PRESET, plugin_new_theme)
	
	await get_tree().create_timer(5).timeout
	
	var addon_accent_color = settings.get_setting(plugin_path_color)
	var godot_accent_color = settings.get_setting(GODOT_PATH_ACCENT_COLOR)
	
	if addon_accent_color != Color.BLACK and addon_accent_color != godot_accent_color:
		print("[Theme Switcher] Setting the accent color to \"%s\"" % addon_accent_color)	
		settings.set_setting(plugin_path_theme, plugin_new_theme)
		settings.set_setting(GODOT_PATH_PRESET, "Custom")
		settings.set_setting(GODOT_PATH_ACCENT_COLOR, addon_accent_color)


func _exit_tree() -> void:
	remove_tool_menu_item(PLUGIN_NAME)


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
