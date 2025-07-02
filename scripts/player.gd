extends CharacterBody2D
class_name PlayerController

# 移动参数
const GRID_SIZE = 64  # 网格大小
var moving = false
var input_direction = Vector2.ZERO

@export var tilemap: TileMapLayer
@export var game_manager: Node  # 在编辑器中拖拽GameManager节点到这里

func snap_to_grid():
	var near: Vector2 = position - Vector2.ONE * GRID_SIZE / 2
	position = near.snapped(Vector2.ONE * GRID_SIZE) + Vector2.ONE * GRID_SIZE / 2

func _unhandled_input(event):
	if moving: return
	# 检测方向键输入
	if event.is_action_pressed("move_right"): 
		try_move(Vector2.RIGHT)
		Records.increment_steps()
	if event.is_action_pressed("move_left"):
		try_move(Vector2.LEFT)
		Records.increment_steps()
	if event.is_action_pressed("move_down"):
		try_move(Vector2.DOWN)
		Records.increment_steps()
	if event.is_action_pressed("move_up"):
		try_move(Vector2.UP)
		Records.increment_steps()
	

func try_move(dir: Vector2):
	var target_pos = position + dir * GRID_SIZE
	
	
	if not tilemap:
		printerr("tilemaplayer不存在；player未登记tilemaplayer")
		return
	if !tilemap.has_method("is_wall"):
		printerr("tilemaplayer不存在方法is_wall。player必要调用")
		return
	
	# 检测前方是否有墙
	if tilemap.is_wall(target_pos): 
		return
	
	# 检测前方是否有箱子
	for box in get_parent().get_node("Boxes").get_children():
		if box.position == target_pos:
			if !box.try_push(dir):  # 尝试推动箱子
				return
	
	# 移动玩家
	moving = true
	position = target_pos
	moving = false
	
	# 通知游戏管理器保存状态
	if game_manager:
		game_manager.save_current_state()
		
#extends CharacterBody2D
#class_name PlayerController
#
## 移动参数
#const GRID_SIZE = 64
#var moving = false
#var input_direction = Vector2.ZERO
#
#@export var tilemap: TileMapLayer
#@export var game_manager: Node
#
## 窗口管理相关变量
#var windows: Array = []  # 存储所有窗口
#var main_window: Window  # 主游戏窗口
#var window_scene = preload("res://scenes/window_template.tscn")
#
#func _ready():
	## 获取主窗口
	#main_window = get_tree().root
	#windows.append(main_window)
	#
	## 设置主窗口属性
	#main_window.title = "主窗口"
	#main_window.position = Vector2i(100, 100)
	#
	## 添加窗口边界检测
	#var notifier = VisibleOnScreenNotifier2D.new()
	#notifier.rect = Rect2(-GRID_SIZE/2, -GRID_SIZE/2, GRID_SIZE, GRID_SIZE)
	#add_child(notifier)
	#notifier.screen_exited.connect(_on_screen_exited)
#
#func snap_to_grid():
	#var near: Vector2 = position - Vector2.ONE * GRID_SIZE / 2
	#position = near.snapped(Vector2.ONE * GRID_SIZE) + Vector2.ONE * GRID_SIZE / 2
#
#func _unhandled_input(event):
	#if moving: return
	#if event.is_action_pressed("move_right"): try_move(Vector2.RIGHT)
	#if event.is_action_pressed("move_left"): try_move(Vector2.LEFT)
	#if event.is_action_pressed("move_down"): try_move(Vector2.DOWN)
	#if event.is_action_pressed("move_up"): try_move(Vector2.UP)
#
#func try_move(dir: Vector2):
	#var target_pos = position + dir * GRID_SIZE
	#
	#if not tilemap:
		#printerr("tilemaplayer不存在；player未登记tilemaplayer")
		#return
	#if !tilemap.has_method("is_wall"):
		#printerr("tilemaplayer不存在方法is_wall。player必要调用")
		#return
	#
	#if tilemap.is_wall(target_pos): 
		#return
	#
	#for box in get_parent().get_node("Boxes").get_children():
		#if box.position == target_pos:
			#if !box.try_push(dir):
				#return
	#
	#moving = true
	#position = target_pos
	#moving = false
	#
	## 更新所有窗口位置
	#update_window_positions()
	#
	#if game_manager:
		#game_manager.save_current_state()
#
## 更新所有窗口位置
#func update_window_positions():
	#for window in windows:
		#if is_instance_valid(window):
			## 计算窗口位置偏移（角色在窗口中心）
			#var window_pos = global_position - Vector2(window.size) / 2
			#window.position = Vector2i(window_pos)
			#
			## 更新窗口内摄像机位置
			#if window.has_node("WindowCamera"):
				#window.get_node("WindowCamera").global_position = global_position
#
## 当角色离开窗口时创建新窗口
#func _on_screen_exited():
	#create_new_window()
#
## 创建新窗口
#func create_new_window():
	#var new_window = window_scene.instantiate()
	#
	## 设置窗口属性
	#new_window.title = "玩家窗口 %d" % windows.size()
	#new_window.size = Vector2i(640, 360)
	#new_window.position = Vector2i(global_position - Vector2(320, 180))
	#new_window.window_close_requested.connect(func(): 
		#windows.erase(new_window)
		#new_window.queue_free()
	#)
	#
	## 添加摄像机
	#var camera = Camera2D.new()
	#camera.name = "WindowCamera"
	#camera.zoom = Vector2(0.7, 0.7)
	#camera.enabled = true
	#camera.global_position = global_position
	#camera.make_current()
	#new_window.add_child(camera)
	#
	## 添加窗口到场景树
	#get_tree().root.add_child(new_window)
	#windows.append(new_window)
	#
	## 更新所有窗口位置
	#update_window_positions()
