// @ts-check
import { defineConfig } from 'astro/config';
import mdx from '@astrojs/mdx';
import react from '@astrojs/react';
import rehypeKatex from 'rehype-katex';
import remarkGfm from 'remark-gfm';
import { bundledLanguages } from 'shiki/bundle/full';
import remarkGraphviz from './src/lib/remark-graphviz.mjs';
import remarkInlineFootnotes from './src/lib/remark-inline-footnotes.mjs';
import remarkMath from 'remark-math';
import remarkTweetEmbeds from './src/lib/remark-tweet-embeds.mjs';

const site = process.env.BLOG_SITE ?? 'https://blog.momee.mt';

// https://astro.build/config
export default defineConfig({
  site,
  integrations: [mdx(), react()],
  markdown: {
    syntaxHighlight: 'shiki',
    shikiConfig: {
      theme: 'github-light',
      langs: Object.values(bundledLanguages)
    },
    remarkPlugins: [
      remarkMath,
      remarkGfm,
      remarkTweetEmbeds,
      remarkInlineFootnotes,
      remarkGraphviz
    ],
    rehypePlugins: [rehypeKatex]
  }
});
