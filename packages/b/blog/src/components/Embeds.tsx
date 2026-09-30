type EmbedFrameProps = {
  allow?: string;
  children?: never;
  className?: string;
  height?: number | string;
  src: string;
  title: string;
};

type SpotifyEmbedType = 'album' | 'artist' | 'episode' | 'playlist' | 'show' | 'track';

type SpotifyEmbedProps = {
  height?: number;
  id?: string;
  title?: string;
  type?: SpotifyEmbedType;
  url?: string;
};

const spotifyTypes = new Set<SpotifyEmbedType>([
  'album',
  'artist',
  'episode',
  'playlist',
  'show',
  'track'
]);

const mediaAllow = 'autoplay; clipboard-write; encrypted-media; fullscreen; picture-in-picture';

function classNames(...values: Array<string | undefined>) {
  return values.filter(Boolean).join(' ');
}

function defaultSpotifyHeight(type: SpotifyEmbedType) {
  return type === 'track' || type === 'episode' ? 152 : 352;
}

function spotifyEmbedDetails({
  id,
  type = 'track',
  url
}: Pick<SpotifyEmbedProps, 'id' | 'type' | 'url'>) {
  if (id) {
    return {
      src: `https://open.spotify.com/embed/${type}/${encodeURIComponent(id)}`,
      type
    };
  }

  if (!url) {
    throw new Error('SpotifyEmbed requires either id or url');
  }

  const parsed = new URL(url);

  if (parsed.hostname !== 'open.spotify.com') {
    throw new Error(`Unsupported Spotify URL: ${url}`);
  }

  const parts = parsed.pathname.split('/').filter(Boolean);
  const [first, second, third] = parts;
  const embedType = first === 'embed' ? second : first;
  const embedId = first === 'embed' ? third : second;

  if (!spotifyTypes.has(embedType as SpotifyEmbedType) || !embedId) {
    throw new Error(`Unsupported Spotify URL: ${url}`);
  }

  return {
    src: `https://open.spotify.com/embed/${embedType}/${encodeURIComponent(embedId)}`,
    type: embedType as SpotifyEmbedType
  };
}

export function EmbedFrame({
  allow = mediaAllow,
  className,
  height = 152,
  src,
  title
}: EmbedFrameProps) {
  return (
    <div className={classNames('embedFrame', className)}>
      <iframe
        allow={allow}
        allowFullScreen
        height={height}
        loading="lazy"
        src={src}
        title={title}
        width="100%"
      />
    </div>
  );
}

export function SpotifyEmbed({
  height,
  id,
  title = 'Spotify embed',
  type = 'track',
  url
}: SpotifyEmbedProps) {
  const embed = spotifyEmbedDetails({ id, type, url });

  return (
    <EmbedFrame
      className="spotifyEmbed"
      height={height ?? defaultSpotifyHeight(embed.type)}
      src={embed.src}
      title={title}
    />
  );
}

export function SpotifyTrack(props: Omit<SpotifyEmbedProps, 'type'>) {
  return <SpotifyEmbed title="Spotify track" {...props} type="track" />;
}

export function SpotifyAlbum(props: Omit<SpotifyEmbedProps, 'type'>) {
  return <SpotifyEmbed title="Spotify album" {...props} type="album" />;
}

export function SpotifyPlaylist(props: Omit<SpotifyEmbedProps, 'type'>) {
  return <SpotifyEmbed title="Spotify playlist" {...props} type="playlist" />;
}
