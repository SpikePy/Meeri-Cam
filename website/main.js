// Infinite looping commands
window.onload = setInterval(updatePhoto,15000);

// Functions
function updatePhoto() {
  var date = Date.now()

  var d = new Date()
  var date    = ("0" + d.getDate()).slice(-2)
  var year    = d.getFullYear()
  var month   = ("0" + d.getMonth()).slice(-2)
  var hour    = ("0" + d.getHours()).slice(-2)
  var minute  = ("0" + d.getMinutes()).slice(-2)
  var seconds = ("0" + d.getSeconds()).slice(-2)
  var time    = `${hour}:${minute}:${seconds}`

  document.getElementById('background').src = 'photos/current.webp?' + date
  document.getElementById('photo').src      = 'photos/current.webp?' + date
  console.log(`Reload Photo (${time})`)
}
