extends Node2D

var _logged_in = false
var _high_score_inst = preload("res://scenes/high_score.tscn")

func _ready():
	Firebase.Auth.connect("signup_succeeded", self, "_sign_in_success")
	Firebase.Auth.connect("login_failed", self, "_sign_in_error")
	Firebase.Auth.login_anonymous()
	
func _sign_in_success(auth_info):
	_logged_in = true
	
	var _db = Firebase.Database.get_database_reference("scores", {})
	Firebase.Firestore.connect("result_query", self, "_query_success")
	Firebase.Firestore.query(FirestoreQuery.new())

func _query_success(results):
	for result in results:
		var _score_inst = _high_score_inst.instance()
		_score_inst._set_vals(result.doc_fields.initials, String(result.doc_fields.value))
		$ui/margin/vertical/scroll/container.add_child(_score_inst)
		
func _sign_in_error(err, desc):
	pass
