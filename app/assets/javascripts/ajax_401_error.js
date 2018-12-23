document.addEventListener('turbolinks:load', function() {
  document.addEventListener('ajax:error', function(event) {
    if (event.detail[1] == "Unauthorized") {
      flashAlert(event.detail[0])
    };
  });
});
