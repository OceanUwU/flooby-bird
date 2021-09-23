#extends CanvasLayer
#
#
#const FLASH_DURATION = 0.3
#const FLASH_ALPHA = 120
#
#func flash():
#    $White.modulate.a = FLASH_ALPHA
#
#func _process(delta):
#    print(clamp($White.modulate.a - (FLASH_ALPHA * (delta / FLASH_DURATION)), 0, FLASH_ALPHA))
#    $White.modulate.a = clamp($White.modulate.a - (FLASH_ALPHA * (delta / FLASH_DURATION)), 0, FLASH_ALPHA)
