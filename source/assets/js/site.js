class SideBar {
  static domLoaded() {
    const showButton = document.getElementById('show-sidebar-button');
    const hideButton = document.getElementById('hide-sidebar-button');

    const cornerLetter = document.getElementById('corner-artisanal-letter');
    const headlineLetter = document.getElementById('headline-artisanal-letter');

    showButton.addEventListener("click", () => {
      document.body.style.setProperty('--sidebar-shown', 'block');
      showButton.style.display = "none";
      hideButton.style.display = "block";
      cornerLetter.style.display = "block";
      headlineLetter.style.display = "none";
    });

    hideButton.addEventListener("click", () => {
      document.body.style.setProperty('--sidebar-shown', 'none');
      showButton.style.display = "block";
      hideButton.style.display = "none";
      cornerLetter.style.display = "none";
      headlineLetter.style.display = "inline";
    });
  }
}
document.addEventListener("DOMContentLoaded", () => SideBar.domLoaded());
