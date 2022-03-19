let cartButton = document.querySelector(".cart-button");
let cart = document.querySelector(".cart");
let homeButton = document.querySelector(".home-button");
let checkoutbutton = document.querySelector(".buy-button");
let store = document.querySelector(".grid");
let bennys = document.querySelector("#bennys-app");
$(document).ready(function () {
  bennysheader = bennys.querySelector("header");
  bennysheader.addEventListener("mousedown", () => {
    bennysheader.classList.add("active");
    bennysheader.addEventListener("mousemove", onDrag);
  });
  document.addEventListener("mouseup", (e) => {
    bennysheader.classList.remove("active");
    bennysheader.removeEventListener("mousemove", onDrag);
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

  loadBennysApp();
});

function loadBennysApp() {
  fetch("https://jl-carboost/loadstore", {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
    },
    body: JSON.stringify({}),
  }).then((resp) =>
    resp.json().then((resp) => {
      const storedata = resp.storeitem;
      // console.log(JSON.stringify(storedata));
      if (storedata) {
        storedata.forEach((data) => {
          const article = document.createElement("article");
          article.id = data.item;
          article.innerHTML = `<img class="product-image" src="nui://${data.image}" alt="${data.name}" />
              <div class="text">
                <h3 class="title">${data.name}</h3>
                <p>Stock: <b>${data.stock}</b></p>
                <p class="price">$${data.price}</p>
                <button class="basket-button">Add to basket</button>
              </div>
              `;
          let addCart = article.getElementsByClassName("basket-button");
          addCart[0].addEventListener("click", addToCart);
          store.append(article);
          item.push(article.tagName);
        });
      } else {
        const error = document.createElement("div");
        error.innerHTML = `<h1>Error</h1>`;
        $(".grid").append(error);
      }
    })
  );
}

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

function closeBennys() {
  store.classList.remove("active");
  removeIcon("bennys");
}
