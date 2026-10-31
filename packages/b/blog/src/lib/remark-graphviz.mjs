import * as Viz from '@viz-js/viz';

const diagramLanguages = new Set(['automaton', 'dot', 'graphviz']);
let vizPromise;

function getViz() {
  vizPromise ??= Viz.instance();
  return vizPromise;
}

function normalizeLanguage(language) {
  return language?.toLowerCase();
}

function isGraphDeclaration(value) {
  return /^(strict\s+)?(di)?graph\b/i.test(value.trim());
}

function automatonSource(value) {
  const source = value.trim();

  if (isGraphDeclaration(source)) {
    return source;
  }

  return `digraph Automaton {
  rankdir=LR;
  graph [bgcolor="transparent", margin="0.08"];
  node [shape=circle, label="", fontname="Arial"];
  edge [fontname="Arial"];

${source}
}`;
}

function graphvizSource(node) {
  if (normalizeLanguage(node.lang) === 'automaton') {
    return automatonSource(node.value);
  }

  return node.value;
}

function inlineSvg(svg, { stripTitles = false } = {}) {
  const output = svg
    .replace(/^[\s\S]*?(<svg\b)/, '$1')
    .replace(/<svg\b/, '<svg class="graphvizDiagramSvg" role="img"');

  if (stripTitles) {
    return output.replace(/<title>[\s\S]*?<\/title>\s*/g, '');
  }

  return output;
}

function graphvizHtml(svg, language) {
  const classes = ['graphvizDiagram'];
  const isAutomaton = language === 'automaton';

  if (isAutomaton) {
    classes.push('graphvizDiagramAutomaton');
  }

  return `<figure class="${classes.join(' ')}">${inlineSvg(svg, {
    stripTitles: isAutomaton
  })}</figure>`;
}

async function transformChildren(parent, file, viz) {
  if (!Array.isArray(parent.children)) {
    return;
  }

  for (let index = 0; index < parent.children.length; index += 1) {
    const child = parent.children[index];
    const language = normalizeLanguage(child.lang);

    if (child.type === 'code' && diagramLanguages.has(language) && child.value.trim()) {
      try {
        const svg = viz.renderString(graphvizSource(child), {
          engine: 'dot',
          format: 'svg'
        });

        parent.children[index] = {
          type: 'html',
          value: graphvizHtml(svg, language)
        };
      } catch (error) {
        const location = child.position?.start?.line ? ` at line ${child.position.start.line}` : '';
        const message = error instanceof Error ? error.message : String(error);

        file.fail(`Failed to render Graphviz diagram${location}: ${message}`, child);
      }

      continue;
    }

    await transformChildren(child, file, viz);
  }
}

export default function remarkGraphviz() {
  return async (tree, file) => {
    await transformChildren(tree, file, await getViz());
  };
}
