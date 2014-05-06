window.onload=function(){
	var iDiv = document.createElement('div');
	iDiv.id = 'my_camera';
	iDiv.className = 'my_camera';

	

};



//Change photo why new book is select from combobox
function select_book_event() {
	var book_id = document.getElementById('book_book_id').value


	$.ajax({
      url: "get_url_image/?book_id=" + book_id,
      type: "GET",
      async: true,
      dataType: "json",
      success: function(result){
      	document.getElementById("image_select_box").src = result.image
      },
      error: function(){
        console.log('Error occured');
      }
    });
}

//Take a snapashot and redirect two edit lending page with ajax request

function take_snapshot() {
	var data_uri = Webcam.snap();
	//document.getElementById('my_result').innerHTML = '<img src="'+data_uri+'"/>';

	var book_id = document.getElementById('book_book_id').value;
	//var weight  = document.getElementById('read_value').innerHTML;
	var weight = 10;
	alert("Peso: " + weight + " Book_id: " + book_id);

	Webcam.upload( data_uri, "https://localhost:3001/lendings/init_lending",book_id,weight, function(code, text) {
		//
		if(code == 200) {
			var json_image_object = JSON.parse(text);

			window.location.href = "https://localhost:3001/lendings/"+json_image_object.id+"/edit";
		} else {
			alert("Erro no UPLOAD da imagem");
		}
		
	} );
}