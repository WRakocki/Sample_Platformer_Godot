extends CharacterBody2D

const SPEED = 50
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var player
var chase = false
@onready var anim = get_node("AnimatedSprite2D")

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if chase == true:
		if anim.animation != "death":
			anim.play("jump")
		player = get_node("../../Player/Player")
		var direction = (player.position - self.position).normalized()
	
		if direction.x > 0:
			get_node("AnimatedSprite2D").flip_h = true
		else:
			get_node("AnimatedSprite2D").flip_h = false
		
		velocity.x = direction.x * SPEED
	else:
		if anim.animation != "death":
			anim.play("idle")
		velocity.x = 0
	
	move_and_slide()
	
func _on_player_detection_body_entered(body):
	if body.name == "Player":
		chase = true
		


func _on_player_detection_body_exited(body):
	if body.name == "Player":
		chase = false


func _on_player_death_body_entered(body):
	if body.name == "Player":
		death()


func _on_player_collision_body_entered(body):
		if body.name == "Player":
			body.health -= 3
			death()
			
func death():
		chase = false
		anim.play("death")
		await anim.animation_finished
		self.queue_free()
