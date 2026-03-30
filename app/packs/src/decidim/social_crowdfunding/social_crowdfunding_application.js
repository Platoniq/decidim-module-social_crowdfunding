document.addEventListener("DOMContentLoaded", () => {
  document.querySelectorAll(".toggle-arrow").forEach((trigger) => {
    const target = document.getElementById(trigger.dataset.target);
    const icon = trigger.querySelector(".toggle-arrow__icon");

    if (!target || !icon) {
      return;
    }

    trigger.addEventListener("click", (event) => {
      event.preventDefault();
      target.classList.toggle("toggle-hidden");
      icon.classList.toggle("toggle-arrow__icon--open", !target.classList.contains("toggle-hidden"));
    });
  });

  document.querySelectorAll(".action-icon--select-campaign, .action-icon--reload-campaign").forEach((link) => {
    link.addEventListener("click", () => {
      const spinner = document.createElement("span");
      spinner.className = "fetch-spinner";
      link.style.display = "none";
      link.parentNode.insertBefore(spinner, link.nextSibling);
    });
  });

  const fetchBtn = document.getElementById("fetch-campaign-btn");
  if (fetchBtn) {
    fetchBtn.addEventListener("click", () => {
      const slugInput = fetchBtn.closest("form").querySelector("input[name*='slug']");
      if (!slugInput || !slugInput.value.trim()) {
        return;
      }

      setTimeout(() => {
        const spinner = document.createElement("span");
        spinner.className = "fetch-spinner";
        fetchBtn.disabled = true;
        fetchBtn.style.display = "none";
        fetchBtn.parentNode.insertBefore(spinner, fetchBtn.nextSibling);
      }, 0);
    });
  }
});
