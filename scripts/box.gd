extends CharacterBody2D
class_name Box

signal box_moved(new_position)

const GRID_SIZE = 64  # 网格大小
@export var tilemap: TileMapLayer

func snap_to_grid():
	var near: Vector2 = position - Vector2.ONE * GRID_SIZE / 2
	position = near.snapped(Vector2.ONE * GRID_SIZE) + Vector2.ONE * GRID_SIZE / 2

func try_push(dir: Vector2) -> bool:
	var target_pos = position + dir * GRID_SIZE
	
	# 检测目标位置是否aadawdasd可推动
	if tilemap.is_wall(target_pos): 
		return false
	
	# 检测是否有其他箱子
	for other_box in get_parent().get_children():
		if other_box != self and other_box.position == target_pos:
			return false  # 被其他箱子挡住
	
	# 推动箱子
	position = target_pos
	emit_signal("box_moved", position)  # 通知游戏管理器
	return true
