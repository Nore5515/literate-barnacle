extends Node

class_name Unit

#Properties
export (String) var ID
export (String) var type
export (int) var currentMove
export (int) var maxMove
export (int) var currentHP
export (int) var maxHP
var special = []

# Override Virtual Methods
#func _ready():
	#randomizeID()

# Add New Methods



### GENERATION
# PRE: None
# POST: ID is a randomized string, starting with an identifier for type
func randomizeID():
	randomize()
	if type == "Inf":
		ID = "i"
	elif type == "Flier":
		ID = "f"
	else:
		assert(false, "WRONG TYPE")
	ID += String(round(rand_range(0,1000000)))

# PRE: Ref has a move, hp, special and type field.
# POST: Unit has copied the ref's move, hp, special and type fields 
#(and replaced max's where appropriate)
func genFromRef(ref):
	currentMove = ref.move
	maxMove = ref.move
	currentHP = ref.hp
	maxHP = ref.hp
	special = ref.special
	type = ref.type

# PRE: None.
# POST: Unit has 0 for all stats, and "empty" for type
func genEmpty():
	currentMove = 0
	maxMove = 0
	currentHP = 0
	maxHP = 0
	special = []
	type = "empty"

