document.addEventListener('turbolinks:load', function() {
  var questions = document.querySelector('.questions')

  if (questions) {
    App.cable.subscriptions.create('QuestionsChannel', {
      connected: function() { console.log('connected!') },
      received: function(data) {
        console.log('recived: ' + data);
        var newQuestion = document.createElement('li');
        newQuestion.innerHTML = data;
        questions.querySelector('.list-group').appendChild(newQuestion) }
    })
  }
})
