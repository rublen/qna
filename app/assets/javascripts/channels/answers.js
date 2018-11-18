document.addEventListener('turbolinks:load', function() {
  var answers = document.querySelector('.answers')

  if (answers) {
    App.answers = App.cable.subscriptions.create({ channel: "AnswersChannel", question_id: gon.question_id }, {
      connected: function() {
        // Called when the subscription is ready for use on the server
        console.log('connected AnswersChannel!');
        added_answers = []
      },

      disconnected: function() {
        // Called when the subscription has been terminated by the server
      },

      received: function(data) {
        console.log('recived: ' + data);

        data = JSON.parse(data);


        if (data.answer && data.answer.user_id != gon.current_user_id) {
          answers.innerHTML += JST["templates/answer"](data);
          added_answers.push(data.answer.id);

          // 'Add comment' link handling
          var answer = document.querySelector('#answer-' + data.answer.id);
          var addCommentLink = answer.querySelector('a.add-comment-link');
          addCommentLinkHandler(addCommentLink)
        };


        if (data.vote && data.vote.votable_user_id != gon.current_user_id) {
          var answer = document.querySelector(data.vote.votable_css_id);
          answer.querySelector('.vote-sum').textContent = data.vote.vote_sum;

          // handling vote/unvite links 1) for real-time added answers, 2) for user-voter's page
          console.log('added_answers: '+added_answers)
          if (added_answers.includes(data.vote.votable_id) && data.vote.user_id == gon.current_user_id) {
          var voteUp = answer.querySelector('.vote-up');
          var voteDown = answer.querySelector('.vote-down');
          var upVoted = data.vote.upvoted;
          var downVoted = data.vote.downvoted;

            if (!downVoted) {
              console.log('**data.vote.id:' + data.vote.id);
              if (upVoted) {
                setUnvoting(voteUp, voteDown, data.vote.id)
              } else {
                setVoting(voteUp, voteDown)
              }
            };
            if (!upVoted) {
              if (downVoted) {
                setUnvoting(voteDown, voteUp, data.vote.id)
              } else {
                setVoting(voteDown, voteUp)
              }
            }
          }
        }


        if (data.comment && data.comment.user_id != gon.current_user_id) {
          var commentable = document.querySelector(data.comment.commentable_css_id);
          commentable.querySelector('.comments').querySelector('.collection-group').innerHTML += JST["templates/comment"](data.comment);
        }
      }
    })
  }
})
