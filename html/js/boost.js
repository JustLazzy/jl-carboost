let progressBar = document.querySelector(".prog");
let boostpercent = document.getElementById("boost-percent");
let startVal = 0;
let endVal = 100;
$(document).ready(function () {
  let progBar = setInterval(() => {
    startVal++;
    progressBar.style.width = startVal + "%";

    if (startVal == endVal) {
      clearInterval(progBar);
    }
  }, 50);
});
