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

  // make a wait function

  function display(bool) {
    // bool = true;
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
      $(id).css("z-index", index++);
      // $(id).css("visibility", "visible");
      // $(id).css("opacity", "100%");

      setTimeout(() => {
        $(id).css("transition", "0s");
      }, 500);
      return;
    } else if (!bool && id != null) {
      app.classList.remove("active");
      $(id).css("z-index", "0");
      $(id).css("transition", "0.5s");
      // $(id).css("visibility", "hidden");
      // $(id).css("opacity", "0");
      index - 1;
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
        console.log("TRUE");
      } else {
        console.log("FALSE");
      }
    }
  });

  // $(document).click(function (e) {
  //   e.preventDefault();
  //   console.log(JSON.stringify(e));
  // });

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
    // console.log(event.key);
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
      case "Backspace":
        $.post("https://jl-carboost/exit", JSON.stringify({}));
        break;
    }
  };
});

function uglyFunct() {
  var removeCartButtons = document.getElementsByClassName("remove-cart-item");
  // console.log("ini cart remove", removeCartButtons);
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
  // console.log(addCart.length);
  // console.log(addCart);
  for (var i = 0; i < addCart.length; i++) {
    let button = addCart[i];
    // console.log("ini button:", button);
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

  for (var i = 0; i < productTitle.length; i++) {
    console.log(productTitle[i].innerText);
  }
}

// quantity change
function quantityChanged(event) {
  const input = event.target;
  console.log("ini input", input.value);
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
  if (item.length == 0) {
    return console.log("NO ITEM");
  }
  for (let i = 0; i < item.length; i++) {
    const itemcart = item[i];
    const quantity = itemcart.getElementsByClassName("cart-quantity")[0].value;
    const items = itemcart.getElementsByClassName("cart-box")[0].id;
    list.push({
      item: items,
      quantity: quantity,
    });
  }
  console.log(list, total);
  $.post("https://jl-carboost/checkout", JSON.stringify({ list, total }));
}

function checkoutSuccess() {}

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
