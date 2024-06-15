extends TextureProgressBar

@export var overheat_progress_texture: Texture2D
@export var normal_progress_texture: Texture2D

func set_overheat_mode(is_overheated: bool) -> void:
    texture_progress = overheat_progress_texture if is_overheated else normal_progress_texture
    $CoolingOffLabel.visible = is_overheated