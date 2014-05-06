//// ==================================================== //
////                 Pedidos AJAX                         //
//// ==================================================== //
var ready;
ready = function() {

  function refresh_header(){
    $.ajax({
      url: "http://localhost:3000/refresh_header",
      type: "GET",
      async: true,
      success: function(result){
        $("#value_balance").html(result);
      },
      error: function(){
        console.log('Error occured');
      }
    });
    return false;
  }

  setInterval(refresh_header, 1000);
};

//em rails 4 so funciona assim
// por causa do turboLink
$(document).ready(ready);
$(document).on('page:load', ready);
