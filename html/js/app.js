const item = [];
let typing;
index = 0;
const storeloaded = false;

let laptop = document.querySelector(".laptop");
let volumebutton = document.querySelector("#volume");
let testing = document.querySelector(".buttontest");
let settingButton = document.querySelector("#setting");
let volumecontrol = document.getElementById("volume-control");
let saveConfig = document.querySelector(".save-config");
const setting = document.querySelector("#settings");
let isMuted = false;
let volumeValue = (50 / 200).toFixed(2);

$(document).ready(() => {
  if (index >= 2) {
    index = 0;
  }
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

  $("input").keypress(function (e) {
    typing = true;
  });

  window.addEventListener("message", function (event) {
    switch (event.data.type) {
      case "openlaptop":
        if (event.data.status == true) {
          display(true);
        } else {
          display(false);
        }
        break;
      case "checkout":
        if (event.data.success == true) {
          checkoutSuccess();
        } else {
          Notification("You don't have enough money", "error");
        }
        break;
      case "config":
        console.log();
        setConfig(event.data.config);
        break;
      case "addcontract":
        setupNewContract(event.data.boost);
        break;
      case "removeContract":
        removeContract(event.data.id);
        break;
      case "setupboostingapp":
        loadBoostData();
        break;
      case "setupboostingstore":
        loadBoostStore(event.data.store);
        break;
      case "refreshContract":
        refreshContract();
        break;
      case "updateProggress":
        updateBoostProgress(event.data.boost);
        break;
      case "newContractSale":
        newContractSale(event.data.sale);
        break;
      case "contractbought":
        contractBought(event.data.id);
        break;
    }
  });

  saveConfig.onclick = () => {
    saveConfigs();
  };

  volumecontrol.onchange = (e) => {
    const input = e.target;
    volumeValue = (input.value / 200).toFixed(2);

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
    if (setting.classList.contains("active")) {
      setting.classList.remove("active");
    } else {
      setting.classList.add("active");
    }
  };

  window.addEventListener("click", function (event) {
    if (event.target.id != "splash") {
      if (event.target.id == "bennys") {
        if (bennys.classList.contains("active")) {
          return;
        }
        toggleDisplayApp(true, "#bennys-app");
        createIcon(event.target.id);
      } else if (event.target.id == "boosting") {
        if (boosting.classList.contains("active")) return;
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
        } else if (boosting.classList.contains("active")) {
          toggleDisplayApp(false, "#boosting-app");
          removeIcon("boost");
        } else if (setting.classList.contains("active")) {
          setting.classList.remove("active");
        } else {
          $.post("https://jl-carboost/exit", JSON.stringify({}));
        }
        break;
    }
  };
});

function saveConfigs() {
  wallpaper();
  Notification("Your settings have been saved", "success");
  const toggleText = document.querySelector("#toggle-text-color");
  const desktopicons = document.querySelector(".desktopicons");
  if (toggleText.checked) {
    desktopicons.classList.add("toggletext");
  } else {
    desktopicons.classList.remove("toggletext");
  }
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
    setTimeout(() => {
      $(id).css("transition", "0s");
    }, 500);
    return;
  } else if (!bool && id != null) {
    app.classList.remove("active");
    $(id).css("transition", "0.5s");
    return;
  }
}

// Refresh time
setInterval(refreshTime, 1000);
function timePMAM(date) {
  return date.toLocaleString("en-US", {
    hour12: true,
    hour: "numeric",
    minute: "numeric",
  });
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
  if (!laptop.classList.contains("active")) {
    laptop.classList.add("notification");
  }
  setTimeout(async () => {
    notificationText.classList.add("hide");
    notificationText.classList.remove("active");
    laptop.classList.remove("notification");
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
    $.post(
      "https://jl-carboost/wallpaper",
      JSON.stringify({
        wallpaper: value,
      })
    );
  } else {
    return;
  }
}

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

var Confirm = {
  open(options) {
    options = Object.assign(
      {},
      {
        title: "",
        message: "",
        okText: "",
        cancelText: "",
        onOk: function () {},
        onCancel: function () {},
        parentID: "",
      },
      options
    );
    const html = `
    <div class="confirm">
    <div class="confirm-window">
      <div class="confirm-titlebar">
        <span class="confirm-title">${options.title}</span>
        <span class="confirm-exit"
          ><i
            class="fa-solid fa-circle-xmark"
            style="color: rgb(245, 105, 105)"
          ></i
        ></span>
      </div>
      <div class="confirm-content">
      ${options.message}
      </div>
      <div class="confirm-button">
        <button class="confirm-button-style confirm-button--ok">
        ${options.okText}
        </button>
        <button class="confirm-button-style confirm-button--cancel">
          ${options.cancelText}
        </button>
      </div>
    </div>
  </div>
    `;
    const template = document.createElement("template");
    const audio = new Audio("assets/audio/pop.wav");
    template.innerHTML = html;
    const ConfirmEl = template.content.querySelector(".confirm");
    const closeBtn = template.content.querySelector(".confirm-exit");
    const okBtn = template.content.querySelector(".confirm-button--ok");
    const cancelBtn = template.content.querySelector(".confirm-button--cancel");
    const parent = document.querySelector(`#${options.parentID}`);
    if (parent) {
      if (!isMuted) {
        audio.play();
        audio.volume = volumeValue;
      }
      parent.appendChild(template.content);
      ConfirmEl.addEventListener("click", (e) => {
        if (e.target === ConfirmEl) {
          // options.onCancel();
          this._close(ConfirmEl);
        }
      });
      closeBtn.addEventListener("click", () => {
        this._close(ConfirmEl);
      });
      okBtn.addEventListener("click", () => {
        options.onOk();
        this._close(ConfirmEl);
      });
      cancelBtn.addEventListener("click", () => {
        options.onCancel();
        this._close(ConfirmEl);
      });
    }
    // document.body.appendChild(template.content);
  },
  Input(options) {
    options = Object.assign(
      {},
      {
        title: "",
        message: "",
        placeholder: "",
        type: "",
        min: "1",
        max: "",
        onOk: function () {},
        onCancel: function () {},
        parentID: "",
      },
      options
    );
    const html = `
    <div class="confirm">
    <div class="confirm-window">
      <div class="confirm-titlebar">
        <span class="confirm-title">${options.title}</span>
        <span class="confirm-exit"
          ><i
            class="fa-solid fa-circle-xmark"
            style="color: rgb(245, 105, 105)"
          ></i
        ></span>
      </div>
      <div class="confirm-content">
      ${options.message}
      </div>
      <div class="confirm-content--input">
      <input placeholder="${options.placeholder}" type="${options.type}" class="confirm--input" min="${options.min}" max="${options.max}" />
      </div>
      <div class="confirm-button">
        <button class="confirm-button-style confirm-button--ok">
        ${options.okText}
        </button>
        <button class="confirm-button-style confirm-button--cancel">
          ${options.cancelText}
        </button>
      </div>
    </div>
  </div>`;
    const template = document.createElement("template");
    const audio = new Audio("assets/audio/pop.wav");
    template.innerHTML = html;
    const ConfirmEl = template.content.querySelector(".confirm");
    const input = template.content.querySelector(".confirm--input");
    const closeBtn = template.content.querySelector(".confirm-exit");
    const okBtn = template.content.querySelector(".confirm-button--ok");
    const cancelBtn = template.content.querySelector(".confirm-button--cancel");
    const parent = document.querySelector(`#${options.parentID}`);
    if (parent) {
      if (!isMuted) {
        audio.play();
        audio.volume = volumeValue;
      }
      parent.appendChild(template.content);
      ConfirmEl.addEventListener("click", (e) => {
        if (e.target === ConfirmEl) {
          // options.onCancel();
          this._close(ConfirmEl);
        }
      });
      okBtn.addEventListener("click", () => {
        options.onOk(input.value);
        this._close(ConfirmEl);
      });
      closeBtn.addEventListener("click", () => {
        this._close(ConfirmEl);
      });
      cancelBtn.addEventListener("click", () => {
        options.onCancel();
        this._close(ConfirmEl);
      });
    }
  },
  _close(confirmElemnt) {
    confirmElemnt.classList.add("confirm--close");
    setTimeout(() => {
      confirmElemnt.remove();
    }, 100);
  },
};

function setConfig(data) {
  if (data.wallpaper === "default" || data.wallpaper === "") {
    // $(".laptop").css("background-image", "url(assets/img/wallpaper.jpg)");
    return;
  } else {
    $(".laptop").css("background-image", `url(${data.wallpaper})`);
  }
}
