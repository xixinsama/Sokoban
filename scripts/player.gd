extends CharacterBody2D
class_name PlayerController

# 移动参数
const GRID_SIZE = 64  # 网格大小
var moving = false
var input_direction = Vector2.ZERO

@export var tilemap: TileMapLayer
@export var game_manager: Node  # 在编辑器中拖拽GameManager节点到这里

func _ready():
	snap_to_grid()  # 初始对齐网格

func snap_to_grid():
	var near: Vector2 = position - Vector2.ONE * GRID_SIZE / 2
	position = near.snapped(Vector2.ONE * GRID_SIZE) + Vector2.ONE * GRID_SIZE / 2

func _unhandled_input(event):
	if moving: return
	# 检测方向键输入
	if event.is_action_pressed("move_right"): try_move(Vector2.RIGHT)
	if event.is_action_pressed("move_left"): try_move(Vector2.LEFT)
	if event.is_action_pressed("move_down"): try_move(Vector2.DOWN)
	if event.is_action_pressed("move_up"): try_move(Vector2.UP)

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
