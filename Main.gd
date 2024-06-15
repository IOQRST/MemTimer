extends Control

const SQLite3 = preload("res://addons/godot-sqlite/gdsqlite.gdextension")
var db
var db_name = "res://data/memory" 

var msc = 0
var sec = 0
var mins = 0
var hrs = 0

var time = Time.get_date_string_from_system()

func _ready():
	db = SQLite.new()
	db.path = db_name
	readFromDB()

func readFromDB():
	db.open_db()
	db.query("SELECT * FROM data_set;")
	for i in range(0, db.query_result.size()):
		$RichTextLabel.add_text("" + db.query_result[i]["DATE_STAMP"] + " " + db.query_result[i]["TIME_STAMP"] + "\n")

func commitDataToDB():
	db.open_db()
	var tableName = "data_set"
	var dict : Dictionary = Dictionary()
	dict["DATE_STAMP"] = time
	dict["TIME_STAMP"] = "{h}:{m}:{s}:{ms}".format({"h":hrs, "m":mins, "s":sec, "ms":msc})
	db.insert_row(tableName, dict)

func _on_quit_pressed():
	get_tree().quit()

func _on_start_pressed():
	$Start/Label/Timer.start()

func _on_timer_timeout():
	msc += 1
	if msc > 9:
		sec += 1
		msc = 0
		
	if sec > 59:
		mins += 1
		sec = 0
		
	if mins > 59:
		hrs += 1
		mins = 0
	$Start/Label.text = str(hrs)+":"+str(mins)+":"+str(sec)+":"+str(msc)

func _on_stop_pressed():
	$Start/Label/Timer.stop()
	msc = 0
	sec = 0
	mins = 0
	hrs = 0
	$Start/Label.text = str(hrs)+":"+str(mins)+":"+str(sec)+":"+str(msc)


func _on_pause_pressed():
	$Start/Label/Timer.stop()

func _on_save_pressed():
	commitDataToDB()
	$RichTextLabel.clear()
	readFromDB()


func _on_clear_pressed():
	db.open_db()
	var tableName = "data_set"
	db.delete_rows(tableName, "*")
	$RichTextLabel.clear()
	readFromDB()
