
class_name Save_Data
extends Node

var _level: int
var _exp: int
var _exp_next: int
var _challenge_level: int

func _init(level = 1, expe = 0, exp_next = 100, challenge_level = 1):
	self._level = level
	self._exp = expe
	self._exp_next = exp_next
	self._challenge_level = challenge_level

func _to_string():
	return "Level: " + String(_level) + " | " + "EXP: " + String(_exp) + " | " + " NEXT: " + String(_exp_next) + " | " + "CURRENT: " + String(_challenge_level)
