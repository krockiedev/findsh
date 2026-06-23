extends Control

@onready var background: TextureRect = $Background
@onready var sub_indicator: TextureRect = $Background/Submarine

# Define your padding offsets in pixels so the icon stays inside the bar graphics
const TOP_OFFSET_PIXELS: float = 20.0    # Change this! How far down from the top it starts
const BOTTOM_OFFSET_PIXELS: float = 50.0 # Change this! How far up from the bottom it stops

# This must match the total maximum distance your submarine can drop (90 + 90 = 180)
const MAX_3D_DEPTH: float = 180.0

func update_depth_meter(current_3d_y: float) -> void:
	# 1. Dynamically read the height of your background vertical bar
	var total_bar_height = background.size.y
	
	# 2. Calculate the track length after subtracting your top and bottom dead-zones
	var usable_track_length = total_bar_height - TOP_OFFSET_PIXELS - BOTTOM_OFFSET_PIXELS
	
	# 3. Turn the negative 3D depth into a positive absolute progress value
	var absolute_depth = abs(current_3d_y)
	
	# 4. Get a clean percentage ratio (0.0 at surface, 0.5 at mid, 1.0 at bottom)
	var depth_ratio = absolute_depth / MAX_3D_DEPTH
	depth_ratio = clamp(depth_ratio, 0.0, 1.0) # Prevent accidental overshooting bugs
	
	# 5. Multiply the ratio by the usable track, and add the top padding offset back in
	var target_ui_y = TOP_OFFSET_PIXELS + (depth_ratio * usable_track_length)
	
	# 6. Apply it directly to the indicator's vertical position
	sub_indicator.position.y = target_ui_y
