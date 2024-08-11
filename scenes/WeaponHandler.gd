extends Node2D

@export var controls : ControlsResource = null
@export var currentWeapon : WeaponResource = preload("res://resources/weapons/MP5.tres")
@export var playerNode : CharacterBody2D = null
@export var playerIdx : int = 0
var current_ammo = currentWeapon.magazineSize

var bulletScene = preload("res://scenes/bullet.tscn")
@onready var muzzle = $Muzzle

## State variables
var reloading = false
var canFireFromFireRate = true
var aiming = false

func reload():
	if !reloading and current_ammo != currentWeapon.magazineSize:
		reloading = true
		SignalBus.emit_signal("changeAmmo", playerIdx, current_ammo, currentWeapon.magazineSize, reloading)
		$ReloadTimer.start()
		$ReloadAudio2D.play()
		#anim.play("reload")

func _on_reload_timer_timeout() -> void:
	current_ammo = currentWeapon.magazineSize
	reloading = false
	SignalBus.emit_signal("changeAmmo", playerIdx, current_ammo, currentWeapon.magazineSize, reloading)

func shoot():
	if reloading:
		return
	if current_ammo > 0:
		#add_trauma(0.6)
		var b : Node2D = bulletScene.instantiate()
		playerNode.owner.add_child(b)
		b.transform = muzzle.global_transform
		if aiming:
			b.rotation_degrees += randf_range(-currentWeapon.aimingSpreadAngle, currentWeapon.aimingSpreadAngle)
		else:
			b.rotation_degrees += randf_range(-currentWeapon.aimingSpreadAngle * currentWeapon.nonAimingInaccuracyMultipler, currentWeapon.aimingSpreadAngle * currentWeapon.nonAimingInaccuracyMultipler)
		b.fromPlayerIndex = playerIdx
		$PistolShootAudio2D.pitch_scale = randf_range(0.98, 1.02)
		$PistolShootAudio2D.play()
		$Muzzle/MuzzleFlashSprite2D.showFlash()
		current_ammo -= 1
		SignalBus.emit_signal("changeAmmo", playerIdx, current_ammo, currentWeapon.magazineSize, reloading)
		canFireFromFireRate = false
		$FirerateTimer.start()
	else:
		reload()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	updateStatsBasedOnWeaponResource()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if currentWeapon.fireType == WeaponResource.FireType.semiAuto:
		if Input.is_action_just_pressed(controls.primary_fire):
			shoot()
	if currentWeapon.fireType == WeaponResource.FireType.fullAuto:
		if Input.is_action_pressed(controls.primary_fire):
			if canFireFromFireRate:
				shoot()

	if Input.is_action_just_pressed(controls.secondary_fire):
		$GunAimInAudio2D.play()
	if Input.is_action_just_released(controls.secondary_fire):
		$GunAimOutAudio2D.play()

func _physics_process(delta: float) -> void:
	
	# update aim lines
	if Input.is_action_pressed(controls.secondary_fire):
		aiming = true
		$AimPivotLeft/AimLineLeftRayCast2D.enabled = true
		$AimPivotLeft/AimLineLeftRayCast2D.force_raycast_update()
		if $AimPivotLeft/AimLineLeftRayCast2D.is_colliding():
			var collision_point_left = $AimPivotLeft/AimLineLeftRayCast2D.get_collision_point()
			var distance_left = collision_point_left.distance_to(global_position)
			#$AimPivotLeft/ColorRect.position.y = -distance_left * .9
			$AimPivotLeft/ColorRect.size.y = distance_left - 30
		else:
			#$AimPivotLeft/ColorRect.position.y = $AimPivotLeft/AimLineLeftRayCast2D.target_position.y * .9
			$AimPivotLeft/ColorRect.size.y = -$AimPivotLeft/AimLineLeftRayCast2D.target_position.y - 30
		
		$AimPivotRight/AimLineRightRayCast2D.enabled = true
		$AimPivotRight/AimLineRightRayCast2D.force_raycast_update()
		if $AimPivotRight/AimLineRightRayCast2D.is_colliding():
			var collision_point_right = $AimPivotRight/AimLineRightRayCast2D.get_collision_point()
			var distance_right = collision_point_right.distance_to(global_position)
			#$AimPivotRight/ColorRect.position.y = -distance_right * .9
			$AimPivotRight/ColorRect.size.y = distance_right - 30
		else:
			#$AimPivotRight/ColorRect.position.y = $AimPivotRight/AimLineRightRayCast2D.target_position.y * .9
			$AimPivotRight/ColorRect.size.y = -$AimPivotRight/AimLineRightRayCast2D.target_position.y - 30
			
		# make them visible
		$AimPivotLeft/ColorRect.modulate.a = .2
		$AimPivotRight/ColorRect.modulate.a = .2
	else:
		aiming = false
		# hide lines
		$AimPivotLeft/AimLineLeftRayCast2D.enabled = false
		$AimPivotRight/AimLineRightRayCast2D.enabled = false
		$AimPivotLeft/ColorRect.modulate.a = 0
		$AimPivotRight/ColorRect.modulate.a = 0

func updateStatsBasedOnWeaponResource() -> void:
	current_ammo = currentWeapon.magazineSize
	$ReloadTimer.wait_time = currentWeapon.reloadTimeSeconds
	$FirerateTimer.wait_time = 60.0 / float(currentWeapon.fireRateRPM)
	$AimPivotLeft.rotation_degrees = -currentWeapon.aimingSpreadAngle
	$AimPivotRight.rotation_degrees = currentWeapon.aimingSpreadAngle
	## ex 600 rounds per minute = 600 rounds per 60 seconds = 6 rounds per second


func _on_firerate_timer_timeout() -> void:
	canFireFromFireRate = true
