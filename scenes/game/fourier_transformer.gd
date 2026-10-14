extends Node

@export var time_series : Array[float]

func _ready():
	var result = FourierTransform.dft(time_series)
	print(result.size())
