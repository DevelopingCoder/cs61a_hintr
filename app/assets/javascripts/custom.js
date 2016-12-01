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

lastChecked = null
$(document).ready(function(){
    $(".shift_click_checkbox").click(function(e){
        if(!lastChecked) {
            lastChecked = this;
            return;
        }

        if(e.shiftKey) {
            var start = $(".shift_click_checkbox").index(this);
            var end = $(".shift_click_checkbox").index(lastChecked);

            for (var index = Math.min(start, end); index < Math.max(start, end) + 1; index++){
                // Make sure the field is enabled if you change it
                var id = $(".shift_click_checkbox")[index].id
                var field = $("#" + id);
                var disabled = $("#" + id).is(':disabled');
                field.prop('checked', lastChecked.checked && !disabled);
            }
            
        }

        lastChecked = this;
    })
});
    