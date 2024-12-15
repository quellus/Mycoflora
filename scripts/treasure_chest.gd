class_name TreasureChest extends Interactable

const SWORD_ICON_16_BIT = preload("res://assets/SwordIcon16Bit.png")
const HEART_SPRITE_SHEET = preload("res://assets/HeartSpriteSheet.png")

@export var type = ItemTypes.SWORD

func _ready():
	match type:
		ItemTypes.SWORD:
			$ItemSprite.texture = SWORD_ICON_16_BIT
		ItemTypes.HEALTH:
			var atlas_texture = AtlasTexture.new()
			atlas_texture.atlas = HEART_SPRITE_SHEET
			atlas_texture.region = Rect2(0,0,16,16)
			$ItemSprite.texture = atlas_texture
	
	$AnimationPlayer.play("RESET")

func interact():
	$AnimationPlayer.play("open chest")
