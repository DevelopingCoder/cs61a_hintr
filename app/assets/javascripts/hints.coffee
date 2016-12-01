$(document).on 'ajax:success', (event, data) ->
    $('#num-upvotes-' + data.hint_id).html(data.upvotes)
    $('#num-downvotes-' + data.hint_id).html(data.downvotes)
    if data.finalizable
        $('#hint-row-' + data.hint_id).before('<div class="row" id="finalize-' + data.hint_id + '"><a id="finalize-' + data.hint_id + '" rel="nofollow" data-method="post" href="/tag2wronganswers/' + data.tag2wronganswer_id + '/hints/' + data.hint_id + '/finalize">Finalize hint</a></div>')
    