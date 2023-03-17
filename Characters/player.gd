extends CharacterBody2D

@export var SPEED = 300.0
const JUMP_VELOCITY = -400.0

var knockback_velocity = Vector2(100,100)
var damaged = 0
var knockback = false

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var animated_sprite = $AnimatedSprite2D
@onready var damage_taken = $TookDamage

func _physics_process(delta):

	# Flip sprite based on direction
	if(velocity.x < 0):
		animated_sprite.set_flip_h(true)
	elif(velocity.x > 0):
		animated_sprite.set_flip_h(false)
		
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		#velocity.x += gravity * delta
		
	# Change animation based on jumping, standing still, or moving.
		if (velocity.y < 0 and damaged == 0):
			animated_sprite.animation = "jump"
		else: 
			animated_sprite.animation = "fall"
	else:
		if(velocity.x == 0):
			animated_sprite.animation = "idle"
		else:
			animated_sprite.animation = "run"

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction and knockback == false:
		velocity.x = direction * SPEED
	elif(knockback == false):
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

#Damage and Player Knockback
func _on_hurt_box_area_entered(area: Area2D)->void:
	knockback = true
	damage_taken.start()
	damaged = 1
	# If player is currently standing still knockback
	if velocity.x == 0:
		velocity = Vector2(100 * area.get_parent().direction, -100)
	# If player is moving knockback
	else:
		velocity = Vector2(100 * (velocity.x / (-1 * SPEED)), -100)
	animated_sprite.animation = "fall"
	print(area.get_parent().direction)

# Sets damaged and knockback back to their default positions to resume movement. 
func _on_took_damage_timeout():
	damaged = 0
	if is_on_floor:
		knockback = false
