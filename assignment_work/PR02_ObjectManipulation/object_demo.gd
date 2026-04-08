extends Node3D

@onready var target_object = $TargetObject
@onready var spawn_point = $SpawnPoint
@onready var ui_label = $CanvasLayer/UI/Label

var object_scene = preload("res://spawnable_object.tscn")
var spawned_objects = []

func _ready():
	update_ui()

func _input(event):
	if Input.is_action_just_pressed("hide_object"):
		hide_target_object()
	elif Input.is_action_just_pressed("show_object"):
		show_target_object()
	elif Input.is_action_just_pressed("create_object"):
		create_new_object()
	elif Input.is_action_just_pressed("destroy_object"):
		destroy_last_object()

func hide_target_object():
	if target_object.visible:
		target_object.hide()
		print("Hidden target object")
		update_ui()

func show_target_object():
	if not target_object.visible:
		target_object.show()
		print("Shown target object")
		update_ui()

func create_new_object():
	var new_object = object_scene.instantiate()
	spawn_point.add_child(new_object)
	spawned_objects.append(new_object)
	print("Created new object at spawn point")
	update_ui()

func destroy_last_object():
	if spawned_objects.size() > 0:
		var object_to_destroy = spawned_objects[-1]
		spawned_objects.erase(object_to_destroy)
		object_to_destroy.queue_free()
		print("Destroyed last created object")
		update_ui()

func update_ui():
	var status_text = "PR02 Object Manipulation Demo\n\n"
	status_text += "Controls:\n"
	status_text += "H - Hide target object\n"
	status_text += "S - Show target object\n"
	status_text += "C - Create new object\n"
	status_text += "D - Destroy last object\n\n"
	status_text += "Status:\n"
	status_text += "Target Object: " + ("Visible" if target_object.visible else "Hidden") + "\n"
	status_text += "Spawned Objects: " + str(spawned_objects.size())
	
	ui_label.text = status_text
