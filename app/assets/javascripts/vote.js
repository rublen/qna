// document.addEventListener('turbolinks:load', function() {
//   var voteUps = document.querySelectorAll('.vote-up');
//   var voteDowns = document.querySelectorAll('.vote-down');

//   var voteUp = document.querySelector('.vote-up');
//   var defaultColor = window.getComputedStyle(voteUp).color;
//   var voteUpHoverColor = "lightgreen";
//   var voteDownHoverColor = "red";
//   var votes;

//   function hoverColor(elem) {
//     var voteUpsArr = Array.prototype.slice.call(voteUps);
//     return (voteUpsArr.includes(elem) ? voteUpHoverColor : voteDownHoverColor)
//   };

//   voteUps.forEach(function(voteUp) {
//     voteUp.addEventListener('ajax:success', function(event) {
//       // console.log("event.detail[2]: ", event.detail[2])
//       // console.log("event.detail[2].response['vote_id']: ", JSON.parse(event.detail[2].responseText).vote_id)
//       // console.log("event.detail[2].response['votable_sum']: ", JSON.parse(event.detail[2].responseText).votable_sum)
//       votes = JSON.parse(event.detail[2].responseText).votable_sum;
//       console.log(votes)
//       voteId = JSON.parse(event.detail[2].responseText).vote_id;

//       var sum = voteUp.parentElement.querySelector('.vote-sum');
//       var voteDown = voteUp.parentElement.querySelector('.vote-down');
//       var voted = sum.dataset.voted;
//       var upVoted = voteUp.dataset.voted;

//       if (voted == '1' && upVoted == '1') {
//         unvoting(voteUp, voteDown, 1);
//       } else { if (voted == '0') {
//         voting(voteUp, voteDown, voteId)
//         }
//       }
//     });

//     voteUp.addEventListener('ajax:errors', function() {})
//   });



//   voteDowns.forEach(function(voteDown) {
//     voteDown.addEventListener('ajax:success', function(event) {
//       votes = JSON.parse(event.detail[2].responseText).votable_sum.toString();
//       console.log(votes)
//       voteId = JSON.parse(event.detail[2].responseText).vote_id

//       var sum = voteDown.parentElement.querySelector('.vote-sum');
//       var voteUp = voteDown.parentElement.querySelector('.vote-up');
//       var voted = sum.dataset.voted;
//       var downVoted = voteDown.dataset.voted;

//       if (voted == '1' && downVoted =='1') {
//         unvoting(voteDown, voteUp, -1);
//       } else { if (voted == '0') {
//         voting(voteDown, voteUp, voteId)
//         }
//       }
//     })
//   });

//   function voting(elem, other, voteId) {
//     var sum = elem.parentElement.querySelector('.vote-sum');
//     sum.textContent = votes;

//     elem.dataset.voted = 1;
//     sum.dataset.voted = 1;
//     other.dataset.voted = 0;

//     elem.querySelector('a.vote').classList.add('hide')
//     elem.querySelector('a.unvote').classList.remove('hide')
//     elem.querySelector('a.unvote').href = "/votes/" + voteId + "/unvote"


//     other.querySelector('.vote-disabled').classList.remove('hide')
//     other.querySelector('a.unvote').classList.add('hide')
//     other.querySelector('a.vote').classList.add('hide')

//     stopHovering(elem, hoverColor(elem));
//     stopHovering(other, defaultColor)
//   };

//   function unvoting(elem, other) {
//     var sum = elem.parentElement.querySelector('.vote-sum');
//     sum.textContent = votes;

//     elem.dataset.voted = 0;
//     sum.dataset.voted = 0;
//     other.dataset.voted = 0;

//     elem.querySelector('a.unvote').href = ""
//     elem.querySelector('a.unvote').classList.add('hide')
//     elem.querySelector('a.vote').classList.remove('hide')

//     other.querySelector('.vote-disabled').classList.add('hide')
//     // other.querySelector('a.unvote').href = ""
//     other.querySelector('a.unvote').classList.add('hide')
//     other.querySelector('a.vote').classList.remove('hide')

//     getBackHovering(other);
//     getBackHovering(elem)
//   };

//     function stopHovering(elem, color) {
//       elem.addEventListener('mouseover', function(){
//         elem.style.color = color
//       });
//       elem.addEventListener('mouseout', function(){
//         elem.style.color = color
//       });
//     };

//     function getBackHovering(elem) {
//       elem.addEventListener('mouseover', function(){
//         elem.style.color = hoverColor(elem);
//       });
//       elem.addEventListener('mouseout', function(){
//         elem.style.color = defaultColor
//       });
//     }
// });
