const marker = /\[\^\s+/;

function cloneNode(node) {
  return structuredClone(node);
}

function textNode(value) {
  return { type: 'text', value };
}

function splitLinkAtClose(node) {
  if (node.type !== 'link' || !Array.isArray(node.children) || node.children.length !== 1) {
    return undefined;
  }

  const child = node.children[0];

  if (child.type !== 'text') {
    return undefined;
  }

  const closeIndex = child.value.indexOf(']');

  if (closeIndex === -1) {
    return undefined;
  }

  const before = child.value.slice(0, closeIndex);
  const after = child.value.slice(closeIndex + 1);

  if (!before) {
    return { after };
  }

  const beforeNode = cloneNode(node);
  beforeNode.url = beforeNode.url.split(']')[0];
  beforeNode.children = [textNode(before)];

  return { after, beforeNode };
}

function trimNoteChildren(children) {
  while (children.length > 0 && children[0].type === 'text') {
    children[0].value = children[0].value.trimStart();

    if (children[0].value.length > 0) {
      break;
    }

    children.shift();
  }

  while (children.length > 0 && children[children.length - 1].type === 'text') {
    children[children.length - 1].value = children[children.length - 1].value.trimEnd();

    if (children[children.length - 1].value.length > 0) {
      break;
    }

    children.pop();
  }

  return children;
}

function findInlineFootnote(children, startIndex, startOffset) {
  const noteChildren = [];

  for (let index = startIndex; index < children.length; index += 1) {
    const child = children[index];

    if (child.type !== 'text') {
      const split = splitLinkAtClose(child);

      if (split) {
        if (split.beforeNode) {
          noteChildren.push(split.beforeNode);
        }

        return {
          after: split.after,
          endIndex: index,
          noteChildren: trimNoteChildren(noteChildren)
        };
      }

      noteChildren.push(cloneNode(child));
      continue;
    }

    const value = index === startIndex ? child.value.slice(startOffset) : child.value;
    const closeIndex = value.indexOf(']');

    if (closeIndex === -1) {
      if (value) {
        noteChildren.push(textNode(value));
      }

      continue;
    }

    const noteText = value.slice(0, closeIndex);
    const after = value.slice(closeIndex + 1);

    if (noteText) {
      noteChildren.push(textNode(noteText));
    }

    return {
      after,
      endIndex: index,
      noteChildren: trimNoteChildren(noteChildren)
    };
  }

  return undefined;
}

function addFootnote(definitions, state, children) {
  state.count += 1;

  const identifier = `inline-${state.count}`;
  const label = String(state.count);

  definitions.push({
    type: 'footnoteDefinition',
    identifier,
    label,
    children: [
      {
        type: 'paragraph',
        children
      }
    ]
  });

  return { type: 'footnoteReference', identifier, label };
}

function transformChildren(parent, definitions, state) {
  if (!Array.isArray(parent.children)) {
    return;
  }

  for (let index = 0; index < parent.children.length;) {
    const child = parent.children[index];

    if (child.type === 'footnoteDefinition') {
      index += 1;
      continue;
    }

    if (child.type !== 'text') {
      transformChildren(child, definitions, state);
      index += 1;
      continue;
    }

    const match = marker.exec(child.value);

    if (!match) {
      index += 1;
      continue;
    }

    const found = findInlineFootnote(parent.children, index, match.index + match[0].length);

    if (!found || found.noteChildren.length === 0) {
      index += 1;
      continue;
    }

    const before = child.value.slice(0, match.index);
    const replacement = [];

    if (before) {
      replacement.push(textNode(before));
    }

    replacement.push(addFootnote(definitions, state, found.noteChildren));

    if (found.after) {
      replacement.push(textNode(found.after));
    }

    parent.children.splice(index, found.endIndex - index + 1, ...replacement);
    index += (before ? 2 : 1);
  }
}

export default function remarkInlineFootnotes() {
  return (tree) => {
    const definitions = [];

    transformChildren(tree, definitions, { count: 0 });
    tree.children.push(...definitions);
  };
}
