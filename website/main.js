// Parameters
enable_showFileSize = 1



window.onload = setInterval(clock,500);

function clock() {
  var weekday = new Array(7);
  weekday[0] = "Sunday"
  weekday[1] = "Monday"
  weekday[2] = "Tuesday"
  weekday[3] = "Wednesday"
  weekday[4] = "Thursday"
  weekday[5] = "Friday"
  weekday[6] = "Saturday"

  var d = new Date()
  var date   = ("0" + d.getDate()).slice(-2)
  var year   = d.getFullYear()
  var month  = ("0" + d.getMonth()).slice(-2)
  var hour   = ("0" + d.getHours()).slice(-2)
  var minute = ("0" + d.getMinutes()).slice(-2)

  document.getElementById("time").innerHTML = `${weekday[d.getDay()]} ${date}.${month}.${year} ${hour}:${minute}`
}

function showFileSize() {
  if ( enable_showFileSize === 1) {
    document.getElementById('p-filesize').innerHTML = `Size: ${filesize}k`
  } else {
    document.getElementById('p-filesize').innerHTML = ""
  }
}
