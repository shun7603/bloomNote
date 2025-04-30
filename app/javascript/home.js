document.addEventListener("DOMContentLoaded", () => {
  const routineDataElement = document.getElementById("routine-data");
  if (!routineDataElement) return;

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

  const footer = document.getElementById("task-footer");
  if (footer) {
    footer.textContent = `今やるべきタスク：${nextTask}`;
  }
});