// Sidebar buttons
document.addEventListener('DOMContentLoaded', () => {
  const showButton = document.getElementById('show-sidebar-button');
  const hideButton = document.getElementById('hide-sidebar-button');

  showButton.addEventListener('click', () => {
    document.body.style.setProperty('--sidebar-showing', 'revert');
    document.body.style.setProperty('--sidebar-hidden', 'none');
  });

  hideButton.addEventListener('click', () => {
    document.body.style.setProperty('--sidebar-showing', 'none');
    document.body.style.setProperty('--sidebar-hidden', 'revert');
  });
});

// Headline scrolling
document.addEventListener('DOMContentLoaded', () => {
  const headline = document.getElementById('headline');
  const main = document.getElementById('main');

  headline.addEventListener('click', () => {
    main.scrollTo(0, 0);
  });
});
