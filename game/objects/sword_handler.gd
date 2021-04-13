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

var vigor := 0.0
var last_pos : Vector2


func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)


func _input(event : InputEvent) -> void:
	if event is InputEventMouseMotion:
		adjust_sword(event.relative / 2.0)


func _process(delta : float) -> void:
	update_vigor(delta)


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


func update_vigor(delta : float) -> void:
	if last_pos:
		var distance : float = mouse_detector.get_global_mouse_position().distance_to(last_pos)
		vigor = distance
	
	last_pos = mouse_detector.get_global_mouse_position()


func _on_HitArea_area_entered(area : Area) -> void:
	if area is HitDetectArea:
		area.hit(vigor)
