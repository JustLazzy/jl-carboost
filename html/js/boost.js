let progressBar = document.querySelector(".prog");
let boostpercent = document.getElementById("boosting-progress");
let boosting = document.querySelector("#boosting-app");
let isJoined = false;
let queueButton = document.querySelector(".join-queue");
let mycontractbutton = document.querySelector(".my-contract");
let buycontractbutton = document.querySelector(".buy-contract");
let contractPage = document.getElementById("boosting-contract");
let shopPage = document.getElementById("boosting-shop");

$(document).ready(function () {
  // loadBoostData();
  boostingheader = boosting.querySelector("header");
  boostingheader.addEventListener("mousedown", () => {
    boostingheader.classList.add("active");
    boostingheader.addEventListener("mousemove", onDrag);
  });
  document.addEventListener("mouseup", (e) => {
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
    // console.log("TEST");
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
  // console.log(currentVal, toVal);
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
  let boostingList = document.querySelector("#boosting-contract");
  let noContractTitle = boostingList.getElementsByClassName("title");
  fetch("https://jl-carboost/setupboostapp", {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
    },
    body: JSON.stringify({}),
  }).then((resp) =>
    resp.json().then((resp) => {
      const data = resp.boostdata;
      const contract = data.contract;
      const title = document.querySelector("#no-contract");
      let currentClass = document.querySelector("#currentclass");
      let nextClass = getNextClass(data.class);
      let nextClassElement = document.querySelector("#nextclass");
      currentClass.textContent = data.class;
      nextClassElement.textContent = nextClass;
      if (contract) {
        for (let i = 0; i < contract.length; i++) {
          const contractdata = contract[i];

          let interval = 1000;
          console.log(contractdata);
          const contractParent = document.getElementById("boosting-contract");
          const contractCart = document.createElement("div");
          contractCart.id = contractdata.id;
          contractCart.classList.add("boost-contract");
          contractCart.innerHTML = `<div class="boost-text">
          <p id="boost-type">Boost Type: <b>${contractdata.tier}</b></p>
          <p>Owner: ${contractdata.owner}</p>
        </div>
        <div class="boost-info">
          <p>Vehicle: <b>${contractdata.carname} [${contractdata.plate}]</b></p>
          <p class="expire">Expires in: </p>
        </div>
        <div class="boost-button">
          <button id="startcontract" class="start">Start Contract</button>
          <button class="transfer">Transfer Contract</button>
          <button class="sell">Sell Contract</button>
        </div>
          `;
          let startbutton = contractCart.querySelector("#startcontract");
          let transferButton = contractCart.querySelector(".transfer");
          let sellButton = contractCart.querySelector(".sell");
          let expireText = contractCart.querySelector(".expire");
          let exp = setInterval(function () {
            let expireDate = new Date(contractdata.expire).getTime();
            let now = new Date().getTime();
            let diff = expireDate - now;
            let second = 1000;
            let minute = second * 60;
            let hour = minute * 60;
            let textHour = Math.floor(diff / hour);
            let textMinute = Math.floor((diff % hour) / minute);
            let textSecond = Math.floor((diff % minute) / second);
            expireText.textContent =
              "Expires in: " +
              textHour.toString().padStart(2, "0") +
              ":" +
              textMinute.toString().padStart(2, "0") +
              ":" +
              textSecond.toString().padStart(2, "0");

            if (diff < 0) {
              clearInterval(exp);
              contractCart.remove();
            }
          }, interval);
          startbutton.addEventListener("click", toggleBoosting);
          sellButton.addEventListener("click", sellContract);
          contractParent.appendChild(contractCart);
          noTitleContract();
        }
      }

      noTitleContract();
      let color;
      boostProgress(0, data.rep);
    })
  );
}

function noTitleContract() {
  let title = document.querySelector("#no-contract");
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

function setupNewContract(data) {
  const title = document.querySelector("#no-contract");
  if (!title.classList.contains("hidden")) title.classList.add("hidden");
  const contractParent = document.getElementById("boosting-contract");
  const contractCart = document.createElement("div");

  contractCart.classList.add("boost-contract");
  contractCart.id = data.id;
  contractCart.innerHTML = `<div class="boost-text">
          <p id="boost-type">Boost Type: <b>${data.tier}</b></p>
          <p>Owner: ${data.owner}</p>
        </div>
        <div class="boost-info">
          <p>Vehicle: <b>${data.carname} [${data.plate}]</b></b></p>
          <p class="expire"></p>
        </div>
        <div class="boost-button">
          <button id="startcontract" class="start">Start Contract</button>
          <button class="transfer">Transfer Contract</button>
          <button class="sell" id="sellcontract">Sell Contract</button>
        </div>
          `;
  let transferButton = contractCart.querySelector(".transfer");
  let startbutton = contractCart.querySelector("#startcontract");
  let sellButton = contractCart.querySelector("#sellcontract");
  let expireText = contractCart.querySelector(".expire");
  let exp = setInterval(function () {
    let expireDate = new Date(data.expire).getTime();
    let now = new Date().getTime();
    let diff = expireDate - now;
    let second = 1000;
    let minute = second * 60;
    let hour = minute * 60;
    let textHour = Math.floor(diff / hour);
    let textMinute = Math.floor((diff % hour) / minute);
    let textSecond = Math.floor((diff % minute) / second);
    expireText.textContent =
      "Expires in: " +
      textHour.toString().padStart(2, "0") +
      ":" +
      textMinute.toString().padStart(2, "0") +
      ":" +
      textSecond.toString().padStart(2, "0");

    if (diff < 0) {
      clearInterval(exp);
      contractCart.remove();
    }
  }, 1000);

  contractParent.appendChild(contractCart);
  console.log(sellButton);
  startbutton.addEventListener("click", toggleBoosting);
  // transferButton.addEventListener("click", transferContract);
  sellButton.addEventListener("click", sellContract);
}

function transferContract(data) {
  // let contractId = event.target.parentNode.parentNode.id;
  // fetch(`https://jl-carboost/transfercontract`, {
  //   method: "POST",
  //   headers: {
  //     "Content-Type": "application/json",
  //   },
  //   body: JSON.stringify({
  //     data: data,
  //   }),
  // }).then((resp) =>
  //   resp.json().then((resp) => {
  //     if (resp.success) {
  //       event.target.parentNode.parentNode.remove();
  //       noTitleContract();
  //     }
  //   })
  // );
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
            console.log(resp);
            // if (resp.success) {
            //   contractElement.remove();
            //   noTitleContract();
            // }
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
      onCancel: () => {
        console.log("CANCELLED");
      },
    });
  } else {
    let type;
    Confirm.open({
      title: "Options",
      message: "If you choose VIN Scratch, you have to pay more",
      okText: "VIN Scratch",
      cancelText: "Normal",
      parentID: "boosting-contract",
      onOk: () => checkCanStart("vin"),
      onCancel: () => checkCanStart("normal"),
    });
    function checkCanStart(type) {
      console.log(type);
      fetch("https://jl-carboost/canStartContract", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify({}),
      }).then((resp) => {
        resp.json().then((resp) => {
          if (resp.canStart) {
            let data = {
              id: parent.id,
              type: type,
            };
            Notification("Contract Started", "success");
            buttonClicked.innerText = "End Contract";
            startContract(data);
          } else {
            Notification(resp.error, "error");
          }
        });
      });
    }
  }
}

function startContract(data) {
  // console.log(JSON.stringify(data));
  $.post("https://jl-carboost/startcontract", JSON.stringify({ data: data }));
}

function stopContract(data) {
  $.post("https://jl-carboost/stopcontract", JSON.stringify({ id: data }));
}

function removeContract(id) {
  let contractParent = document.getElementById("boosting-contract");
  let contractCart = document.getElementById(id);
  if (contractCart) {
    contractCart.remove();
    Notification("You have done your contract", "success");
    let contractList = contractParent.getElementsByClassName("boost-contract");
    if (contractList.length === 0) {
      let title = document.querySelector("#no-contract");
      title.classList.remove("hidden");
    }
  }
}

function refreshContract() {
  let boostingList = document.querySelector("#boosting-contract");
  boostingList.innerHTML = "";
  fetch("https://jl-carboost/getcontract", {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
    },
    body: JSON.stringify({}),
  }).then((resp) => {
    resp.json().then((resp) => {
      console.log(JSON.stringify(resp));
    });
  });
}

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

function countDown(hour, element) {}
