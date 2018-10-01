document.addEventListener('turbolinks:load', function() {
  var answers = document.querySelector('.answers')

  if(answers) {
    var arr = answers.querySelectorAll('.best-answer')

    if (arr.length) {
      arr.forEach(function(element) {
        var radio = element.getElementsByTagName('input')[0];

        radio.addEventListener('click', function() {
          answer_id = this.id.split('answer_')[1];
          document.querySelector('.answers').innerHTML = moveToTheTop(answer_id)
        })
      })
    }

    function moveToTheTop(answer_id) {
      var splited = answers.innerHTML.split('<p id="answer-body-')
      for(var i = 0; i < splited.length; i++) {
        if (splited[i].substring(0, answer_id.length) === answer_id) {
          var topAnswer = splited[i];
          splited[i] = splited[1];
          splited[1] = topAnswer;
          return splited.join('<p id="answer-body-')
        }
      }
    }
  }
})
