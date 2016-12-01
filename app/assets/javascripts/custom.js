function toggle_admin(id) {
    var data = {
        field: "admin",
        value: event.target.checked
    }
    $.ajax({
        url: '/display_users/' + id,
        type: 'PUT',
        dataType: "application/json",
        data: data,
        error: function(response){
            console.log(response)
            alertify.message(response.responseText)
        }
    });
}

function verify_delete() {
    alertify.confirm("Are you sure you want to delete? There is no undo because that's a lot of work.",
    function(){
        $("#delete_user_form").submit()
    },
    function(){
    });
}

function upvote(message_id, concept_id) {
    var data = {
        field: "message_id",
        value: message_id
    }
    $.ajax({
        url: '/concepts/' + concept_id.to_s + '/messages/' + message_id.to_s + '/upvote',
        type: 'POST',
        dataType: "application/json",
        data: JSON.stringify(data)
    })
}

function downvote(message_id, concept_id) {
    var data = {
        field: "message_id",
        value: message_id
    }
    $.ajax({
        url: '/concepts/' + concept_id.to_s + '/messages' + message_id.to_s + '/downvote',
        type: 'POST',
        dataType: "application/json",
        data: JSON.stringify(data)
    })
}