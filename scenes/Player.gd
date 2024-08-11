extends CharacterBody2D

@export var playerIdx = 0
@export var playerName = "Player"
@export var playerColor = Color(1,1,1,1)

@export var controls : ControlsResource

@export var WALK_SPEED = 300.0
@export var SPRINT_SPEED_MODIFIER := 1.3
@export var AIM_SPEED_MODIFIER := 0.5
@export var MAX_HEALTH := 100.0
var health = MAX_HEALTH

var sprinting = false

var interactables = []

func _ready() -> void:
	Overlord.registerPlayerScene(playerIdx, self);
	updatePlayerBasedOnVariables()

func updatePlayerBasedOnVariables() -> void:
	%NameLabel.text = playerName
	%NameLabel.modulate = playerColor
	$Sprite2D.material.set_shader_parameter("new_color", playerColor)
	$WeaponsHolder/Weapon.playerIdx = playerIdx
	$WeaponsHolder/Weapon.playerNode = self
	$WeaponsHolder/Weapon.controls = controls

func _process(delta: float) -> void:
	if Input.is_action_just_pressed(controls.interact):
		var interactable = closest_interactable()
		if interactable != null:
			interactable.interact(playerIdx)

func _physics_process(delta: float) -> void:
	var current_speed = WALK_SPEED
	
	if Input.is_action_just_pressed(controls.sprint):
		sprinting = true

	if sprinting:
		current_speed = WALK_SPEED * SPRINT_SPEED_MODIFIER

	# If player is aiming in, slow them down
	if Input.is_action_pressed(controls.secondary_fire):
		current_speed = WALK_SPEED * AIM_SPEED_MODIFIER
	
	### MOVEMENT AND AIMING DIRECTION
	
	# `velocity` will be a Vector2 between `Vector2(-1.0, -1.0)` and `Vector2(1.0, 1.0)`.
	# This handles deadzone in a correct way for most use cases.
	# The resulting deadzone will have a circular shape as it generally should.
	var toVelocity = Input.get_vector(controls.move_left, controls.move_right, controls.move_up, controls.move_down) * current_speed
	if toVelocity != Vector2.ZERO:
		velocity = toVelocity
	else:
		sprinting = false
		velocity.x = move_toward(toVelocity.x, 0, current_speed)
		velocity.y = move_toward(toVelocity.y, 0, current_speed)
	
	var lookDirection = Input.get_vector(controls.look_left, controls.look_right, controls.look_up, controls.look_down)
	if lookDirection != Vector2.ZERO:
		rotation = lookDirection.angle() + PI/2 # only change the direction of player when input
	else:
		if velocity != Vector2.ZERO: # only change direction if there is movement input (so that it stays)
			rotation = velocity.angle() + PI/2
		
	# when player not aiming turn player to face movement vector
	# when player aiming, turn player to face look vector or do not turn player 

	# apply velocity
	move_and_slide()

func take_damage(damage: float) -> void:
	health -= damage
	if health <= 0:
		print(playerName + " died")
		queue_free()

func closest_interactable():
	if interactables.size() > 0:
		var closest = interactables[0]
		var dist = 999
		for interactable in interactables:
			var distance = global_position.distance_to(interactable.global_position)
			if distance < dist:
				closest = interactable
				dist = distance
		# TODO change to return closest interactable
		return closest
	else:
		# no interactables
		return null

func _on_interact_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("interactable"):
		interactables.append(body)
		if(body.has_method("showInteractability")):
			body.showInteractability(playerIdx)

func _on_interact_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("interactable"):
		var i = interactables.find(body)
		if i >= 0:
			interactables.remove_at(i)
			if(body.has_method("hideInteractability")):
				body.hideInteractability(playerIdx)
