extends Node2D

@onready var _MainWindow: Window = get_window()
@onready var _SubWindow: Window = $Window
@onready var camera_2d: Camera2D = $Window/Camera2D
@onready var player: PlayerController = $Player
#@onready var _Subwindow_2: Window = $Window2
#@onready var camera_2d_2: Camera2D = $Window2/SubViewport/Camera2D
@onready var _Subwindow_2: Window = $SubViewport/Window2
@onready var camera_2d_2: Camera2D = $SubViewport/Window2/Camera2D
@onready var _Subwindow_3: Window = $SubViewport2/Window2
@onready var start_button: Button = $CanvasLayer/StartButton


func _ready():
	var language = "zh"
	# Load here language from the user settings file
	if language == "zh":
		var preferred_language = OS.get_locale_language()
		TranslationServer.set_locale(preferred_language)
	else:
		TranslationServer.set_locale(language)
	# 启用像素级透明度，这对于透明窗口是必需的，但会降低性能
	# 在某些系统上也可能出现问题
	ProjectSettings.set_setting("display/window/per_pixel_transparency/allowed", true)
	
	_SubWindow.world_2d = _MainWindow.world_2d
	_Subwindow_2.world_2d = _MainWindow.world_2d
	_Subwindow_3.world_2d = _MainWindow.world_2d
	
	# 不能在项目设置中设置的设置
	_MainWindow.transparent_bg = true	# 使窗口背景透明

func _process(delta: float) -> void:
	_SubWindow.position = player.position + Vector2(_MainWindow.position) - Vector2(128, 128)
	camera_2d.position = player.position + Vector2(_SubWindow.size) / 2 - Vector2(128, 128)
	# 固定显现窗口2
	_Subwindow_2.position = Vector2(_MainWindow.position) + Vector2(96, 608)
	_Subwindow_3.position = Vector2(_MainWindow.position) - Vector2(160, 416)
	#camera_2d_2.position = Vector2(_MainWindow.position) + Vector2(64, 1024)


func _on_start_button_pressed() -> void:
	start_button.hide()
