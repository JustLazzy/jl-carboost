let progressBar = document.querySelector(".prog");
let boostpercent = document.getElementById("boosting-progress");
let boosting = document.querySelector("#boosting-app");
let isJoined = false;
let queueButton = document.querySelector(".join-queue");
let mycontractbutton = document.querySelector(".my-contract");
let buycontractbutton = document.querySelector(".buy-contract");
let contractPage = document.getElementById("boosting-contract");
let shopPage = document.getElementById("boosting-shop");
let Payment;

$(document).ready(function () {
  boostingheader = boosting.querySelector("header");
  boostingheader.addEventListener("mousedown", () => {
    boostingheader.classList.add("active");
    boostingheader.addEventListener("mousemove", onDrag);
  });
  document.addEventListener("mouseup", () => {
    boostingheader.classList.remove("active");
    boostingheader.removeEventListener("mousemove", onDrag);
  });

  queueButton.onclick = () => {
    toggleQueue();
  };

  mycontractbutton.onclick = () => {
    if (!shopPage.classList.contains("hidden")) {
      shopPage.classList.add("hidden");
      contractPage.classList.remove("hidden");
    }
  };
  buycontractbutton.onclick = () => {
    if (!contractPage.classList.contains("hidden")) {
      contractPage.classList.add("hidden");
      shopPage.classList.remove("hidden");
    }
  };
});

function toggleQueue() {
  const loadingicon = document.createElement("i");
  loadingicon.className = "fas fa-rotate fa-spin";
  loadingicon.style.fontSize = "15px";
  if (queueButton.textContent == "Join Queue") {
    queueButton.textContent = "";
    queueButton.appendChild(loadingicon);
    setTimeout(() => {
      loadingicon.remove();
      queueButton.textContent = "Exit Queue";
      Notification("You have joined the queue", "info");
      $.post(
        "https://jl-carboost/joinqueue",
        JSON.stringify({
          status: true,
        })
      );
    }, 3000);
  } else {
    queueButton.textContent = "";
    queueButton.appendChild(loadingicon);
    setTimeout(() => {
      loadingicon.remove();
      queueButton.textContent = "Join Queue";
      Notification("You have left the queue", "info");
      $.post(
        "https://jl-carboost/joinqueue",
        JSON.stringify({
          status: false,
        })
      );
    }, 3000);
  }
}

function boostProgress(currentVal, toVal) {
  if (currentVal == "current") {
    currentVal = boostpercent.style.width.replace("%", "");
  }
  if (toVal === 0) {
    return (boostpercent.style.width = 0 + "%");
  } else {
    let progBar = setInterval(() => {
      currentVal++;
      boostpercent.style.width = currentVal + "%";
      if (currentVal == toVal) {
        clearInterval(progBar);
      }
    }, 100);
  }
}

function updateBoostProgress(data) {
  let currentClass = document.querySelector("#currentclass");
  if (data.isNextLevel === true) {
    boostProgress(0, data.rep);
  } else {
    boostProgress("current", data.rep);
  }
  currentClass.textContent = data.boostclass;
  updateClasses();
}

function loadBoostData() {
  fetch("https://jl-carboost/setupboostapp", {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
    },
    body: JSON.stringify({}),
  }).then((resp) =>
    resp.json().then((resp) => {
      let settings = resp.setting;
      Payment = settings.payment;
      const data = resp.boostdata;
      const contract = data.contract;
      let currentClass = document.querySelector("#currentclass");
      let nextClass = getNextClass(data.class);
      let nextClassElement = document.querySelector("#nextclass");
      currentClass.textContent = data.class;
      nextClassElement.textContent = nextClass;
      noTitleContract();
      if (contract) {
        for (let i = 0; i < contract.length; i++) {
          const contractdata = contract[i];
          const contractParent = document.getElementById("boosting-contract");
          const contractCart = document.createElement("div");
          contractCart.id = contractdata.id;
          contractCart.classList.add("boost-contract");
          contractCart.innerHTML = `<div class="boost-text">
          <p id="boost-type" data-tier="${contractdata.tier}"> Boost Type: <b">${contractdata.tier}</b></p>
          <p>Owner: ${contractdata.owner}</p>
        </div>
        <div class="boost-info">
          <p>Vehicle: <b>${contractdata.carname} [${contractdata.plate}]</b></p>
          <p class="expire">Expires in: </p>
        </div>
        <div class="boost-button">
          <button id="startcontract" data-vinprice="${contractdata.vinprice}" class="start">Start Contract</button>
          <button class="transfer" id="transfercontract">Transfer Contract</button>
          <button class="sell">Sell Contract</button>
        </div>
          `;
          let startbutton = contractCart.querySelector("#startcontract");
          let transferButton = contractCart.querySelector("#transfercontract");
          let sellButton = contractCart.querySelector(".sell");
          countDown(contractdata.expire, contractCart);
          startbutton.addEventListener("click", toggleBoosting);
          transferButton.addEventListener("click", transferContract);
          sellButton.addEventListener("click", sellContract);
          contractParent.appendChild(contractCart);
        }
      }
      noTitleContract();
      boostProgress(0, data.rep);
    })
  );
}

function loadBoostStore(data) {
  let boostshoplist = document.querySelector("#boosting-shop");
  for (let i = 0; i < data.length; i++) {
    const boostdata = data[i];
    let saleDiv = document.createElement("div");
    saleDiv.id = boostdata.id;
    saleDiv.classList.add("boost-contract");
    saleDiv.innerHTML = `
    <div class="boost-text">
    <p>Boost Type: <b>${boostdata.tier}</b></p>
    <p>Owner: ${boostdata.owner}</p>
  </div>
  <div class="boost-info">
    <p>Vehicle: ${boostdata.carname} [${boostdata.plate}]</p>
    <p class="expire">Expires in: </p>
    <p>Price: ${boostdata.price}</p>
  </div>
  <div class="boost-button">
    <button class="start" id="buy-contract">
      Buy Contract
    </button>
  </div>
    `;
    let buyButton = saleDiv.querySelector("#buy-contract");
    buyButton.addEventListener("click", buyContract);
    countDown(boostdata.expire, saleDiv);
    boostshoplist.appendChild(saleDiv);
  }
  noTitleSale();
}

function newContractSale(data) {
  let boostdata = data;
  let boostshoplist = document.querySelector("#boosting-shop");
  let saleDiv = document.createElement("div");
  saleDiv.id = data.id;
  saleDiv.classList.add("boost-contract");
  saleDiv.innerHTML = `
  <div class="boost-text">
  <p>Boost Type: <b>${boostdata.tier}</b></p>
  <p>Owner: ${boostdata.owner}</p>
</div>
<div class="boost-info">
  <p>Vehicle: ${boostdata.carname} [${boostdata.plate}]</p>
  <p class="expire">Expires in: </p>
  <p>Price: ${boostdata.price}</p>
</div>
<div class="boost-button">
  <button class="start" id="buy-contract">
    Buy Contract
  </button>
</div>
  `;
  let buyButton = saleDiv.querySelector("#buy-contract");
  buyButton.addEventListener("click", buyContract);
  countDown(boostdata.expire, saleDiv);
  boostshoplist.appendChild(saleDiv);
}

function buyContract(event) {
  Confirm.open({
    title: "Buy Contract",
    message: "Are you sure you want to buy this contract?",
    okText: "Yes",
    cancelText: "No",
    onOk: () => {
      fetch("https://jl-carboost/buycontract", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify({
          id: event.target.parentElement.parentElement.id,
        }),
      }).then((resp) =>
        resp.json().then((resp) => {
          if (resp.success) {
            Notification(resp.success, "success");
            noTitleSale();
          } else {
            Notification(
              resp.error
                ? resp.error
                : "Something wrong, contact your developer",
              "error"
            );
          }
        })
      );
    },
    onCancel: () => {},
    parentID: "boosting-shop",
  });
}

function noTitleContract() {
  let title = document.getElementById("no-contract");
  let contractParent = document.getElementById("boosting-contract");
  let contractList = contractParent.getElementsByClassName("boost-contract");
  if (contractList.length == 0) {
    if (title.classList.contains("hidden")) {
      title.classList.remove("hidden");
    }
  } else {
    if (!title.classList.contains("hidden")) {
      title.classList.add("hidden");
    }
  }
}

function noTitleSale() {
  let title = document.querySelector("#no-contract-sale");
  let contractParent = document.getElementById("boosting-shop");
  let contractList = contractParent.getElementsByClassName("boost-contract");
  if (contractList.length == 0) {
    if (title.classList.contains("hidden")) {
      title.classList.remove("hidden");
    }
  } else {
    if (!title.classList.contains("hidden")) {
      title.classList.add("hidden");
    }
  }
}

function setupNewContract(data) {
  const contractParent = document.getElementById("boosting-contract");
  const contractCart = document.createElement("div");
  contractCart.classList.add("boost-contract");
  contractCart.id = data.id;
  contractCart.innerHTML = `<div class="boost-text">
  <p id="boost-type" data-tier="${data.tier}">Boost Type: <b>${data.tier}</b></p>
  <p>Owner: ${data.owner}</p>
  </div>
  <div class="boost-info">
  <p>Vehicle: <b>${data.carname} [${data.plate}]</b></b></p>
  <p class="expire"></p>
        </div>
        <div class="boost-button">
          <button id="startcontract" data-vinprice="${data.vinprice}" class="start">Start Contract</button>
          <button class="transfer" id="transfercontract">Transfer Contract</button>
          <button class="sell" id="sellcontract">Sell Contract</button>
          </div>
          `;
  let transferButton = contractCart.querySelector("#transfercontract");
  let startbutton = contractCart.querySelector("#startcontract");
  let sellButton = contractCart.querySelector("#sellcontract");
  countDown(data.expire, contractCart);
  contractParent.appendChild(contractCart);
  startbutton.addEventListener("click", toggleBoosting);
  transferButton.addEventListener("click", transferContract);
  sellButton.addEventListener("click", sellContract);
  noTitleContract();
}

function transferContract(event) {
  const contractCart = event.target.parentElement.parentElement;
  Confirm.Input({
    title: "Transfer Contract",
    message:
      "Enter the player id of the player you want to transfer the contract to.",
    placeholder: "Player ID",
    onOk: function (value) {
      if (!value) {
        return Notification("Please enter a player id.", "error");
      }
      fetch("https://jl-carboost/transfercontract", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify({
          id: value,
          contractid: contractCart.id,
        }),
      }).then((res) =>
        res.json().then((data) => {
          if (data.error) {
            return Notification(data.error, "error");
          } else if (data.success) {
            contractCart.remove();
            return Notification("Contract transfered.", "success");
          }
        })
      );
    },
    onCancel: function () {},
    okText: "Transfer",
    cancelText: "Cancel",
    parentID: "boosting-contract",
  });
}

function sellContract(event) {
  let contractElement = event.target.parentElement.parentElement;
  Confirm.Input({
    title: "Confirmation",
    message: "How much did you sell this contract for?",
    placeholder: "Enter amount",
    type: "number",
    okText: "Confirm",
    cancelText: "Cancel",
    onOk: (value) => {
      if (value) {
        fetch(`https://jl-carboost/sellcontract`, {
          method: "POST",
          headers: {
            "Content-Type": "application/json",
          },
          body: JSON.stringify({
            data: {
              id: contractElement.id,
              price: value,
            },
          }),
        }).then((resp) =>
          resp.json().then((resp) => {
            if (resp.success) {
              Notification(resp.success, "success");
              contractElement.remove();
              noTitleContract();
              noTitleSale();
            }
          })
        );
      } else {
        return Notification("Invalid value", "error");
      }
    },
    onCancel: () => {},
    parentID: "boosting-contract",
  });
}

function toggleBoosting(event) {
  let isStart;
  const buttonClicked = event.target;
  const parent = buttonClicked.parentElement.parentElement;
  const tier = parent.querySelector("#boost-type").dataset.tier;
  const amount = parent.querySelector("#startcontract").dataset.vinprice;
  if (buttonClicked.innerText === "Start Contract") {
    isStart = false;
  } else {
    isStart = true;
  }
  if (isStart) {
    Confirm.open({
      title: "Are you sure?",
      message: "Are you sure you want to stop this contract?",
      okText: "Yes",
      cancelText: "No",
      parentID: "boosting-contract",
      onOk: () => {
        Notification("Contract Ended", "error");
        buttonClicked.innerText = "Start Contract";
        stopContract(parent.id);
      },
      onCancel: () => {},
    });
  } else {
    Confirm.open({
      title: "Options",
      message: `If you choose VIN Scratch, you have to pay ${amount} (${Payment})`,
      okText: "VIN Scratch",
      cancelText: "Normal",
      parentID: "boosting-contract",
      onOk: () => checkCanStart("vin"),
      onCancel: () => checkCanStart("normal"),
    });
    function checkCanStart(type) {
      fetch("https://jl-carboost/canStartContract", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify({
          type: type,
          tier: tier,
        }),
      }).then((resp) => {
        resp.json().then((resp) => {
          if (resp.canStart) {
            let data = {
              id: parent.id,
              type: type,
              tier: tier,
            };
            Notification("Contract Started", "success");
            buttonClicked.innerText = "End Contract";
            startContract(data);
          } else {
            Notification(resp.error || "Something wrong", "error");
          }
        });
      });
    }
  }
}

function contractBought(id) {
  const parent = document.getElementById("boosting-shop");
  parent.removeChild(document.getElementById(id));
}

function startContract(data) {
  $.post("https://jl-carboost/startcontract", JSON.stringify({ data: data }));
}

function stopContract(data) {
  $.post("https://jl-carboost/stopcontract", JSON.stringify({ id: data }));
}

function removeContract(id) {
  let contractCart = document.getElementById(id);
  if (contractCart) {
    contractCart.remove();
    Notification("You have done your contract", "success");
  }
  noTitleContract();
}

function refreshContract() {}

function getNextClass(data) {
  let nextClass;
  switch (data) {
    case "D":
      nextClass = "C";
      break;
    case "C":
      nextClass = "B";
      break;
    case "B":
      nextClass = "A";
      break;
    case "A":
      nextClass = "S";
      break;
    case "S":
      nextClass = "S+";
      break;
    case "S+":
      nextClass = "MAX";
      break;
  }
  return nextClass;
}

function updateClasses() {
  let currentClass = document.querySelector("#currentclass");
  let nextClassElement = document.querySelector("#nextclass");
  let nextClass = getNextClass(currentClass.textContent);
  nextClassElement.textContent = nextClass;
}

function countDown(expire, element) {
  let expireText = element.querySelector(".expire");
  let exp = setInterval(() => {
    let expireDate = new Date(expire).getTime();
    let now = new Date().getTime();
    let distance = expireDate - now;
    let second = 1000;
    let minute = second * 60;
    let hour = minute * 60;
    let textHour = Math.floor(distance / hour);
    let textMinute = Math.floor((distance % hour) / minute);
    let textSecond = Math.floor((distance % minute) / second);
    expireText.textContent =
      "Expires in: " +
      textHour.toString().padStart(2, "0") +
      ":" +
      textMinute.toString().padStart(2, "0") +
      ":" +
      textSecond.toString().padStart(2, "0");
    if (distance <= 0) {
      clearInterval(exp);
      element.remove();
      noTitleContract();
    }
  }, 1000);
}

function refreshContract(event) {
  const loadingicon = document.createElement("i");
  loadingicon.className = "fas fa-rotate fa-spin";
  loadingicon.style.fontSize = "15px";
  event.innerText = "";
  event.appendChild(loadingicon);
  const contractParent = document.getElementById("boosting-contract");
  let toDelete = contractParent.getElementsByClassName("boost-contract");
  while (toDelete[0]) {
    toDelete[0].parentNode.removeChild(toDelete[0]);
  }
  setTimeout(() => {
    event.removeChild(loadingicon);
    event.innerText = "Refresh";
    Notification("Contracts updated", "success");
    loadBoostData();
  }, 3000);
}
