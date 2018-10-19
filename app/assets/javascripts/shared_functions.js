function editHideClassHandler(model, id) {
  document.querySelector('[data-id="' + id + '"]', '[data-model="' + model + '"]').classList.toggle('hide');
  document.querySelector('#edit-' + model + '-form-' + id).classList.toggle('hide');
};

function cleanFlash() {
  document.querySelector('.alert').remove();
};

function showFlash(innerHtml) {
  var flash = document.createElement('div');
  var nodeAfterFlash = document.querySelector('.navbar').nextSibling;

  flash.innerHTML = innerHtml;
  document.body.insertBefore(flash, nodeAfterFlash);
};
