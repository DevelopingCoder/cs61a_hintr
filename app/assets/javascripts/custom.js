function toggle_admin(id){
    var data = {
        field: "admin",
        value: event.target.checked
    }
    $.ajax({
        url: '/display_users/' + id,
        type: 'PUT',
        dataType: "application/json",
        data: JSON.stringify(data),
        error: function(response){
            console.log(response)
            alertify.message(response.responseText)
        }
    });
}

function verify_delete(){
    alertify.confirm("Are you sure you want to delete? There is no undo because that's a lot of work.",
    function(){
        $("#delete_user_form").submit()
    },
    function(){
    });
}