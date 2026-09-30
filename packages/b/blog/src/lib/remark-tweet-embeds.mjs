const tweetHosts = new Set(['x.com', 'twitter.com', 'www.twitter.com', 'mobile.twitter.com']);

function text(value) {
  return typeof value === 'string' ? value.trim() : '';
}

function tweetUrl(value) {
  let url;

  try {
    url = new URL(value);
  } catch {
    return undefined;
  }

  if (!tweetHosts.has(url.hostname.toLowerCase())) {
    return undefined;
  }

  const parts = url.pathname.split('/').filter(Boolean);
  const [user, status, id] = parts;

  if (!user || !['status', 'statuses'].includes(status) || !/^[0-9]+$/.test(id ?? '')) {
    return undefined;
  }

  return `https://x.com/${encodeURIComponent(user)}/status/${id}`;
}

function paragraphTweetUrl(node) {
  if (node.type !== 'paragraph' || !Array.isArray(node.children) || node.children.length !== 1) {
    return undefined;
  }

  const [child] = node.children;

  if (child.type === 'link' && Array.isArray(child.children) && child.children.length === 1) {
    const [label] = child.children;

    if (label.type !== 'text' || text(label.value) !== child.url) {
      return undefined;
    }

    return tweetUrl(child.url);
  }

  if (child.type === 'text') {
    return tweetUrl(text(child.value));
  }

  return undefined;
}

function tweetEmbed(url) {
  return `<div class="twitterEmbed"><blockquote class="twitter-tweet" data-dnt="true"><a href="${url}">${url}</a></blockquote></div>`;
}

function transformChildren(parent) {
  if (!Array.isArray(parent.children)) {
    return;
  }

  for (let index = 0; index < parent.children.length; index += 1) {
    const child = parent.children[index];
    const url = paragraphTweetUrl(child);

    if (url) {
      parent.children[index] = {
        type: 'html',
        value: tweetEmbed(url)
      };
      continue;
    }

    transformChildren(child);
  }
}

export default function remarkTweetEmbeds() {
  return (tree) => {
    transformChildren(tree);
  };
}
