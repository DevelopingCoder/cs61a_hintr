# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on 'ajax:success', (event, data) ->
    $('#num-upvotes-' + data.message_id).html(data.upvotes)
    $('#num-downvotes-' + data.message_id).html(data.downvotes)