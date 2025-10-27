extends Node

func _on_body_entered(body: Node) -> void:
	print("Hitbox: body entered=", body.name)


func _on_area_entered(area: Area2D) -> void:
	print("Hitbox: area entered=", area.name)