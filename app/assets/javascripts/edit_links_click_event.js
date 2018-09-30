// document.addEventListener('turbolinks:load', function() {
//   var editLinks = document.querySelectorAll('.edit-link');

//   if (editLinks.length) {
//     for(var i = 0; i < editLinks.length; i++) {
//       editLinks[i].addEventListener('click', function(event) {
//         event.preventDefault();
//         editHideClassHandler(this.dataset.id);
//       });
//     };
//   };
// });

// function editHideClassHandler(model, id) {
//   document.querySelector('[data-' + model + '-id="' + id + '"]').classList.toggle('hide');
//   document.getElementById('edit-' + model + '-form-' + id).classList.toggle('hide');
// };
