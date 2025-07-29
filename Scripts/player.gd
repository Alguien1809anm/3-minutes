extends CharacterBody2D

@export var speed: float = 150.0
@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D
var current_interaction: Callable = Callable()

func move_to(target_position: Vector2, interaction_callback: Callable = Callable()) -> void:
	current_interaction = interaction_callback
	var map = nav_agent.get_navigation_map()
	var closest_point = NavigationServer2D.map_get_closest_point(map, target_position)
	nav_agent.target_position = closest_point



func _physics_process(delta: float) -> void:
	if not nav_agent.is_navigation_finished():
		var direction = (nav_agent.get_next_path_position() - global_position).normalized()
		velocity = direction * speed
		move_and_slide()
	else:
		if current_interaction.is_valid():
			current_interaction.call()
			current_interaction = Callable()  # Reset after calling
		velocity = Vector2.ZERO
