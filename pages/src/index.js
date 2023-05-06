const pug = import('pug');
const constants = import('./constants');

window.onload = async () => {
  const container = document.getElementById('main');
  const template = pug.compileFile("template.pug", {});
  container.innerHTML = template(constants);
};
