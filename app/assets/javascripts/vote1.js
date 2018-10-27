document.addEventListener('turbolinks:load', function() {
  var voteUps = document.querySelectorAll('.vote-up');
  var voteDowns = document.querySelectorAll('.vote-down');

  var voteUp = document.querySelector('.vote-up');
  var defaultColor = window.getComputedStyle(voteUp).color;
  var voteUpHoverColor = "lightgreen";
  var voteDownHoverColor = "red";
  var votes, voteId, voted, upVoted, downVoted;

  function hoverColor(elem) {
    var voteUpsArr = Array.prototype.slice.call(voteUps);
    return (voteUpsArr.includes(elem) ? voteUpHoverColor : voteDownHoverColor)
  };

  voteUps.forEach(function(voteUp) {
    voteUp.addEventListener('ajax:success', function(event) {
      votes = JSON.parse(event.detail[2].responseText).votable_sum;
      voteId = JSON.parse(event.detail[2].responseText).vote_id;
      upVoted = JSON.parse(event.detail[2].responseText).up_voted;
      downVoted = JSON.parse(event.detail[2].responseText).down_voted;

      voteUp.parentElement.querySelector('.vote-sum').textContent = votes;
      var voteDown = voteUp.parentElement.querySelector('.vote-down');
      console.log("upVoted== true: ", upVoted == true)
      console.log("downVoted == false: ", downVoted  == false)
      if (upVoted == true) {
        console.log(upVoted == true)
        setUnvoting(voteUp, voteDown, voteId)
      } else { if (downVoted == false) {
        console.log(downVoted == false)
        setVoting(voteUp, voteDown)
        }
      }
    })
  });


  voteDowns.forEach(function(voteDown) {
    voteUp.addEventListener('ajax:success', function(event) {
      votes = JSON.parse(event.detail[2].responseText).votable_sum;
      voteId = JSON.parse(event.detail[2].responseText).vote_id;
      upVoted = JSON.parse(event.detail[2].responseText).up_voted;
      downVoted = JSON.parse(event.detail[2].responseText).down_voted;

      var sum = voteDown.parentElement.querySelector('.vote-sum');
      var voteUp = voteDown.parentElement.querySelector('.vote-up');

      if (downVoted == 'true') {
        setUnvoting(voteDown, voteUp, voteId)
      } else { if (upVoted == 'false') {
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

    function stopHovering(elem, color) {
      elem.addEventListener('mouseover', function(){
        elem.style.color = color
      });
      elem.addEventListener('mouseout', function(){
        elem.style.color = color
      });
    };

    function getBackHovering(elem) {
      elem.addEventListener('mouseover', function(){
        elem.style.color = hoverColor(elem);
      });
      elem.addEventListener('mouseout', function(){
        elem.style.color = defaultColor
      });
    }
});
