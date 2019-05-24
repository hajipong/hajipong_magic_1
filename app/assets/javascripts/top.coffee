$ ->
  $('#ajax_form')
    .on 'ajax:complete', (event) ->
      response = event.detail[0].response
      $('#result_text').html(response)