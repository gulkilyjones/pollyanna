// == begin formencode.js

function formToText(formId) {
	var form = document.getElementById(formId);

	if (form) {
		var elements = form.elements;

		if (elements) {
			for (var i = 0; i < elements.length; i++) {
				if (elements[i].type == 'checkbox') {
					if (elements[i].checked) {
						//voteLines = voteLines + elements[i].name + '\n';
						if ( ! localStorage.getItem('vvvv') ) {
							localStorage.setItem('vvvv', elements[i].name);
						} else {
							localStorage.setItem('vvvv', localStorage.getItem('vvvv') + "\n" + elements[i].name);
						}
					}
				}
			}
		}
	}
}

if (document.getElementById) {
	var pau = document.getElementById('voteAsUser');
	if (pau) {
		pau.innerHTML = '<input type=button onclick="formToText(this.form.id); gotoInsVotes();" value="Add Signature"' + String.fromCharCode(62);
		//'((input type=button onclick="formToText(this.form.id)" value="Enqueue"))';
	}
}

// == end formencode.js