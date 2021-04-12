extends Spatial


const X_MIN := -3.0
const X_MAX := 3.0
const Y_MIN := -3.0
const Y_MAX := 3.0
const SWORD_HEIGHT := 0.76
const SWORD_WIDTH := 0.05

onready var mouse_detector := $MouseDetector
onready var gimbal_x := $GimbalX
onready var gimbal_z := $GimbalX/GimbalZ
onready var tween := $Tween


func _input(event : InputEvent) -> void:
	if event is InputEventMouseMotion:
		adjust_sword(event.relative / 2.0)


func adjust_sword(swing_amount : Vector2) -> void:
	var target_pos := Vector3(
		mouse_detector.get_global_mouse_position().x / OS.window_size.x,
		mouse_detector.get_global_mouse_position().y / OS.window_size.y,
		0
	)
	
	target_pos = Vector3(
		X_MIN + (abs(X_MIN) + X_MAX) * target_pos.x,
		-(Y_MIN + (abs(Y_MIN) + Y_MAX) * target_pos.y) + (SWORD_HEIGHT * target_pos.y),
		0
	)
	
	gimbal_x.translation = target_pos
	
	tween.interpolate_property(gimbal_z, "rotation_degrees:z", gimbal_z.rotation_degrees.x + swing_amount.x, 0, 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN)
	tween.interpolate_property(gimbal_x, "rotation_degrees:x", max(-90, gimbal_x.rotation_degrees.x + abs(swing_amount.x) * -0.5), 0, 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN)
	tween.start()
