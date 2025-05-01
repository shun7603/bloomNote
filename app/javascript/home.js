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
  // 🔽 編集モーダルでエラーがあったときに表示
  const editModalId = "<%= j flash.now[:edit_hospital_id] %>";
  if (editModalId) {
    const targetModal = document.getElementById(`editHospitalModal-${editModalId}`);
    if (targetModal) {
      const modal = new bootstrap.Modal(targetModal);
      modal.show();
    }
  }
});