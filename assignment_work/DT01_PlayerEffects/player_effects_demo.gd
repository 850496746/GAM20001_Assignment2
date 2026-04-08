extends CharacterBody3D

@onready var ui_label = $CanvasLayer/UI/Label

# Base player properties
var base_speed = 5.0
var base_jump_velocity = 4.5
var base_cooldown = 1.0

# Current player properties (can be modified)
var current_speed = base_speed
var current_jump_velocity = base_jump_velocity
var current_cooldown = base_cooldown

# Cooldown tracking
var can_use_ability = true
var cooldown_timer = 0.0

# Get the gravity from the project settings so you can sync with rigid body nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	update_ui()

func _physics_process(delta):
	# Handle cooldown
	if not can_use_ability:
		cooldown_timer -= delta
		if cooldown_timer <= 0:
			can_use_ability = true
			cooldown_timer = 0.0
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = current_jump_velocity
		print("Jumped with velocity: ", current_jump_velocity)

	# Get input direction for movement.
	var input_dir = Input.get_vector("move_left", "move_right", "ui_up", "ui_down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction:
		velocity.x = direction.x * current_speed
		velocity.z = direction.z * current_speed
	else:
		velocity.x = move_toward(velocity.x, 0, current_speed)
		velocity.z = move_toward(velocity.z, 0, current_speed)

	move_and_slide()

func _input(event):
	if Input.is_action_just_pressed("slow_movement"):
		apply_slow_movement()
	elif Input.is_action_just_pressed("double_jump"):
		apply_double_jump()
	elif Input.is_action_just_pressed("half_jump"):
		apply_half_jump()
	elif Input.is_action_just_pressed("reset_effects"):
		reset_effects()

func apply_slow_movement():
	if can_use_ability:
		current_speed = base_speed * 0.5  # Slow movement
		start_cooldown()
		print("Applied slow movement effect")

func apply_double_jump():
	if can_use_ability:
		current_jump_velocity = base_jump_velocity * 2.0  # Double jump height
		start_cooldown()
		print("Applied double jump effect")

func apply_half_jump():
	if can_use_ability:
		current_jump_velocity = base_jump_velocity * 0.5  # Half jump height
		start_cooldown()
		print("Applied half jump effect")

func reset_effects():
	current_speed = base_speed
	current_jump_velocity = base_jump_velocity
	current_cooldown = base_cooldown
	print("Reset all effects to default")
	update_ui()

func start_cooldown():
	can_use_ability = false
	cooldown_timer = current_cooldown
	update_ui()

func update_ui():
	var status_text = "DT01 Player Effects Demo\n\n"
	status_text += "Controls:\n"
	status_text += "A/D - Move left/right\n"
	status_text += "SPACE - Jump\n"
	status_text += "1 - Slow movement (50% speed)\n"
	status_text += "2 - Double jump height\n"
	status_text += "3 - Half jump height\n"
	status_text += "R - Reset all effects\n\n"
	status_text += "Current Effects:\n"
	status_text += "Speed: " + str(current_speed) + " (" + str(snapped(current_speed/base_speed * 100, 1)) + "%)\n"
	status_text += "Jump: " + str(current_jump_velocity) + " (" + str(snapped(current_jump_velocity/base_jump_velocity * 100, 1)) + "%)\n"
	status_text += "Cooldown: " + str(current_cooldown) + "s\n"
	status_text += "Ability Ready: " + ("Yes" if can_use_ability else "No (" + str(snapped(cooldown_timer, 1)) + "s)")
	
	ui_label.text = status_text
