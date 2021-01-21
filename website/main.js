// Infinite looping commands
window.onload = setInterval(updatePhoto,15000);

// Functions
function updatePhoto() {
  //document.getElementById('bg-photo').src   = "photos/current.jpg?" + Date.now()
  //document.getElementById('main-photo').src = "photos/current.jpg?" + Date.now()
  //document.getElementById('bg-photo').src   = "photos/current.webp?" + Date.now()
  //document.getElementById('main-photo').src = "photos/current.webp?" + Date.now()
  document.getElementById('photo').src = "photos/current.webp?" + Date.now()
  console.log(`Photo updated`)
}
