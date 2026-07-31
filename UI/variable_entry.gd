extends LineEdit

@export var rule: String = "";
signal variable_updated(new_value);
signal error_updated(text);

func validate() -> bool:
	var expression = Expression.new();
	var error = expression.parse(rule, ["value"])
	if error != OK:
		push_error(expression.get_error_text())
		push_error("Rule failed to parse");
		return false
	var result = expression.execute([text])
	if not expression.has_execute_failed():
		return result;
	else:
		push_error("Rule failed to execute");
		return false;

func on_update():
	var result = validate();
	error_updated.emit(not result);
	if result:
		variable_updated.emit(text);


func _on_panel_set_entry(value: Variant) -> void:
	text = value;
