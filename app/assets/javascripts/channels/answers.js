document.addEventListener('turbolinks:load', function() {
  var answers = document.querySelector('.answers')

  if (answers) {
    App.answers = App.cable.subscriptions.create({ channel: "AnswersChannel", question_id: gon.question_id }, {
      connected: function() {
        // Called when the subscription is ready for use on the server
        console.log('connected answers!')
      },

      disconnected: function() {
        // Called when the subscription has been terminated by the server
      },

      received: function(data) {
        // Called when there's incoming data on the websocket for this channel
        console.log('recived: ' + data)
      }
    })
  }
})
