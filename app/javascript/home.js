console.log("✅ home.js 読み込まれました");

// ルーティン表示切替
window.showRoutine = function(childId, childName) {
  document.querySelectorAll(".child-routine-section").forEach(el => el.style.display = "none");
  const section = document.getElementById(`routine-${childId}`);
  if (section) section.style.display = "block";

  const header = document.getElementById("child-name-header");
  if (header) header.textContent = `${childName}ちゃんのルーティン`;

  const routineDataElement = document.getElementById(`routine-data-${childId}`);
  const footer = document.getElementById(`task-footer-${childId}`);
  if (!routineDataElement || !footer) return;

  const routineData = JSON.parse(routineDataElement.dataset.routine);
  const now = new Date();
  const nowMinutes = now.getHours() * 60 + now.getMinutes();

  function timeToMinutes(timeStr) {
    const [hour, minute] = timeStr.split(":").map(Number);
    return hour * 60 + minute;
  }

  let nextTask = "なし";
  for (const routine of routineData) {
    if (nowMinutes <= timeToMinutes(routine.time)) {
      nextTask = routine.task;
      break;
    }
  }

  footer.textContent = `今やるべきタスク：${nextTask}`;
};

// フォーム表示切替
window.toggleForm = function(childId) {
  const form = document.getElementById(`form-${childId}`);
  form.style.display = (form.style.display === "none" || form.style.display === "") ? "block" : "none";
};

// ✅ turbo:load：すべてまとめてここで定義
document.addEventListener("turbo:load", () => {
  // ✅ 共通：モーダルが閉じたら .alert 消す
  document.querySelectorAll(".modal").forEach(modalEl => {
    modalEl.addEventListener("hidden.bs.modal", () => {
      modalEl.querySelectorAll(".alert").forEach(alert => alert.remove());
    });
  });

  // ✅ 通常のモーダル表示（data-open-modal）
  const modalId = document.body.dataset.openModal;
  if (modalId) {
    const modalEl = document.getElementById(modalId);
    if (modalEl) {
      const modal = new bootstrap.Modal(modalEl);
      modal.show();
      document.body.dataset.openModal = ""; // ←再表示防止
    }
  }

// ✅ 病院モーダル再表示（新規 or 編集）
const hospitalModalError = document.body.dataset.hospitalModalError;

if (hospitalModalError) {
  const modalId = hospitalModalError === "new"
    ? "newHospitalModal"
    : `editHospitalModal-${hospitalModalError}`;
  const modalEl = document.getElementById(modalId);

  if (modalEl) {
    // 既にモーダルが開いていたら閉じてから再表示
    const opened = document.querySelector(".modal.show");
    if (opened && opened.id !== modalId) {
      const openedInstance = bootstrap.Modal.getInstance(opened);
      if (openedInstance) {
        opened.addEventListener("hidden.bs.modal", () => {
          new bootstrap.Modal(modalEl).show();
        }, { once: true });
        openedInstance.hide();
      } else {
        new bootstrap.Modal(modalEl).show();
      }
    } else {
      new bootstrap.Modal(modalEl).show();
    }

    document.body.dataset.hospitalModalError = "";
  }
}

  // ✅ 子どもモーダル（new/edit）
  const childModalError = document.body.dataset.childModalError;
  if (childModalError === "new") {
    const modal = new bootstrap.Modal(document.getElementById("childModal"));
    modal.show();
    document.body.dataset.childModalError = "";
  } else if (childModalError === "edit") {
    const modal = new bootstrap.Modal(document.getElementById("editChildModal"));
    modal.show();
    document.body.dataset.childModalError = "";
  }

  // ✅ ルーティンモーダル（エラー用）
  const routineModalError = document.body.dataset.routineModalError;
  if (routineModalError === "true") {
    const modalEl = document.getElementById("routineModal");
    if (modalEl) {
      const modal = new bootstrap.Modal(modalEl);
      modal.show();
      document.body.dataset.routineModalError = "";

      modalEl.addEventListener("hidden.bs.modal", () => {
        modalEl.querySelectorAll(".alert").forEach(alert => alert.remove());
      });

      const form = modalEl.querySelector("form");
      if (form) {
        const attributes = JSON.parse(document.body.dataset.routineAttributes || "{}");
        form.querySelector("[name='routine[time]']").value = attributes.time || "";
        form.querySelector("[name='routine[task]']").value = attributes.task || "";
        form.querySelector("[name='routine[memo]']").value = attributes.memo || "";
      }
    }
  }

  // ✅ 記録モーダルの初期値セット
  const recordModal = document.getElementById("recordModal");
  if (recordModal) {
    recordModal.addEventListener("show.bs.modal", event => {
      const button = event.relatedTarget;
      const task = button?.getAttribute("data-task");
      if (task) {
        const select = recordModal.querySelector("#record_record_type");
        if (select) select.value = task;
      }
    });
  }

  // ✅ 病院ページで ×ボタン押すとトップへ戻る
  document.querySelectorAll(".modal .btn-close").forEach(btn => {
    btn.addEventListener("click", () => {
      if (location.pathname.match(/^\/hospitals\/\d+$/)) {
        window.location.href = "/";
      }
    });
  });
  // ✅ 病院新規登録モーダル（エラー付き再表示）
const hospitalErrors = JSON.parse(document.body.dataset.hospitalErrors || "[]");
const hospitalAttributes = JSON.parse(document.body.dataset.hospitalAttributes || "{}");

if (document.body.dataset.hospitalModalError === "new") {
  const modalEl = document.getElementById("newHospitalModal");
  if (modalEl) {
    const modal = new bootstrap.Modal(modalEl);
    modal.show();
    document.body.dataset.hospitalModalError = "";




    // 入力値の再設定
    const form = modalEl.querySelector("form");
    if (form) {
      form.querySelector("[name='hospital[name]']").value = hospitalAttributes.name || "";
      form.querySelector("[name='hospital[phone_number]']").value = hospitalAttributes.phone_number || "";
    }
  }
}
// ✅ 育児記録モーダル（エラー付き再表示）
const recordModalError = document.body.dataset.recordModalError;
const recordErrors = JSON.parse(document.body.dataset.recordErrors || "[]");
const recordAttributes = JSON.parse(document.body.dataset.recordAttributes || "{}");

if (recordModalError === "true") {
  const modalEl = document.getElementById("recordModal");
  if (modalEl) {
    const modal = new bootstrap.Modal(modalEl);
    modal.show();
    document.body.dataset.recordModalError = "";

    // エラー表示


    // 入力値の再反映
    const form = modalEl.querySelector("form");
    if (form) {
      form.querySelector("[name='record[record_type]']").value = recordAttributes.record_type || "";
      form.querySelector("[name='record[quantity]']").value = recordAttributes.quantity || "";
      form.querySelector("[name='record[recorded_at]']").value = recordAttributes.recorded_at || "";
      form.querySelector("[name='record[memo]']").value = recordAttributes.memo || "";
    }
  }
}
// ✅ 記録編集モーダル（エラー付き再表示）
const editModalId = document.body.dataset.openModal;
if (editModalId && editModalId.startsWith("editRecordModal-")) {
  const modalEl = document.getElementById(editModalId);
  if (modalEl) {
    // モーダル初期化インスタンスがあれば破棄
    const existingModal = bootstrap.Modal.getInstance(modalEl);
    if (existingModal) existingModal.dispose();

    const modal = new bootstrap.Modal(modalEl);
    modal.show();

    // 明示的に backdrop と open クラスを削除（閉じないバグ対策）
    document.body.classList.remove("modal-open");
    document.querySelectorAll(".modal-backdrop").forEach(el => el.remove());

    document.body.dataset.openModal = ""; // 再実行防止

    const recordErrors = JSON.parse(document.body.dataset.recordErrors || "[]");
    if (recordErrors.length > 0) {
      const alertDiv = document.createElement("div");
      alertDiv.className = "alert alert-danger";
      const ul = document.createElement("ul");
      ul.classList.add("mb-0");
      recordErrors.forEach(msg => {
        const li = document.createElement("li");
        li.textContent = msg;
        ul.appendChild(li);
      });
      alertDiv.appendChild(ul);

      const form = modalEl.querySelector("form");
      if (form) form.prepend(alertDiv);
    }
  }
}
});

document.addEventListener("turbo:load", () => {
  const editChildModal = document.getElementById("editChildModal");
  if (editChildModal) {
    editChildModal.addEventListener("hidden.bs.modal", () => {
      const errorBox = document.getElementById("edit-child-error");
      if (errorBox) errorBox.remove();
    });
  }
});

document.addEventListener("turbo:load", () => {
  const newChildModal = document.getElementById("childModal");
  if (newChildModal) {
    newChildModal.addEventListener("hidden.bs.modal", () => {
      const errorBox = document.getElementById("new-child-error");
      if (errorBox) errorBox.remove();
    });
  }

  const editChildModal = document.getElementById("editChildModal");
  if (editChildModal) {
    editChildModal.addEventListener("hidden.bs.modal", () => {
      const errorBox = document.getElementById("edit-child-error");
      if (errorBox) errorBox.remove();
    });
  }
});

document.addEventListener("turbo:load", () => {
  // モーダルを安全に連続表示するための関数
  function openModalSafely(targetId) {
    const openedModal = document.querySelector(".modal.show");
    const targetModal = document.getElementById(targetId);
    if (!targetModal) return;

    if (openedModal) {
      const openedInstance = bootstrap.Modal.getInstance(openedModal);
      openedModal.addEventListener("hidden.bs.modal", () => {
        const newModal = new bootstrap.Modal(targetModal);
        newModal.show();
      }, { once: true });
      openedInstance.hide();
    } else {
      const modal = new bootstrap.Modal(targetModal);
      modal.show();
    }
  }

  // ✅ 推奨：data-open-next-modal による制御（編集ボタンなど）
  document.querySelectorAll("[data-open-next-modal]").forEach(button => {
    button.addEventListener("click", event => {
      event.preventDefault();
      const nextModalId = button.dataset.openNextModal;
      openModalSafely(nextModalId);
    });
  });

  // ✅ 補足：従来の data-bs-toggle="modal" による対応（必要なら残す）
  document.querySelectorAll("[data-bs-toggle='modal'][data-bs-target^='#editRoutineModal-']").forEach(btn => {
    btn.addEventListener("click", () => {
      const modalId = btn.getAttribute("data-bs-target").replace("#", "");
      openModalSafely(modalId);
    });
  });
});

document.addEventListener("turbo:load", () => {
  // 緊急連絡先モーダルが閉じられたら、エラーメッセージを削除する
  document.querySelectorAll("[id^='editHospitalModal-'], #newHospitalModal").forEach(modalEl => {
    modalEl.addEventListener("hidden.bs.modal", () => {
      modalEl.querySelectorAll(".alert").forEach(alert => alert.remove());
    });
  });
});