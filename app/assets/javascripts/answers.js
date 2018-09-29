document.addEventListener('turbolinks:load', function() {
  var editAnswerLinks = document.querySelectorAll('.edit-answer-link');

  if (editAnswerLinks.length) {
    for(var i = 0; i < editAnswerLinks.length; i++) {
      editAnswerLinks[i].addEventListener('click', function(event) {
        event.preventDefault();
        editHideClassHandler(this.dataset.answerId);
      });
    };
  };
});

function editHideClassHandler(answerId) {
  document.querySelector('[data-answer-id="' + answerId + '"]').classList.toggle('hide');
  document.getElementById('edit-answer-form-' + answerId).classList.toggle('hide');
};