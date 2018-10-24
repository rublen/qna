document.addEventListener('turbolinks:load', function() {
  var voteUp = document.querySelector('.vote-up');
  var voteDown = document.querySelector('.vote-down');
  var sum = voteUp.parentElement.querySelector('.vote-sum');

  var defaultColor = window.getComputedStyle(voteUp).color;
  var voteUpHoverColor = "lightgreen";
  var voteDownHoverColor = "red";

  function hoverColor(elem) {
    return (elem == voteUp ? voteUpHoverColor : voteDownHoverColor)
  }

  voteUp.addEventListener('click', function() {
    var voted = sum.dataset.voted;
    var upVoted = voteUp.dataset.voted;

    if (voted == '1' && upVoted == '1') {
      unvoting(voteUp, voteDown, 1);
    } else { if (voted == '0') {
      voting(voteUp, voteDown, 1)
      }
    }
  });

  voteDown.addEventListener('click', function() {
    var voted = sum.dataset.voted;
    var downVoted = voteDown.dataset.voted;

    if (voted == '1' && downVoted =='1') {
      unvoting(voteDown, voteUp, -1);
    } else { if (voted == '0') {
      voting(voteDown, voteUp, -1)
      }
    }
  });

  function voting(elem, other, diff) {
    var sumValue = parseInt(sum.textContent) + diff;
    sum.textContent = sumValue;
    elem.dataset.voted = 1;
    sum.dataset.voted = 1;
    other.dataset.voted = 0;

    stopHovering(elem, hoverColor(elem));
    stopHovering(other, defaultColor)
  };

  function unvoting(elem, other, diff) {
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
