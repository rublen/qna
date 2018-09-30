document.addEventListener('turbolinks:load', function() {
  var editQuestionLinks = document.querySelectorAll('.edit-question-link');
// <a class="edit-question-link" data-question-id="4" href="">Edit</a>
  if (editQuestionLinks.length) {
    for(var i = 0; i < editQuestionLinks.length; i++) {
      editQuestionLinks[i].addEventListener('click', function(event) {
        event.preventDefault();
        editHideClassHandler('question', this.dataset.questionId);
      });
    };
  };
});

// function editQuestionHideClassHandler(questionId) {
//   document.querySelector('[data-question-id="' + questionId + '"]').classList.add('hide');
//   document.getElementById('edit-question-form-' + questionId).classList.remove('hide');
// };
