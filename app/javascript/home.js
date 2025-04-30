function showRoutine(childId, childName) {
  // すべての子どものルーティン表示エリアを非表示にする
  document.querySelectorAll(".child-routine-section").forEach(el => el.style.display = "none");

  // 選ばれた子どもだけ表示
  const section = document.getElementById(`routine-${childId}`);
  if (section) section.style.display = "block";

  // ヘッダーをその子の名前に変更
  const header = document.getElementById("child-name-header");
  if (header) header.textContent = `${childName}ちゃんのルーティン`;

  // 今やるべきタスクをその子に対して判定
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
}