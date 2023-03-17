extends CharacterBody2D


const SPEED = 50.0
const JUMP_VELOCITY = -400.0

@export var direction = -1.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var animated_sprite = $AnimatedSprite2D

		
func _physics_process(delta):
	if(velocity.x > 0):
		animated_sprite.set_flip_h(true)
	elif(velocity.x < 0):
		animated_sprite.set_flip_h(false)
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		
	velocity.x = direction * SPEED
	
	if is_on_wall():
		for count in 5:
			if count == 4:
				
				direction *= -1 
				velocity.x = SPEED * direction

	move_and_slide()
