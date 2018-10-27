document.addEventListener('turbolinks:load', function() {
  var voteUps = document.querySelectorAll('.vote-up');
  var voteDowns = document.querySelectorAll('.vote-down');

  var voteUp = document.querySelector('.vote-up');
  var votes, voteId, upVoted, downVoted;

  voteUps.forEach(function(voteUp) {
    voteUp.addEventListener('ajax:success', function(event) {
      votes = JSON.parse(event.detail[2].responseText).votable_sum;
      voteId = JSON.parse(event.detail[2].responseText).vote_id;
      upVoted = JSON.parse(event.detail[2].responseText).up_voted;
      downVoted = JSON.parse(event.detail[2].responseText).down_voted;

      voteUp.parentElement.querySelector('.vote-sum').textContent = votes;
      var voteDown = voteUp.parentElement.querySelector('.vote-down');

      if (upVoted == true) {
        setUnvoting(voteUp, voteDown, voteId)
      } else { if (downVoted == false) {
        setVoting(voteUp, voteDown)
        }
      }
    })
  });

  voteDowns.forEach(function(voteDown) {
    voteDown.addEventListener('ajax:success', function(event) {
      votes = JSON.parse(event.detail[2].responseText).votable_sum;
      voteId = JSON.parse(event.detail[2].responseText).vote_id;
      upVoted = JSON.parse(event.detail[2].responseText).up_voted;
      downVoted = JSON.parse(event.detail[2].responseText).down_voted;

      voteDown.parentElement.querySelector('.vote-sum').textContent = votes;
      var voteUp = voteDown.parentElement.querySelector('.vote-up');

      if (downVoted == true) {
        setUnvoting(voteDown, voteUp, voteId)
      } else { if (upVoted == false) {
        setVoting(voteDown, voteUp)
        }
      }
    })
  });

  function setUnvoting(elem, other, voteId) {
    elem.querySelector('a.vote').classList.add('hide')
    elem.querySelector('.vote-disabled').classList.add('hide')
    elem.querySelector('a.unvote').classList.remove('hide')
    elem.querySelector('a.unvote').href = "/votes/" + voteId + "/unvote"

    other.querySelector('a.unvote').classList.add('hide')
    other.querySelector('a.vote').classList.add('hide')
    other.querySelector('.vote-disabled').classList.remove('hide')

    stopHovering(elem, hoverColor(elem));
    stopHovering(other, defaultColor)
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

    getBackHovering(other);
    getBackHovering(elem)
  };

  var defaultColor = "#868e96";
  var voteUpHoverColor = "lightgreen";
  var voteDownHoverColor = "red";

  function hoverColor(elem) {
    var voteUpsArr = Array.prototype.slice.call(voteUps);
    return (voteUpsArr.includes(elem) ? voteUpHoverColor : voteDownHoverColor)
  };

  function stopHovering(elem, color) {
    console.log('stop hover')
    elem.addEventListener('mouseover', function(){
      console.log('stop hover-2')
      elem.style.color = color
    });
    elem.addEventListener('mouseout', function(){
      elem.style.color = color
    });
  };

  function getBackHovering(elem) {
    console.log('get hover')
    elem.addEventListener('mouseover', function(){
      console.log('get hover-2')
      elem.style.color = hoverColor(elem);
    });
    elem.addEventListener('mouseout', function(){
      elem.style.color = defaultColor
    });
  }
});
