document.addEventListener('turbolinks:load', function() {
  var voteUps = document.querySelectorAll('.vote-up');
  var voteDowns = document.querySelectorAll('.vote-down');

  var votes, voteId, upVoted, downVoted;

  voteUps.forEach(function(voteUp) {
    voteUp.addEventListener('ajax:success', function(event) {
      cleanFlash()
      votes = event.detail[0].votable_sum;
      voteId = event.detail[0].vote_id;
      upVoted = event.detail[0].up_voted;
      downVoted = event.detail[0].down_voted;

      voteUp.parentElement.querySelector('.vote-sum').textContent = votes;
      var voteDown = voteUp.parentElement.querySelector('.vote-down');

      if (upVoted) {
        setUnvoting(voteUp, voteDown, voteId)
      } else if (!downVoted) {
        setVoting(voteUp, voteDown)
      }
    })
    voteUp.addEventListener('ajax:error', function(event) {
      flashAlert(event.detail[0])
    });
  });

  voteDowns.forEach(function(voteDown) {
    voteDown.addEventListener('ajax:success', function(event) {
      cleanFlash()
      votes = event.detail[0].votable_sum;
      voteId = event.detail[0].vote_id;
      upVoted = event.detail[0].up_voted;
      downVoted = event.detail[0].down_voted;

      voteDown.parentElement.querySelector('.vote-sum').textContent = votes;
      var voteUp = voteDown.parentElement.querySelector('.vote-up');

      if (downVoted) {
        setUnvoting(voteDown, voteUp, voteId)
      } else if (!upVoted) {
        setVoting(voteDown, voteUp)
      }
    })
    voteDown.addEventListener('ajax:error', function(event) {
      flashAlert(event.detail[0])
    });
  });
});

function setUnvoting(elem, other, voteId) {
  elem.querySelector('a.vote').classList.add('hide')
  elem.querySelector('.vote-disabled').classList.add('hide')
  elem.querySelector('a.unvote').classList.remove('hide')
  elem.querySelector('a.unvote').href = "/votes/" + voteId + "/unvote"

  other.querySelector('a.unvote').classList.add('hide')
  other.querySelector('a.vote').classList.add('hide')
  other.querySelector('.vote-disabled').classList.remove('hide')
};

function setVoting(elem, other) {
  elem.querySelector('a.unvote').href = ""
  elem.querySelector('a.unvote').classList.add('hide')
  elem.querySelector('.vote-disabled').classList.add('hide')
  elem.querySelector('a.vote').classList.remove('hide')

  other.querySelector('a.unvote').href = ""
  other.querySelector('a.unvote').classList.add('hide')
  other.querySelector('.vote-disabled').classList.add('hide')
  other.querySelector('a.vote').classList.remove('hide')
};
