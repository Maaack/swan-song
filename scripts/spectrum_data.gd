class_name SpectrumData
extends RefCounted

var re : float
var im : float
var freq : float
var amp : float
var phase : float

func _init(init_re, init_im, init_freq, init_amp, init_phase):
	re = init_re
	im = init_im
	freq = init_freq
	amp = init_amp
	phase = init_phase
