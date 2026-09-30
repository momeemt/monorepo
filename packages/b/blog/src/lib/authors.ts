import authors from '../data/authors.json';

export type Author = {
  id: string;
  name: string;
  bio?: string;
  icon: string;
  email?: string;
  website?: string;
  github_id?: string;
  x_id?: string;
};

const authorList = authors as Author[];

export function findAuthor(id: string) {
  const author = authorList.find((item) => item.id === id);

  if (author) {
    return author;
  }

  throw new Error(`Unknown author id: ${id}`);
}
