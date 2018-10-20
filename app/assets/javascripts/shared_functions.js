function editHideClassHandler(model, id) {
  cleanFlash()
  document.querySelector('[data-id="' + id + '"]', '[data-model="' + model + '"]').classList.toggle('hide');
  document.querySelector('#edit-' + model + '-form-' + id).classList.toggle('hide');
};

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
