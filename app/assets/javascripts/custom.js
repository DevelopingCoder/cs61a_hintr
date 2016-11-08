var lastChecked = null;

$(document).ready(function(){
    // OnChange event for the admin checkbox that sends ajax call to give/revoke user admin privileges
    $(".admin_checkbox").change(function(){
        if (this.checked){
            var prompt = "Are you sure you want to give admin privileges to " + this.name.substring(15);
        } else {
            var prompt = "Are you sure you remove to give admin privileges to " + this.name.substring(15);
        }
        var data = {
            field: "admin",
            value: this.checked
        };
        var id = this.value;
        var checkbox_id = this.id;
        alertify.confirm(prompt,
        // Cannot put anything related to the checkbox inside these anonymous functions
            function(){
                $.ajax({
                    url: '/display_users/' + id,
                    type: 'PUT',
                    dataType: "text",
                    data: data,
                    // Technically it should be success, but for some reason successful calls think they are errors
                    success: function(response){
                        alertify.message(response)
                    }
                });
            },
            function(){
                toggle_check(checkbox_id)
            }
        );
    });
    $("#delete_form_button").click(function(){
        alertify.confirm("Are you sure you want to delete? There is no undo because that's a lot of work.",
            function(){
                $("#delete_user_form").submit();
            },
            function(){
            }
        );
    });
    $(".delete_checkbox").click(function(e){
        if(!lastChecked) {
            lastChecked = this;
            return;
        }

        if(e.shiftKey) {
            var start = $(".delete_checkbox").index(this);
            var end = $(".delete_checkbox").index(lastChecked);

            for (var index = Math.min(start, end); index < Math.max(start, end) + 1; index++){
                // Make sure the field is enabled if you change it
                var id = $(".delete_checkbox")[index].id
                var field = $("#" + id);
                var disabled = $("#" + id).is(':disabled');
                field.prop('checked', lastChecked.checked && !disabled);
            }
            
        }

        lastChecked = this;
    })
})

var toggle_check = function(id){
    $("#" + id).prop('checked', !$("#" + id).checked)
};