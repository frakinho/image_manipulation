function teste() {
	alert("Paulo LIma");
}

function take_snapshot() {
	var data_uri = Webcam.snap();
	document.getElementById('my_result').innerHTML = '<img src="'+data_uri+'"/>';

	Webcam.upload( data_uri, "/processing_upload", function(code, text) {

	} );
}