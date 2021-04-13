tool
extends Area
class_name HitDetectArea


export var x_scale := 1.0
export var y_scale := 1.0
export var z_scale := 1.0
export var target : NodePath
export var function : String
export var static_args : Array

onready var shape := $CollisionShape


func _ready() -> void:
	shape.shape.extents = Vector3(
			x_scale,
			y_scale,
			z_scale
		)


func _process(_delta : float) -> void:
	if Engine.editor_hint:
		shape.shape.extents = Vector3(
			x_scale,
			y_scale,
			z_scale
		)


func hit(vigor : float) -> void:
	if target and function:
		get_node(target).callv(function, [vigor] + static_args)
