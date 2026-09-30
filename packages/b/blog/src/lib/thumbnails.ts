const fallbackThumbnails = [
  'smoking-girl',
  'stuck-capsule',
  'tab-hoarder',
  'cat-lap-gaming',
  'overwhelmed-art'
];

export function thumbnailPath(thumbnail: string | undefined, key: string) {
  if (thumbnail) {
    if (!thumbnail.includes('/')) {
      return `/shigureni/${thumbnail}.webp`;
    }

    return thumbnail;
  }

  const index = Array.from(key).reduce((sum, char) => sum + char.charCodeAt(0), 0) % 5;

  return `/shigureni/${fallbackThumbnails[index]}.webp`;
}
