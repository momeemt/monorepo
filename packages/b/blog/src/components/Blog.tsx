import type { Author } from '../lib/authors';

type PostSummary = {
  category: 'Life' | 'Tech' | 'CS';
  href: string;
  title: string;
  description?: string;
  pubDate: string;
  thumbnail: string;
  author: Author;
};

type PostListProps = {
  posts: PostSummary[];
};

type PostHeaderProps = Omit<PostSummary, 'category' | 'href' | 'thumbnail'>;

const siteName = 'blog.momee.mt';
const sourceUrl = 'https://github.com/momeemt/monorepo/tree/develop/packages/b/blog';
const rssUrl = '/rss.xml';
const comments = [
  '計算機と羊文学が好きで、マヨネーズが苦手です',
  '人のブログを読むのが好きなので書いている',
  '精神状態が悪い時は散歩に出掛けてください',
  'スティックカフェオレのことをコーヒーと呼んでいる',
  '鍋料理を賞味期限内に食べ切ることができない',
];

function formatDate(date: string) {
  const value = new Date(date);
  const year = value.getFullYear();
  const month = String(value.getMonth() + 1).padStart(2, '0');
  const day = String(value.getDate()).padStart(2, '0');

  return `${year}/${month}/${day}`;
}

function CategoryBadge({ category }: { category: PostSummary['category'] }) {
  return <span className={`categoryBadge ${category.toLowerCase()}`}>{category}</span>;
}

function AuthorMark({ author }: { author: Author }) {
  return (
    <span className="postAuthor">
      <img alt="" src={author.icon} loading="lazy" decoding="async" />
      <span>{author.name}</span>
    </span>
  );
}

export function HomePage({ posts }: PostListProps) {
  return (
    <div className="homePage" data-view="card">
      <h1 className="siteTitle">{siteName}</h1>
      <p
        className="siteDescription"
        data-comments={JSON.stringify(comments)}
        data-comment-pending="true"
      >
        {comments[0]}
      </p>
      <div className="sectionDivider">
        <span className="sectionDividerLabel">
          <i className="fa-solid fa-kiwi-bird" aria-hidden="true" />
          新しい記事
        </span>
      </div>
      <ViewSwitcher />
      <PostList posts={posts} />
      <SiteFooter />
    </div>
  );
}

export function TaggedPostsPage({ posts, tag }: PostListProps & { tag: string }) {
  return (
    <div className="homePage" data-view="card">
      <h1 className="siteTitle">#{tag}</h1>
      <p className="siteDescription">タグ「{tag}」の記事</p>
      <div className="sectionDivider">
        <span className="sectionDividerLabel">
          <i className="fa-solid fa-tag" aria-hidden="true" />
          該当記事
        </span>
      </div>
      <ViewSwitcher />
      <PostList posts={posts} />
      <SiteFooter homeLink />
    </div>
  );
}

function ViewSwitcher() {
  return (
    <div className="viewSwitcher" role="group" aria-label="表示切り替え">
      <button
        type="button"
        className="active"
        aria-pressed="true"
        data-view-option="card"
      >
        カード
      </button>
      <button
        type="button"
        aria-pressed="false"
        data-view-option="list"
      >
        リスト
      </button>
    </div>
  );
}

function PostList({ posts }: PostListProps) {
  return (
    <section className="postList" aria-label="新しい記事">
      <div className="postGrid">
        {posts.map((post, index) => (
          <PostCard post={post} key={post.href} priority={index < 3} />
        ))}
      </div>
      <div className="postRows">
        {posts.map((post) => (
          <PostRow post={post} key={post.href} />
        ))}
      </div>
    </section>
  );
}

function PostThumbnail({ post, priority = false }: { post: PostSummary; priority?: boolean }) {
  return (
    <div className="postThumbnail">
      <CategoryBadge category={post.category} />
      <img
        alt=""
        src={post.thumbnail}
        loading={priority ? 'eager' : 'lazy'}
        fetchPriority={priority ? 'high' : 'auto'}
        decoding="async"
        data-loaded="false"
      />
    </div>
  );
}

function PostCard({ post, priority }: { post: PostSummary; priority: boolean }) {
  return (
    <article className="postCard">
      <a href={post.href}>
        <PostThumbnail post={post} priority={priority} />
        <div className="postBody">
          <h2>{post.title}</h2>
          {post.description && <p className="postDescription">{post.description}</p>}
          <time className="postDate" dateTime={post.pubDate}>
            {formatDate(post.pubDate)}
          </time>
        </div>
        <AuthorMark author={post.author} />
      </a>
    </article>
  );
}

function PostRow({ post }: { post: PostSummary }) {
  return (
    <article className="postRow">
      <a href={post.href}>
        <p className="postRowMeta">
          <span className={`postRowCategory ${post.category.toLowerCase()}`}>{post.category}</span>
          <time className="postDate" dateTime={post.pubDate}>
            {formatDate(post.pubDate)}
          </time>
          <span>{post.author.name}</span>
        </p>
        <h2>{post.title}</h2>
        {post.description && <p className="postDescription">{post.description}</p>}
      </a>
    </article>
  );
}

export function ArticleTags({ tags }: { tags: string[] }) {
  if (tags.length === 0) {
    return null;
  }

  return (
    <nav className="articleTags" aria-label="タグ">
      <span className="articleTagsLabel">Tags</span>
      {tags.map((tag) => (
        <a className="articleTagLink" href={`/tags/${encodeURIComponent(tag)}/`} key={tag}>
          {tag}
        </a>
      ))}
    </nav>
  );
}

export function PostHeader({ title, description, pubDate, author }: PostHeaderProps) {
  return (
    <header className="articleHeader">
      <h1>{title}</h1>
      {description && <p className="articleDescription">{description}</p>}
      <p className="articleDate">
        <time dateTime={pubDate}>{formatDate(pubDate)}</time>
      </p>
      <div className="articleAuthor">
        <img className="articleAuthorIcon" alt="" src={author.icon} />
        <span>
          <strong>{author.name}</strong>
          {author.bio && <small className="articleAuthorBio">{author.bio}</small>}
          <span className="articleAuthorLinks">
            {author.website && (
              <a href={author.website} target="_blank" rel="noreferrer" aria-label="Website">
                <i className="fa-solid fa-globe" aria-hidden="true" />
              </a>
            )}
            {author.github_id && (
              <a
                href={`https://github.com/${author.github_id}`}
                target="_blank"
                rel="noreferrer"
                aria-label="GitHub"
              >
                <i className="fa-brands fa-github" aria-hidden="true" />
              </a>
            )}
            {author.x_id && (
              <a
                href={`https://x.com/${author.x_id}`}
                target="_blank"
                rel="noreferrer"
                aria-label="X"
              >
                <i className="fa-brands fa-x-twitter" aria-hidden="true" />
              </a>
            )}
          </span>
        </span>
      </div>
    </header>
  );
}

export function SiteFooter({
  article = false,
  homeLink = article
}: {
  article?: boolean;
  homeLink?: boolean;
}) {
  return (
    <footer className="siteFooter">
      {homeLink ? (
        <>
          <a href="/">記事一覧に戻る</a>
          <span className="footerSeparator">|</span>
        </>
      ) : null}
      <a href={rssUrl}>RSS</a>
      <span className="footerSeparator">|</span>
      <a href={sourceUrl} target="_blank" rel="noreferrer">
        Source
      </a>
      <br />
      <br />
      <span>© 2022-2026 Mutsuha Asada</span>
    </footer>
  );
}
