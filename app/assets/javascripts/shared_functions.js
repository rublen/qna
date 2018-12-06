function cleanFlash() {
  var alert = document.querySelector('.alert');
  if (alert) { alert.remove() };
};

function showFlash(innerHtml) {
  cleanFlash();
  var flash = document.createElement('div');
  var nodeAfterFlash = document.querySelector('.navbar').nextSibling;

  flash.innerHTML = innerHtml.trim();
  document.body.insertBefore(flash, nodeAfterFlash);
};

var closeButton = '<button type="button" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">&times;</span></button>';

function flashAlert(message) {
  showFlash('<div class="alert alert-danger" role="alert">' + message + closeButton + '</div>')
};

function editHideClassHandler(model, id) {
  cleanFlash();
  document.querySelector('[data-id="' + id + '"]', '[data-model="' + model + '"]').classList.toggle('hide');
  document.querySelector('#edit-' + model + '-form-' + id).classList.toggle('hide');
};

function addCommentLinkHandler(link) {
  if (gon.current_user_id) {
    cleanFlash();

    var form = link.parentElement.querySelector('.new-comment-form');
    form.querySelector('textarea').value = "";
    form.querySelector('.comment-errors').innerHTML = "";
    form.classList.remove('hide');
    link.classList.add('hide');

    form.querySelector('.comment-form-cancel').addEventListener('click', function(event) {
      event.preventDefault();
      form.classList.add('hide');
      link.classList.remove('hide')
    })
  } else {
    flashAlert("You need to sign in or sign up before continuing.")
  }
};
