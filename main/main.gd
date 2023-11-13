extends Node

@onready var main_menu = $canvas_layer/main_menu
@onready var address_entry = $canvas_layer/main_menu/margin/list/address_entry

@onready var mansion = $mansion

const FROG = preload("res://frog/frog.tscn")
const PORT = 2819
var enet_peer = ENetMultiplayerPeer.new()

func add_player(peer_id):
	var player = FROG.instantiate()
	player.name = str(peer_id)
	player.color = [Color.RED, Color.WHITE, Color.PURPLE, Color.DARK_ORANGE].pick_random()
	player.set_color.rpc()
	add_child(player)

func _on_host_pressed():
	main_menu.hide()
	
	enet_peer.create_server(PORT)
	multiplayer.multiplayer_peer = enet_peer
	multiplayer.peer_connected.connect(add_player)
	
	add_player(multiplayer.get_unique_id())
	mansion.start_game()

func _on_join_pressed():
	main_menu.hide()
	
	enet_peer.create_client("localhost", PORT)
	multiplayer.multiplayer_peer = enet_peer
	
	mansion.start_game()
