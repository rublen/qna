document.addEventListener('turbolinks:load', function() {
  var editLinks = document.querySelectorAll('.edit-link');

  if (editLinks.length) {
    for(var i = 0; i < editLinks.length; i++) {
      editLinks[i].addEventListener('click', function(event) {
        event.preventDefault();
        editHideClassHandler(this.dataset.model, this.dataset.id)
      })
    }
  }
});

function editHideClassHandler(model, id) {
  document.querySelector('[data-id="' + id + '"]', '[data-model="' + model + '"]').classList.toggle('hide');
  document.querySelector('#edit-' + model + '-form-' + id).classList.toggle('hide')
};

function cleanFlash() {
  document.querySelector('.notice').innerHTML = '';
  document.querySelector('.alert').innerHTML = ''
}
