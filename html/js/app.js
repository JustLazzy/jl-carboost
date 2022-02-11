var audio = new Audio("assets/audio/notification.wav");
const item = [];
index = 0;

$(document).ready(() => {
  if (index >= 2) {
    index = 0;
  }

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
      $(".laptop").css("top", "50%");
      return;
    } else {
      $(".laptop").css("top", "-50%");
      $(".laptop").css("visibility", "hidden");
      return;
    }
  }

  function createIcon(name) {
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

  function refreshStore() {
    const test = document.getElementsByClassName("grid");
    console.log("this test", test);
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
  });

  // $(document).click(function (e) {
  //   e.preventDefault();
  //   console.log(JSON.stringify(e));
  // });

  $(".basket-button").click(function () {
    console.log("click");
  });

  function closeBennys() {
    setTimeout(() => {
      $(".loading").css("opacity", "1");
      $(".loading").css("visibility", "visible");
      $(".grid").css("visibility", "hidden");
      $(".grid").css("opacity", "0");
    }, 500);
    removeIcon("bennys");
  }
  window.addEventListener("click", function (event) {
    if (event.target.id != "splash") {
      if (event.target.id == "bennys") {
        toggleDisplayApp(true, "#bennys-app");
        createIcon(event.target.id);
        loadBennysApp();
      } else if (event.target.id == "boosting") {
        toggleDisplayApp(true, "#boosting-app");
        createIcon("boost");
      } else if (event.target.id == "settings") {
        toggleDisplayApp(true, "#settings");
      } else if (event.target.id == "close-bennys") {
        toggleDisplayApp(false, "#bennys-app");
        closeBennys();
      } else if (event.target.id == "close-boosting") {
        toggleDisplayApp(false, "#boosting-app");
        removeIcon("boost");
      } else {
      }
    }
  });

  document.onkeydown = function (data) {
    if (event.repeat) {
      return;
    }
    switch (event.keyCode) {
      case 27:
        if (bennys.style.visibility == "visible") {
          toggleDisplayApp(false, "#bennys-app");
          closeBennys();
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

function addBasket(e) {
  const tets = $(e).parent();
  console.log(tets[0]);
}

// Refresh time
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

function addItem(e) {}

function loadBennysApp() {
  $(".grid").empty();
  $(".loading").css("opacity", "0");
  for (let index = 0; index <= 20; index++) {
    console.log(index);
    const article = document.createElement("article");
    article.innerHTML = `<img src="./assets/shop/brake_parts_a.png" alt="test" />
            <div class="text">
              <h3>CARD</h3>
              <p>Stock: <b>50</b></p>
              <p class="price">$1000</p>
              <button onclick="addBasket(this)" class="basket-button">Add to basket</button>
            </div>
            `;
    $(".grid").append(article);
    $(".grid").css("visibility", "visible");
    $(".grid").css("opacity", "1");
  }
  // fetch("https://jl-carboost/loadstore", {
  //   method: "POST",
  //   headers: {
  //     "Content-Type": "application/json",
  //   },
  //   body: JSON.stringify({
  //     storeitem: item,
  //   }),
  // }).then((resp) =>
  //   resp.json().then((resp) => {
  //     $(".loading").css("opacity", "1");
  //     storedata = resp.storeitem;
  //     if (storedata) {
  //       storedata.forEach((data) => {
  //         item.splice(0, item.length);
  //         if (data.name.length < 2 || !data.price || !data.image) return;
  //         const article = document.createElement("article");
  //         // article.onclick = data.name.toLowerCase().replace(/ +/g, "");
  //         article.innerHTML = `<img src="./assets/shop/${data.image}" alt="${data.name}" />
  //           <div class="text">
  //             <h3>${data.name}</h3>
  //             <p>Stock: <b>${data.stock}</b></p>
  //             <p class="price">$${data.price}</p>
  //             <button onclick="addBasket(this)" class="basket-button">Add to basket</button>
  //           </div>
  //           `;
  //         $(".grid").append(article);
  //         item.push(article.tagName);
  //       });
  //       setTimeout(() => {
  //         $(".loading").css("opacity", "0");
  //         $(".grid").css("visibility", "visible");
  //         $(".grid").css("opacity", "100%");
  //       }, 500);
  //     } else {
  //       const error = document.createElement("div");
  //       error.innerHTML = `<h1>Error</h1>`;
  //       $(".grid").append(error);
  //     }
  //   })
  // );
}
