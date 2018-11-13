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
        console.log('recived: ' + data);
        data = JSON.parse(data);
        // answer = data.new_answer
        // attachments = data.attachments
        console.log(data.answer, data.attachments);
        if (data.answer.user_id != gon.current_user_id) {
          answers.innerHTML += JST["templates/answer"](data);

          var answer = document.querySelector('#answer-' + data.answer.id);
          var voteUp = answer.querySelector('.vote-up');
          var voteDown = answer.querySelector('.vote-down');
          var upVoted = false;
          var downVoted = false;

          if (!downVoted) {
            voteUp.addEventListener('click', function() {
              cleanFlash();
              console.log('**gon.vote_id:' + gon.vote_id);
              var voteSum = voteUp.parentElement.querySelector('.vote-sum');
              var sum = parseInt(voteSum.textContent);
              voteSum.textContent = sum++;
              upVoted = !upVoted
              if (upVoted) {
                setUnvoting(voteUp, voteDown, gon.vote_id)
              } else {
                setVoting(voteUp, voteDown)
              }
            })
          };

          if (!upVoted) {
            voteDown.addEventListener('click', function() {
              cleanFlash();
              downVoted = !downVoted
              console.log('**gon.vote_id:' + gon.vote_id)
              var voteSum = voteDown.parentElement.querySelector('.vote-sum')
              voteSum.textContent = parseInt(voteSum.textContent)--;
              if (downVoted) {
                setUnvoting(voteDown, voteUp, gon.vote_id)
              } else {
                setVoting(voteDown, voteUp)
              }
            })
          }
        }
      }
      // JST["templates/#{template}"](data)
    })
  }
})
