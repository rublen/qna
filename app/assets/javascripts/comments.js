document.addEventListener('turbolinks:load', function() {
  var addCommentLinks = document.querySelectorAll('.add-comment-link');

  if (addCommentLinks.length) {
    addCommentLinks.forEach(function(link) {
      link.addEventListener('click', function(event) {
        event.preventDefault();
        cleanFlash();
        var form = link.parentElement.querySelector('.new-comment-form');

        form.querySelector('textarea').value = "";
        form.classList.remove('hide');
        link.classList.add('hide');

        form.querySelector('.comment-form-cancel').addEventListener('click', function(event) {
          event.preventDefault();
          form.classList.add('hide');
          link.classList.remove('hide');
        })
      })
    })
  }
});
