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

  // ✅ 病院編集モーダル
  const editHospitalId = document.body.dataset.hospitalModalError;
  if (editHospitalId) {
    const modalEl = document.getElementById(`editHospitalModal-${editHospitalId}`);
    if (modalEl) {
      const modal = new bootstrap.Modal(modalEl);
      modal.show();
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