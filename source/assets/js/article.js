// Copies param to the clipboard
function copyToClipboard(string) {
  const element = document.createElement('textarea');
  element.value = string.trim();
  element.setAttribute('readonly', '');
  element.style.position = 'absolute';
  element.style.left = '-9999px';
  document.body.appendChild(element);
  element.select();
  document.execCommand('copy');
  document.body.removeChild(element);
};

// Listen for clicks on our markdown code block icons.
document.addEventListener('DOMContentLoaded', () => {
  const clipboards = document.getElementsByClassName('clipboard');
  for (let clipboard of clipboards) {
    clipboard.addEventListener('click', (event) => {
      copyToClipboard(event.target.previousSibling.textContent);
    });
  }
});
