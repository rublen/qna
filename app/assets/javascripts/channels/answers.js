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
        console.log('recived: ' + data);
        data = JSON.parse(data);
        if (data.answer && data.answer.user_id != gon.current_user_id) {
          answers.innerHTML += JST["templates/answer"](data);

          var answer = document.querySelector('#answer-' + data.answer.id);
          var voteUp = answer.querySelector('.vote-up');
          var voteDown = answer.querySelector('.vote-down');
          var addCommentLink = answer.querySelector('a.add-comment-link');
          var upVoted = false;
          var downVoted = false;


          voteUp.addEventListener('click', function() {
            if (!downVoted) {
              cleanFlash();
              console.log('**data.vote_id:' + data.vote_id);
              var voteSum = voteUp.parentElement.querySelector('.vote-sum');
              var sum = parseInt(voteSum.textContent);
              voteSum.textContent = ++sum;
              upVoted = !upVoted
              if (upVoted) {
                setUnvoting(voteUp, voteDown, data.vote_id)
              } else {
                setVoting(voteUp, voteDown)
              }
            }
          });

          voteDown.addEventListener('click', function() {
            if (!upVoted) {
              cleanFlash();
              downVoted = !downVoted
              console.log('**data.vote_id:' + data.vote_id)
              var voteSum = voteDown.parentElement.querySelector('.vote-sum')
              var sum = parseInt(voteSum.textContent);
              voteSum.textContent = --sum;
              if (downVoted) {
                setUnvoting(voteDown, voteUp, data.vote_id)
              } else {
                setVoting(voteDown, voteUp)
              }
            }
          })
          addCommentLink.addEventListener('click', function(event) {
            event.preventDefault();
            addCommentLinkHandler(this)
          })
        }

        if (data.comment && data.comment.user_id != gon.current_user_id) {
          console.log('gon.user_id:' + gon.current_user_id, 'data.comment.commentable_css_id '+data.comment.commentable_css_id)
          var commentable = document.querySelector(data.comment.commentable_css_id);
          commentable.querySelector('.comments').querySelector('.collection-group').innerHTML += JST["templates/comment"](data.comment);
        }
      }
    })
  }
})
