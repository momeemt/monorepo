import { defineCollection } from 'astro:content';
import { glob } from 'astro/loaders';
import { z } from 'astro/zod';

const posts = defineCollection({
  loader: glob({ base: './src/content/posts', pattern: '**/*.{md,mdx}' }),
  schema: z.object({
    category: z.enum(['Life', 'Tech', 'CS']),
    title: z.string(),
    description: z.string().optional(),
    pubDate: z.coerce.date(),
    author: z.string().default('momeemt'),
    tags: z.array(z.string()).optional(),
    thumbnail: z.string().optional()
  })
});

export const collections = { posts };
