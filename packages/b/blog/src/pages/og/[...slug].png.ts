import type { APIRoute } from 'astro';
import { getCollection } from 'astro:content';
import { generateOgImage } from '../../lib/og';
import { thumbnailPath } from '../../lib/thumbnails';

export async function getStaticPaths() {
  const posts = await getCollection('posts');

  return posts.map((post) => ({
    params: { slug: post.id },
    props: { post }
  }));
}

export const GET: APIRoute = async ({ props }) => {
  const { post } = props;
  const image = await generateOgImage({
    category: post.data.category,
    title: post.data.title,
    description: post.data.description,
    thumbnail: thumbnailPath(post.data.thumbnail, post.id)
  });

  return new Response(image, {
    headers: {
      'Cache-Control': 'public, max-age=3600, stale-while-revalidate=86400',
      'Content-Type': 'image/png'
    }
  });
};
