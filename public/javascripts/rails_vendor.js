function toggle_code_div(link) {
	var code_div = link.next('.ruby');
	code_div.toggle();
	link.next('.file_name').toggle();
	link.innerHTML = (code_div.visible() ? 'Hide Code' : 'Show Code');
}
