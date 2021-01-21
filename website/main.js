// Infinite looping commands
window.onload = setInterval(updatePhoto,15000);

// Functions
function updatePhoto() {
  document.getElementById('photo').src = 'photos/current.webp?' + Date.now()
  console.log('Photo updated')
}
