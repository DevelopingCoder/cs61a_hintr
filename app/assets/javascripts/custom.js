function toggle_admin(id){
    var data = {
        field: "admin",
        value: event.target.checked
    }
    $.ajax({
        url: '/display_users/' + id,
        type: 'POST',
        dataType: "application/json",
        data: JSON.stringify(data),
        error: function(response){
            console.log(response)
            alertify.message(response.responseText)
        }
    });
}