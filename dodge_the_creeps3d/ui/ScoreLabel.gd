extends Label

var score = 0

func _on_Mob_squashed():
	text = "Score: " + str(GameManager.score)
	$"../Retry/FinalScoreLabel".text = self.text
