document.addEventListener('turbolinks:load', function() {
  var addCommentLinks = document.querySelectorAll('.add-comment-link');

  if (addCommentLinks.length) {
    addCommentLinks.forEach(function(link) {
      link.addEventListener('click', function(event) {
        console.log('Cooom!');
        event.preventDefault();
        addCommentLinkHandler(this)
      })
    })
  }
});
