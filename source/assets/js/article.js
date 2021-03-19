// Copying code blocks to the clipboard.
document.addEventListener('DOMContentLoaded', () => {
  const clipboards = document.getElementsByClassName('clipboard');
  for (let clipboard of clipboards) {
    clipboard.addEventListener('click', (event) => {
      const code = event.target.previousSibling.textContent.trim();
      navigator.clipboard.writeText(code);
    });
  }
});
