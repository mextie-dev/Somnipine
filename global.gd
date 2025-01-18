extends Node

var debug = false

var mouseSensitivity : float
var audioVolume : float

var hasTalkedToPapa := false
var thingsCollected := 0
var isInCutscene := false

var choseEnding := false

enum ENDING {
	GOOD,
	BAD,
	NEUTRAL
}

var chosenEnding

var rng = RandomNumberGenerator.new()

func _ready():
	DisplayServer.window_set_title("Somnipine") 
