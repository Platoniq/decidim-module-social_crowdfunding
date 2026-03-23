document.addEventListener("DOMContentLoaded", () => {
  document.querySelectorAll(".toggle-arrow").forEach((trigger) => {
    const target = document.getElementById(trigger.dataset.target);
    const icon = trigger.querySelector(".toggle-arrow__icon");

    if (!target || !icon) return;

    trigger.addEventListener("click", () => {
      target.classList.toggle("toggle-hidden");
      icon.classList.toggle("toggle-arrow__icon--open", !target.classList.contains("toggle-hidden"));
    });
  });
});
