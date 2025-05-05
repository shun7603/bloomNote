console.log("✅ home.js 読み込まれました");
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

window.toggleForm = function(childId) {
  const form = document.getElementById(`form-${childId}`);
  if (form.style.display === "none" || form.style.display === "") {
    form.style.display = "block";
  } else {
    form.style.display = "none";
  }
};
document.addEventListener("DOMContentLoaded", () => {
  const errorAlert = document.querySelector("#recordModal .alert-danger");
  if (errorAlert) {
    const recordModal = new bootstrap.Modal(document.getElementById("recordModal"));
    recordModal.show();
  }
});

document.addEventListener("DOMContentLoaded", () => {
  // エラーがあったときにモーダルを自動で開く
  const editModalId = "<%= j flash.now[:edit_hospital_id] %>";
  if (editModalId) {
    const targetModal = document.getElementById(`editHospitalModal-${editModalId}`);
    if (targetModal) {
      const modal = new bootstrap.Modal(targetModal);
      modal.show();
    }
  }

  // ✕ボタンで `/` に戻る処理を追加
  document.querySelectorAll(".modal .btn-close").forEach(btn => {
    btn.addEventListener("click", () => {
      if (location.pathname.match(/^\/hospitals\/\d+$/)) {
        window.location.href = "/";
      }
    });
  });
});

document.addEventListener("DOMContentLoaded", () => {
  const modal = document.getElementById('recordModal');
  if (!modal) return;

  modal.addEventListener('show.bs.modal', event => {
    const button = event.relatedTarget;
    if (!button) return;

    const task = button.getAttribute('data-task');
    const category = button.getAttribute('data-category');

    if (task && category) {
      document.querySelector('#record_record_type').value = task;
      document.querySelector('#record_category').value = category;
    }
  });
});

document.addEventListener("turbo:load", () => {
  const recordModal = document.getElementById("recordModal");
  recordModal?.addEventListener("show.bs.modal", (event) => {
    const button = event.relatedTarget;
    const task = button?.getAttribute("data-task");

    if (task) {
      const select = recordModal.querySelector("#record_record_type");
      if (select) {
        select.value = task;
      }
    }
  });
});
document.addEventListener("DOMContentLoaded", () => {
  const taskButton = document.querySelector('[data-task]');
  const recordSelect = document.getElementById('record_record_type');

  if (taskButton && recordSelect) {
    taskButton.addEventListener('click', () => {
      const task = taskButton.getAttribute('data-task');
      if (task) {
        recordSelect.value = task;
      }
    });
  }
});

document.addEventListener("DOMContentLoaded", () => {
  const routineModal = document.getElementById("routineDetailModal");
  if (!routineModal) return;

  routineModal.addEventListener("show.bs.modal", (event) => {
    const button = event.relatedTarget;
    document.getElementById("modalRoutineTime").textContent = button.getAttribute("data-routine-time");
    document.getElementById("modalRoutineTask").textContent = button.getAttribute("data-routine-task");
    document.getElementById("modalRoutineMemo").textContent = button.getAttribute("data-routine-memo");
  });
});