import type { APIRoute } from 'astro';
import { getCollection } from 'astro:content';
import { findAuthor } from '../lib/authors';

const siteName = 'blog.momee.mt';
const siteDescription = 'momeemt のブログ';
const fallbackSite = process.env.BLOG_SITE ?? 'https://blog.momee.mt';

function escapeXml(value: string) {
  return value
    .replaceAll('&', '&amp;')
    .replaceAll('<', '&lt;')
    .replaceAll('>', '&gt;')
    .replaceAll('"', '&quot;')
    .replaceAll("'", '&apos;');
}

export const GET: APIRoute = async ({ site }) => {
  const siteUrl = site ?? new URL(fallbackSite);
  const posts = (await getCollection('posts')).sort(
    (a, b) => b.data.pubDate.valueOf() - a.data.pubDate.valueOf()
  );

  const items = posts
    .map((post) => {
      const author = findAuthor(post.data.author);
      const url = new URL(`/posts/${post.id}/`, siteUrl).href;

      return [
        '<item>',
        `<title>${escapeXml(post.data.title)}</title>`,
        `<link>${escapeXml(url)}</link>`,
        `<guid>${escapeXml(url)}</guid>`,
        `<pubDate>${post.data.pubDate.toUTCString()}</pubDate>`,
        post.data.description
          ? `<description>${escapeXml(post.data.description)}</description>`
          : '',
        author.email ? `<author>${escapeXml(`${author.email} (${author.name})`)}</author>` : '',
        '</item>'
      ].join('');
    })
    .join('');

  const xml = [
    '<?xml version="1.0" encoding="UTF-8"?>',
    '<rss version="2.0" xmlns:atom="http://www.w3.org/2005/Atom">',
    '<channel>',
    `<title>${siteName}</title>`,
    `<description>${siteDescription}</description>`,
    `<link>${siteUrl.href}</link>`,
    `<atom:link href="${new URL('/rss.xml', siteUrl).href}" rel="self" type="application/rss+xml" />`,
    items,
    '</channel>',
    '</rss>'
  ].join('');

  return new Response(xml, {
    headers: {
      'Content-Type': 'application/rss+xml; charset=utf-8'
    }
  });
};
