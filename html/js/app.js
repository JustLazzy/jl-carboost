var audio = new Audio("assets/audio/notification.wav");
index = 0;
$(function () {
  if (index >= 2) {
    index = 0;
  }
  let settings = document.querySelector("#settings");
  let bennys = document.querySelector("#bennys-app");
  bennysheader = bennys.querySelector("header");
  let boosting = document.querySelector("#boosting-app");
  boostingheader = boosting.querySelector("header");

  function onDrag({ path, movementX, movementY }) {
    try {
      const name = document.querySelector(`#${path[2].id}`);
      let getStyle = window.getComputedStyle(name);
      let leftVal = parseInt(getStyle.left);
      let topVal = parseInt(getStyle.top);
      name.style.left = `${leftVal + movementX}px`;
      name.style.top = `${topVal + movementY}px`;
    } catch (error) {
      if (error) return;
    }
  }

  function display(bool) {
    bool = true;
    if (bool) {
      $(".laptop").css("visibility", "visible");
      // $(".laptop").css("opacity", "1");
      $(".laptop").css("top", "50%");
      return;
    } else {
      // $(".laptop").css("opacity", "0");
      $(".laptop").css("top", "-50%");
      $(".laptop").css("visibility", "hidden");
      return;
    }
  }

  function createIcon(name) {
    // return console.log(name);
    const div = document.createElement("div");
    div.id = name;
    div.className = "icon start";
    div.innerHTML = `<img src="assets/${name}.png" alt="${name}">`;
    $(".left-icons").append(div);
    return;
  }

  function removeIcon(name) {
    const div = document.querySelector(".left-icons");
    const child = div.querySelector(`#${name}`);
    child.remove();
    return;
  }

  function toggleDisplayApp(bool, id) {
    if (bool && id != null) {
      $(id).css("z-index", index++);
      $(id).css("visibility", "visible");
      $(id).css("opacity", "100%");

      setTimeout(() => {
        $(id).css("transition", "0s");
      }, 500);
      return;
    } else if (!bool && id != null) {
      $(id).css("z-index", "0");
      $(id).css("transition", "0.5s");
      $(id).css("visibility", "hidden");
      $(id).css("opacity", "0");
      index - 1;
      return;
    }
  }

  bennysheader.addEventListener("mousedown", () => {
    bennysheader.classList.add("active");
    bennysheader.addEventListener("mousemove", onDrag);
  });
  boostingheader.addEventListener("mousedown", () => {
    boostingheader.classList.add("active");
    boostingheader.addEventListener("mousemove", onDrag);
  });
  document.addEventListener("mouseup", (e) => {
    bennysheader.classList.remove("active");
    bennysheader.removeEventListener("mousemove", onDrag);
    boostingheader.classList.remove("active");
    boostingheader.removeEventListener("mousemove", onDrag);
  });
  display(false);
  window.addEventListener("message", function (event) {
    if (event.data.type === "openlaptop") {
      if (event.data.status == true) {
        display(true);
        return;
      } else {
        display(false);
        return;
      }
    }
    if (event.data.type === "loadStore") {
      // laad all the store data from config
      const storedata = event.data.store;
      for (let index = 0; index < storedata.length; index++) {
        const element = storedata[index];
        if (element.name.length < 2 || !element.price || element.image < 2)
          return;
        // create article / card for store
        // const article = document.createElement("article");
        // article.id = element.name.toLowerCase().replace(/ +/g, "");
        // article.innerHTML = `<img src="./assets/shop/${element.image}" alt="${element.name}" />
        // <div class="text">
        //   <h3>${element.name}</h3>
        //   <p>Price: ${element.price}</p>
        //   <button>Buy</button>
        //   <button style="background: #1db15b">Add to basket</button>
        // </div>
        // `;
        // $(".grid").append(article);
        // console.log(element.image);
        // console.log(JSON.stringify(element.name));
      }
    }
  });
  window.addEventListener("click", function (event) {
    if (event.target.id != "splash") {
      if (event.target.id == "bennys") {
        toggleDisplayApp(true, "#bennys-app");
        createIcon(event.target.id);
      } else if (event.target.id == "boosting") {
        toggleDisplayApp(true, "#boosting-app");
        createIcon("boost");
      } else if (event.target.id == "settings") {
        toggleDisplayApp(true, "#settings");
      } else if (event.target.id == "close-bennys") {
        toggleDisplayApp(false, "#bennys-app");
        removeIcon("bennys");
      } else if (event.target.id == "close-boosting") {
        toggleDisplayApp(false, "#boosting-app");
        removeIcon("boost");
      } else {
      }
    }
  });

  document.onclick = function (event) {
    // audio.play();
    console.info(index);
  };

  document.onkeydown = function (data) {
    if (event.repeat) {
      return;
    }
    switch (event.keyCode) {
      case 27:
        if (bennys.style.visibility == "visible") {
          toggleDisplayApp(false, "#bennys-app");
          removeIcon("bennys");
        } else if (boosting.style.visibility == "visible") {
          toggleDisplayApp(false, "#boosting-app");
          removeIcon("boost");
        } else {
          $.post("https://jl-carboost/exit", JSON.stringify({}));
        }
        break;
      case 8:
        if (bennys.style.visibility == "visible") {
          toggleDisplayApp(false, "#bennys-app");
          return;
        } else if (boosting.style.visibility == "visible") {
          toggleDisplayApp(false, "#boosting-app");
          return;
        } else {
          $.post("https://jl-carboost/exit", JSON.stringify({}));
        }
        break;
    }
  };
});

// Refresh date
setInterval(refreshTime, 1000);

function timePMAM(date) {
  var hours = date.getHours();
  var minutes = date.getMinutes();
  var seconds = date.getSeconds();
  var ampm = hours >= 12 ? "PM" : "AM";
  hours = hours % 12;
  minutes = minutes < 10 ? "0" + minutes : minutes;
  var strTime = hours + ":" + minutes + " " + ampm;
  return strTime;
}

function refreshTime() {
  var date = new Date();
  var month = date.getMonth() + 1;
  var day = date.getDate();
  var year = date.getFullYear();
  var dateString = month + "/" + day + "/" + year;
  $("#time").html(timePMAM(date));
  $("#date").html(dateString);
}
