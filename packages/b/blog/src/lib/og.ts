import path from 'node:path';
import { readFileSync } from 'node:fs';
import { createRequire } from 'node:module';
import { createElement } from 'react';
import satori, { type FontWeight } from 'satori';
import sharp from 'sharp';

type OgImageOptions = {
  category: 'Life' | 'Tech' | 'CS';
  title: string;
  description?: string;
  thumbnail: string;
};

const width = 1200;
const height = 630;
const pageBackground = '#eee';
const textBackground = '#fff';
const imageBackground = '#f7f7f7';
const cardX = 40;
const cardY = 40;
const cardWidth = 1120;
const cardHeight = 550;
const cardRadius = 34;
const imageAreaHeight = Math.round(cardHeight * 0.4);
const imagePaddingX = 72;
const imagePaddingY = 12;
const imageX = cardX + imagePaddingX;
const imageY = cardY + imagePaddingY;
const imageWidth = cardWidth - imagePaddingX * 2;
const imageHeight = imageAreaHeight - imagePaddingY * 2;
const textPaddingX = 72;
const textX = cardX + textPaddingX;
const titleTop = cardY + imageAreaHeight + 46;
const titleSize = 50;
const titleLineHeight = 60;
const titleMaxScore = 19;
const descriptionSize = 24;
const descriptionLineHeight = 34;
const descriptionMaxScore = 40;
const categoryX = cardX + 32;
const categoryY = cardY + 32;
const categoryHeight = 44;
const categoryMinWidth = 82;
const categoryPaddingX = 22;
const categoryRadius = 999;
const categorySize = 22;
const categoryColors: Record<OgImageOptions['category'], string> = {
  Tech: '#f0a23a',
  Life: '#a5c93a',
  CS: '#43b9d8'
};
const require = createRequire(import.meta.url);
const notoSansJpRoot = path.dirname(require.resolve('@fontsource/noto-sans-jp/package.json'));
const publicRoot = path.resolve(process.cwd(), 'public');

function fontPath(weight: FontWeight) {
  return path.join(
    notoSansJpRoot,
    'files',
    `noto-sans-jp-japanese-${weight}-normal.woff`
  );
}

function publicPath(src: string) {
  const relative = src.replace(/^\//, '');
  const resolved = path.resolve(publicRoot, relative);

  if (resolved !== publicRoot && !resolved.startsWith(`${publicRoot}${path.sep}`)) {
    throw new Error(`Invalid thumbnail path: ${src}`);
  }

  return resolved;
}

function score(value: string) {
  return Array.from(value).reduce((sum, char) => sum + (char.charCodeAt(0) < 128 ? 0.55 : 1), 0);
}

function trimTo(value: string, maxScore: number) {
  let output = value.trimEnd();

  while (score(`${output}...`) > maxScore && output.length > 0) {
    output = output.slice(0, -1);
  }

  return `${output.trimEnd()}...`;
}

function wrap(value: string, maxScore: number, maxLines: number) {
  const lines: string[] = [];
  let line = '';

  for (const char of Array.from(value.trim())) {
    if (char === '\n') {
      lines.push(line.trimEnd());
      line = '';
      continue;
    }

    const next = line + char;

    if (line && score(next) > maxScore) {
      lines.push(line.trimEnd());
      line = char.trimStart();
    } else {
      line = next;
    }
  }

  if (line) {
    lines.push(line.trimEnd());
  }

  if (lines.length <= maxLines) {
    return lines;
  }

  return [...lines.slice(0, maxLines - 1), trimTo(lines[maxLines - 1], maxScore)];
}

async function textImage({
  category,
  titleLines,
  descriptionLines,
  descriptionTop
}: {
  category: OgImageOptions['category'];
  titleLines: string[];
  descriptionLines: string[];
  descriptionTop: number;
}) {
  const fontFamily = 'Noto Sans JP';
  const fontStyle = 'normal';
  const fonts = [
    {
      name: fontFamily,
      data: readFileSync(fontPath(400)),
      weight: 400 as const,
      style: fontStyle
    },
    {
      name: fontFamily,
      data: readFileSync(fontPath(500)),
      weight: 500 as const,
      style: fontStyle
    }
  ];
  const textNodes = [
    createElement(
      'div',
      {
        key: 'category',
        style: {
          position: 'absolute',
          left: categoryX,
          top: categoryY,
          display: 'flex',
          alignItems: 'center',
          justifyContent: 'center',
          minWidth: categoryMinWidth,
          height: categoryHeight,
          padding: `0 ${categoryPaddingX}px`,
          borderRadius: categoryRadius,
          backgroundColor: categoryColors[category],
          color: '#fff',
          fontFamily,
          fontSize: categorySize,
          fontWeight: 500,
          lineHeight: 1
        }
      },
      category
    ),
    ...titleLines.map((line, index) =>
      createElement(
        'div',
        {
          key: `title-${index}`,
          style: {
            position: 'absolute',
            left: textX,
            top: titleTop + index * titleLineHeight,
            color: '#222',
            fontFamily,
            fontSize: titleSize,
            fontWeight: 500,
            lineHeight: 1
          }
        },
        line
      )
    ),
    ...descriptionLines.map((line, index) =>
      createElement(
        'div',
        {
          key: `description-${index}`,
          style: {
            position: 'absolute',
            left: textX,
            top: descriptionTop + index * descriptionLineHeight,
            color: '#777',
            fontFamily,
            fontSize: descriptionSize,
            fontWeight: 400,
            lineHeight: 1
          }
        },
        line
      )
    )
  ];
  const svg = await satori(
    createElement(
      'div',
      {
        style: {
          position: 'relative',
          display: 'flex',
          width,
          height,
          backgroundColor: 'transparent'
        }
      },
      textNodes
    ),
    {
      width,
      height,
      fonts
    }
  );

  return sharp(Buffer.from(svg)).png().toBuffer();
}

function backgroundSvg() {
  return Buffer.from(`
    <svg xmlns="http://www.w3.org/2000/svg" width="${width}" height="${height}" viewBox="0 0 ${width} ${height}">
      <defs>
        <clipPath id="thumbnail">
          <rect x="${cardX}" y="${cardY}" width="${cardWidth}" height="${cardHeight}" rx="${cardRadius}"/>
        </clipPath>
      </defs>
      <rect width="${width}" height="${height}" fill="${pageBackground}"/>
      <rect x="${cardX}" y="${cardY}" width="${cardWidth}" height="${cardHeight}" rx="${cardRadius}" fill="${textBackground}"/>
      <g clip-path="url(#thumbnail)">
        <rect x="${cardX}" y="${cardY}" width="${cardWidth}" height="${imageAreaHeight}" fill="${imageBackground}"/>
      </g>
    </svg>
  `);
}

export async function generateOgImage({
  category,
  title,
  description,
  thumbnail
}: OgImageOptions) {
  const titleLines = wrap(title, titleMaxScore, 3);
  const descriptionLines = description ? wrap(description, descriptionMaxScore, 2) : [];
  const descriptionTop = titleTop + titleLines.length * titleLineHeight + 20;
  const renderedText = await textImage({
    category,
    titleLines,
    descriptionLines,
    descriptionTop
  });
  const thumbnailImage = await sharp(publicPath(thumbnail))
    .trim({ threshold: 10 })
    .resize(imageWidth, imageHeight, {
      fit: 'contain',
      background: { r: 0, g: 0, b: 0, alpha: 0 }
    })
    .png()
    .toBuffer();

  return sharp(backgroundSvg())
    .composite([
      { input: thumbnailImage, left: imageX, top: imageY },
      { input: renderedText, left: 0, top: 0 }
    ])
    .png()
    .toBuffer();
}
