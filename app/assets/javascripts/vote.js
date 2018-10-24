document.addEventListener('turbolinks:load', function() {
  var voteUps = document.querySelectorAll('.vote-up');
  var voteDowns = document.querySelectorAll('.vote-down');

  var voteUp = document.querySelector('.vote-up');
  var defaultColor = window.getComputedStyle(voteUp).color;
  var voteUpHoverColor = "lightgreen";
  var voteDownHoverColor = "red";

  function hoverColor(elem) {
    var voteUpsArr = Array.prototype.slice.call(voteUps);
    return (voteUpsArr.includes(elem) ? voteUpHoverColor : voteDownHoverColor)
  };

  voteUps.forEach(function(voteUp) {
    voteUp.addEventListener('click', function() {
      var sum = voteUp.parentElement.querySelector('.vote-sum');
      var voteDown = voteUp.parentElement.querySelector('.vote-down');
      var voted = sum.dataset.voted;
      var upVoted = voteUp.dataset.voted;

      if (voted == '1' && upVoted == '1') {
        unvoting(voteUp, voteDown, 1);
      } else { if (voted == '0') {
        voting(voteUp, voteDown, 1)
        }
      }
    })
  });

  voteDowns.forEach(function(voteDown) {
    voteDown.addEventListener('click', function() {
      var sum = voteDown.parentElement.querySelector('.vote-sum');
      var voteUp = voteDown.parentElement.querySelector('.vote-up');
      var voted = sum.dataset.voted;
      var downVoted = voteDown.dataset.voted;

      if (voted == '1' && downVoted =='1') {
        unvoting(voteDown, voteUp, -1);
      } else { if (voted == '0') {
        voting(voteDown, voteUp, -1)
        }
      }
    })
  });

  function voting(elem, other, diff) {
    var sum = elem.parentElement.querySelector('.vote-sum');
    var sumValue = parseInt(sum.textContent) + diff;
    sum.textContent = sumValue;
    elem.dataset.voted = 1;
    sum.dataset.voted = 1;
    other.dataset.voted = 0;

    stopHovering(elem, hoverColor(elem));
    stopHovering(other, defaultColor)
  };

  function unvoting(elem, other, diff) {
    var sum = elem.parentElement.querySelector('.vote-sum');
    var sumValue = parseInt(sum.textContent) - diff;
    sum.textContent = sumValue;
    elem.dataset.voted = 0;
    sum.dataset.voted = 0;
    other.dataset.voted = 0;

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
