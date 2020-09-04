class SideBar {
  static domLoaded() {
    const showButton = document.getElementById('show-sidebar-button');
    const hideButton = document.getElementById('hide-sidebar-button');

    const sidebarLinks = document.getElementById('sidebar-links');
    const sidebarHeader = document.getElementById('sidebar-header');
    const cornerLetter = document.getElementById('corner-artisanal-letter');
    const headlineLetter = document.getElementById('headline-artisanal-letter');

    showButton.addEventListener('click', () => {
      sidebarLinks.style.display = 'block';
      sidebarHeader.style.display = 'none';
      showButton.style.display = 'none';
      hideButton.style.display = 'block';
      cornerLetter.style.display = 'block';
      headlineLetter.style.display = 'none';
    });

    hideButton.addEventListener('click', () => {
      sidebarLinks.style.display = 'none';
      sidebarHeader.style.display = 'block';
      showButton.style.display = 'block';
      hideButton.style.display = 'none';
      cornerLetter.style.display = 'none';
      headlineLetter.style.display = 'inline';
    });
  }
}
document.addEventListener('DOMContentLoaded', () => SideBar.domLoaded());
