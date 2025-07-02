extends Label

func _process(delta: float) -> void:
	text = "总步数：" + str(Records.setps) + "\n" \
	+ "用时：" + str(Records.used_time)
	 
