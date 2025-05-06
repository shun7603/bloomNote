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

// ✅ turbo:load を1回だけにまとめる！！
document.addEventListener("turbo:load", () => {
  // ✅ モーダルを開く（open_modal）
  const modalId = document.body.dataset.openModal;
  if (modalId) {
    const modalEl = document.getElementById(modalId);
    if (modalEl) {
      const modal = new bootstrap.Modal(modalEl);
      modal.show();
      document.body.dataset.openModal = ""; // ←これがないと再表示される！
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

  // ✅ ルーティン追加モーダル（routineModalError）
  const routineModalError = document.body.dataset.routineModalError;
  if (routineModalError === "true") {
    const modalEl = document.getElementById("routineModal");
    if (modalEl) {
      const modal = new bootstrap.Modal(modalEl);
      modal.show();
      document.body.dataset.routineModalError = "";
    }

    const errors = JSON.parse(document.body.dataset.routineErrors || "[]");
    const attributes = JSON.parse(document.body.dataset.routineAttributes || "{}");
    const form = modalEl?.querySelector("form");

    if (form) {
      form.querySelector("[name='routine[time]']").value = attributes.time || "";
      form.querySelector("[name='routine[task]']").value = attributes.task || "";
      form.querySelector("[name='routine[memo]']").value = attributes.memo || "";
    }
  }

  // ✅ 記録モーダル：data-task を select に反映
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

  // ✅ 病院モーダルで編集中は ×ボタンでトップへ戻す
  document.querySelectorAll(".modal .btn-close").forEach(btn => {
    btn.addEventListener("click", () => {
      if (location.pathname.match(/^\/hospitals\/\d+$/)) {
        window.location.href = "/";
      }
    });
  });
});