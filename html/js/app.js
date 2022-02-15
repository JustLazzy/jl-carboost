const item = [];
let typing;
index = 0;
const storeloaded = false;
let cartButton = document.querySelector(".cart-button");
let cart = document.querySelector(".cart");
let homeButton = document.querySelector(".home-button");
let checkoutbutton = document.querySelector(".buy-button");
let store = document.querySelector(".grid");
let laptop = document.querySelector(".laptop");
let volumebutton = document.querySelector("#volume");
let testing = document.querySelector(".buttontest");
let settingButton = document.querySelector("#setting");
let volumecontrol = document.getElementById("volume-control");
let saveConfig = document.querySelector(".save-config");

let isMuted = false;
let volumeValue = (50 / 200).toFixed(2);

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
  loadBennysApp();
  function display(bool) {
    if (bool) {
      laptop.classList.add("active");
      return;
    } else {
      laptop.classList.remove("active");
      return;
    }
  }
  display(false);

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
    let app = document.querySelector(id);
    if (bool && id != null) {
      if (app.id === "bennys-app") {
        if (cart.classList.contains("active")) {
          store.classList.remove("active");
        } else {
          store.classList.add("active");
        }
      }
      app.classList.add("active");
      // $(id).css("z-index", index++);
      // $(id).css("visibility", "visible");
      // $(id).css("opacity", "100%");

      setTimeout(() => {
        $(id).css("transition", "0s");
      }, 500);
      return;
    } else if (!bool && id != null) {
      app.classList.remove("active");
      // $(id).css("z-index", "0");
      $(id).css("transition", "0.5s");
      // $(id).css("visibility", "hidden");
      // $(id).css("opacity", "0");
      return;
    }
  }

  function refreshStore() {
    const test = document.getElementsByClassName("grid");
    console.log("this test", test);
  }

  $("input").keypress(function (e) {
    typing = true;
  });

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

  window.addEventListener("message", function (event) {
    if (event.data.type === "openlaptop") {
      if (event.data.status == true) {
        display(true);
        return;
      } else {
        display(false);
        return;
      }
    } else if (event.data.type === "checkout") {
      if (event.data.success == true) {
        checkoutSuccess();
      } else {
        Notification("You don't have enough money", "error");
      }
    }
  });

  homeButton.onclick = () => {
    store.classList.add("active");
    cart.classList.remove("active");
  };

  cartButton.onclick = () => {
    store.classList.remove("active");
    cart.classList.add("active");
    updateTotalPrice();
  };

  checkoutbutton.onclick = () => {
    checkout();
  };

  saveConfig.onclick = () => {
    // console.log("CLICKED");
    saveConfigs();
  };

  volumecontrol.onchange = (e) => {
    const input = e.target;
    volumeValue = (input.value / 200).toFixed(2);

    console.log(input.value);
    if (input.value == 0) {
      isMuted = true;

      volumebutton.classList.remove("fa-volume-up");
      volumebutton.classList.add("fa-volume-xmark");
    } else if (input.value > 0) {
      isMuted = false;
      volumebutton.classList.add("fa-volume-up");
      volumebutton.classList.remove("fa-volume-xmark");
    }
  };

  volumebutton.onclick = () => {
    if (volumebutton.classList.contains("fa-volume-up")) {
      volumecontrol.value = 0;
      isMuted = true;
      volumebutton.classList.remove("fa-volume-up");
      volumebutton.classList.add("fa-volume-xmark");
    } else {
      isMuted = false;
      volumecontrol.value = 50;
      volumebutton.classList.add("fa-volume-up");
      volumebutton.classList.remove("fa-volume-xmark");
    }
  };

  settingButton.onclick = () => {
    const setting = document.querySelector("#settings");
    if (setting.classList.contains("active")) {
      setting.classList.remove("active");
    } else {
      setting.classList.add("active");
    }
  };

  function closeBennys() {
    setTimeout(() => {
      // $(".grid").css("visibility", "hidden");
      // $(".grid").css("opacity", "0");
    }, 500);
    store.classList.remove("active");
    removeIcon("bennys");
  }
  window.addEventListener("click", function (event) {
    if (event.target.id != "splash") {
      if (event.target.id == "bennys") {
        toggleDisplayApp(true, "#bennys-app");
        createIcon(event.target.id);
        // loadBennysApp();
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
    switch (event.key) {
      case "Escape":
        if (bennys.classList.contains("active")) {
          toggleDisplayApp(false, "#bennys-app");
          closeBennys();
        } else if (boosting.style.visibility == "visible") {
          toggleDisplayApp(false, "#boosting-app");
          removeIcon("boost");
        } else {
          $.post("https://jl-carboost/exit", JSON.stringify({}));
        }
        break;
      // case "Backspace":
      //   $.post("https://jl-carboost/exit", JSON.stringify({}));
      //   break;
    }
  };
});

function uglyFunct() {
  var removeCartButtons = document.getElementsByClassName("remove-cart-item");
  for (var i = 0; i < removeCartButtons.length; i++) {
    var button = removeCartButtons[i];
    button.addEventListener("click", removeCartItem);
  }
  const quantityInputs = document.getElementsByClassName("cart-quantity");
  for (var i = 0; i < quantityInputs.length; i++) {
    let input = quantityInputs[i];
    input.addEventListener("change", quantityChanged);
  }
  let addCart = document.getElementsByClassName("basket-button");
  for (var i = 0; i < addCart.length; i++) {
    let button = addCart[i];
    button.addEventListener("click", addToCart);
  }
}

// add to cart
function addToCart(event) {
  const button = event.target;
  const product = button.parentElement.parentElement;
  const title = product.getElementsByClassName("title")[0].innerText;
  const price = product.getElementsByClassName("price")[0].innerText;
  const image = product.getElementsByClassName("product-image")[0].src;
  const productId = product.id;
  const cartItem = document.getElementsByClassName("cart-list")[0];
  const cartcontent = cartItem.getElementsByClassName("cart-box");
  for (var i = 0; i < cartcontent.length; i++) {
    if (cartcontent[i].id === productId) {
      return;
    }
  }
  cartButton.classList.add("active");
  addProductToCart(title, price, image, productId);
}
function addProductToCart(title, price, image, id) {
  const cartShopBox = document.createElement("div");
  cartShopBox.classList.add("cart-content");
  const cartItems = document.getElementsByClassName("cart-list")[0];
  const productTitle = cartItems.getElementsByClassName("product-title");
  const content = `
  <div class="cart-box" id="${id}">
    <div class="remove-cart-item">
      <i class="fas fa-trash-alt"></i>
    </div>
    <div class="cart-image">
      <img src="${image}" alt="" />
    </div>
    <div class="cart-box-text">
      <div class="product-title">${title}</div>
      <div class="product-price">${price}</div>
    </div>
    <input
      type="number"
      min="1"
      max="50"
      name="quantity"
      maxlength="2"
      value="1"
      class="cart-quantity"
    />
  </div>

  `;
  cartShopBox.innerHTML = content;
  cartItems.append(cartShopBox);
  cartShopBox
    .getElementsByClassName("remove-cart-item")[0]
    .addEventListener("click", removeCartItem);
  cartShopBox
    .getElementsByClassName("cart-quantity")[0]
    .addEventListener("change", quantityChanged);
  // for (var i = 0; i < productTitle.length; i++) {
  //   console.log(productTitle[i].innerText);
  // }
}

function saveConfigs() {
  Notification("Your settings have been saved", "success");
  const toggleText = document.querySelector("#toggle-text-color");
  const desktopicons = document.querySelector(".desktopicons");
  if (toggleText.checked) {
    desktopicons.classList.add("toggletext");
  } else {
    desktopicons.classList.remove("toggletext");
  }
  wallpaper();
}

// quantity change
function quantityChanged(event) {
  const input = event.target;
  if (isNaN(input.value) || input.value <= 0) {
    input.value = 1;
  }
  updateTotalPrice();
}
// function to remove cart item
function removeCartItem(event) {
  const buttonClicked = event.target;
  buttonClicked.parentElement.parentElement.parentElement.remove();
  updateTotalPrice();
}
// function to update total price
function updateTotalPrice() {
  const cartContent = document.getElementsByClassName("cart-list")[0];
  if (!cartContent) {
    return (document.getElementsByClassName("total-price")[0].innerText = "$0");
  }
  const cartBox = cartContent.getElementsByClassName("cart-box");
  if (cartBox.length == 0) {
    cartButton.classList.remove("active");
    cart.classList.remove("active");
    store.classList.add("active");
    return (document.getElementsByClassName("total-price")[0].innerText = "$0");
  }
  let total = 0;
  for (var i = 0; i < cartBox.length; i++) {
    const cartBoxes = cartBox[i];

    const priceElement = cartBoxes.getElementsByClassName("product-price")[0];
    const price = parseFloat(priceElement.innerText.replace("$", ""));
    const quantityElement =
      cartBoxes.getElementsByClassName("cart-quantity")[0];
    const quantity = quantityElement.value;
    total = total + price * quantity;
    document.getElementsByClassName("total-price")[0].innerText = "$" + total;
  }
}

function checkout() {
  const list = [];
  const total = parseFloat(
    document.getElementsByClassName("total-price")[0].innerText.replace("$", "")
  );
  const itemList = document.getElementsByClassName("cart-list")[0];
  const item = itemList.getElementsByClassName("cart-content");
  if (item.length == 0) return;
  for (let i = 0; i < item.length; i++) {
    const itemcart = item[i];
    const quantity = itemcart.getElementsByClassName("cart-quantity")[0].value;
    const items = itemcart.getElementsByClassName("cart-box")[0].id;
    list.push({
      item: items,
      quantity: quantity,
    });
  }
  $.post("https://jl-carboost/checkout", JSON.stringify({ list, total }));
}

function checkoutSuccess() {
  const itemList = document.getElementsByClassName("cart-list")[0];
  itemList.innerHTML = "";
  Notification("Your order is succesfully placed", "success");
  updateTotalPrice();
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

function refreshBennys() {}

function wait(ms) {
  return new Promise((resolve, reject) => {
    setTimeout(() => {
      resolve();
    }, ms);
  });
}

function randomMessage() {
  const message = [
    "Hey, how are you doing today?",
    "I'm glad you're here!",
    "I hope you're having a good day!",
    "I hope you're having a great day!",
    "I hope you're having a wonderful day!",
    // random long fact
    "I'm a software engineer, and I'm passionate about building things that make people's lives better.",
  ];
  const random = Math.floor(Math.random() * message.length);
  Notification(message[random]);
}

function Notification(text, style, length) {
  let icon;
  if (style === "success") {
    style = "success";
    icon = "fas fa-circle-check";
  } else if (style === "warning") {
    style = "warning";
    icon = "fas fa-exclamation-triangle";
  } else if (style === "error") {
    style = "error";
    icon = "fas fa-times-circle";
  } else if (style === "info") {
    style = "info";
    icon = "fas fa-bell";
  } else {
    style = "info";
    icon = "fas fa-bell";
  }
  length = length || 3 * 1000; // <- 3 seconds
  const notification = document.getElementsByClassName("notification")[0];
  const notificationText = document.createElement("div");
  const audio = new Audio("assets/audio/pop.wav");
  const out = new Audio("assets/audio/out.wav");
  notificationText.className = `alert ${style}`;
  notificationText.innerHTML = `<span class="${icon}"></span>
          <span class="message"
            >${text}</span
          >
          <span class="close-btn">
            <span class="fas fa-times"></span>
          </span>`;
  notificationText.classList.add("active");
  audio.volume = volumeValue;
  out.volume = 0.2;
  if (!isMuted) {
    audio.play();
  }

  notification.append(notificationText);
  notificationText
    .getElementsByClassName("close-btn")[0]
    .addEventListener("click", () => {
      notificationText.remove();
      audio.remove();
    });
  setTimeout(async () => {
    notificationText.classList.add("hide");
    notificationText.classList.remove("active");
  }, length);
  notificationText.onanimationend = (e) => {
    if (e.animationName === "sliding_back") {
      notificationText.remove();
      audio.remove();
    }
  };
}

function wallpaper() {
  let value = $("#background")[0].value;
  if (
    (value.startsWith("https://") && value.endsWith(".jpg")) ||
    value.endsWith(".png")
  ) {
    $(".laptop").css("background-image", `url(${value})`);
  } else if (!value) {
    return;
  } else {
    return Notification("Please enter a valid URL", "error");
  }
}

function loadBennysApp() {
  fetch("https://jl-carboost/loadstore", {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
    },
    body: JSON.stringify({
      storeitem: item,
    }),
  }).then((resp) =>
    resp.json().then((resp) => {
      // $(".loading").css("opacity", "1");
      storedata = resp.storeitem;
      if (storedata) {
        storedata.forEach((data) => {
          item.splice(0, item.length);
          if (data.name.length < 2 || !data.price || !data.image) return;
          const article = document.createElement("article");
          article.id = data.item;
          article.innerHTML = `<img class="product-image" src="./assets/shop/${data.image}" alt="${data.name}" />
            <div class="text">
              <h3 class="title">${data.name}</h3>
              <p>Stock: <b>${data.stock}</b></p>
              <p class="price">$${data.price}</p>
              <button class="basket-button">Add to basket</button>
            </div>
            `;
          store.append(article);
          item.push(article.tagName);
        });
        setTimeout(() => {
          $(".loading").css("opacity", "0");
          store.classList.add("active");
          uglyFunct();
        }, 500);
      } else {
        const error = document.createElement("div");
        error.innerHTML = `<h1>Error</h1>`;
        $(".grid").append(error);
      }
    })
  );
}
