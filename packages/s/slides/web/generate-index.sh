#!/bin/bash
# Generate index.html and individual slide pages with OGP
# Usage: ./generate-index.sh <dist_dir>

DIST_DIR="${1:-.}"
SITE_URL="https://slides.momee.mt"

# Generate index.html
cat >"$DIST_DIR/index.html" <<'HEADER'
<!DOCTYPE html>
<html lang="ja" prefix="og: https://ogp.me/ns#">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Slides - momeemt</title>
  <meta name="description" content="momeemt's presentation slides">
  <!-- OGP -->
  <meta property="og:type" content="website">
  <meta property="og:title" content="Slides - momeemt">
  <meta property="og:description" content="momeemt's presentation slides">
  <meta property="og:site_name" content="momeemt slides">
HEADER

# Add first thumbnail as default OG image
first_thumb=$(
  find "$DIST_DIR/thumbnails" -maxdepth 1 -type f -name '*.png' -print 2>/dev/null |
    sort |
    head -n 1 || true
)
if [ -n "$first_thumb" ]; then
  first_name=$(basename "$first_thumb" .png)
  echo "  <meta property=\"og:image\" content=\"${SITE_URL}/thumbnails/${first_name}.png\">" >>"$DIST_DIR/index.html"
fi

cat >>"$DIST_DIR/index.html" <<HEADER2
  <meta property="og:url" content="${SITE_URL}/">
  <!-- Twitter Card -->
  <meta name="twitter:card" content="summary_large_image">
  <meta name="twitter:site" content="@momeemt">
  <style>
    * { box-sizing: border-box; }
    body {
      font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
      max-width: 1200px;
      margin: 0 auto;
      padding: 2rem;
      background: #f5f5f5;
    }
    h1 { color: #333; margin-bottom: 1.5rem; }
    .slides {
      display: grid;
      grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
      gap: 1.5rem;
    }
    .slide-card {
      background: white;
      border-radius: 12px;
      box-shadow: 0 2px 8px rgba(0,0,0,0.1);
      overflow: hidden;
      transition: transform 0.2s, box-shadow 0.2s;
    }
    .slide-card:hover {
      transform: translateY(-4px);
      box-shadow: 0 8px 16px rgba(0,0,0,0.15);
    }
    .slide-thumbnail {
      width: 100%;
      aspect-ratio: 16 / 9;
      object-fit: contain;
      background: #2a2a2a;
      display: block;
    }
    .slide-info {
      padding: 1rem;
    }
    .slide-name {
      font-weight: 600;
      color: #333;
      margin-bottom: 0.75rem;
      font-size: 0.95rem;
      word-break: break-all;
    }
    .slide-actions {
      display: flex;
      gap: 0.5rem;
    }
    .btn {
      padding: 0.4rem 1rem;
      border-radius: 6px;
      font-size: 0.85rem;
      text-decoration: none;
      text-align: center;
      flex: 1;
    }
    .btn-view { background: #4a7c9c; color: white; }
    .btn-view:hover { background: #3a6c8c; }
    .btn-download { background: #666; color: white; }
    .btn-download:hover { background: #555; }
  </style>
</head>
<body>
  <h1>Slides</h1>
  <div class="slides">
HEADER2

# Generate slide cards and individual pages
for pdf in "$DIST_DIR"/*.pdf; do
  [ -f "$pdf" ] || continue
  name=$(basename "$pdf" .pdf)

  # Add card to index
  cat >>"$DIST_DIR/index.html" <<CARD
    <div class="slide-card">
      <a href="/s/${name}/">
        <img class="slide-thumbnail" src="/thumbnails/${name}.png" alt="${name}" loading="lazy">
      </a>
      <div class="slide-info">
        <div class="slide-name">${name}</div>
        <div class="slide-actions">
          <a class="btn btn-view" href="/s/${name}/">View</a>
          <a class="btn btn-download" href="/${name}.pdf" download>Download</a>
        </div>
      </div>
    </div>
CARD

  # Generate individual slide page with OGP
  mkdir -p "$DIST_DIR/s/${name}"
  cat >"$DIST_DIR/s/${name}/index.html" <<SLIDE_PAGE
<!DOCTYPE html>
<html lang="ja" prefix="og: https://ogp.me/ns#">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>${name} - momeemt slides</title>
  <meta name="description" content="${name} - Presentation by momeemt">
  <!-- OGP -->
  <meta property="og:type" content="article">
  <meta property="og:title" content="${name}">
  <meta property="og:description" content="Presentation by momeemt">
  <meta property="og:site_name" content="momeemt slides">
  <meta property="og:image" content="${SITE_URL}/thumbnails/${name}.png">
  <meta property="og:image:width" content="1920">
  <meta property="og:image:height" content="1080">
  <meta property="og:url" content="${SITE_URL}/s/${name}/">
  <!-- Twitter Card -->
  <meta name="twitter:card" content="summary_large_image">
  <meta name="twitter:site" content="@momeemt">
  <meta name="twitter:title" content="${name}">
  <meta name="twitter:description" content="Presentation by momeemt">
  <meta name="twitter:image" content="${SITE_URL}/thumbnails/${name}.png">
  <style>
    * { box-sizing: border-box; margin: 0; padding: 0; }
    html, body { height: 100%; }
    body {
      font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
      background: #1a1a1a;
      display: flex;
      flex-direction: column;
      overflow: hidden;
    }
    .toolbar {
      background: #2d2d2d;
      padding: 0.5rem 1rem;
      display: flex;
      align-items: center;
      gap: 1rem;
      color: white;
      flex-shrink: 0;
    }
    .toolbar a { color: #7cb3f5; text-decoration: none; }
    .toolbar a:hover { text-decoration: underline; }
    .nav-btn {
      background: #404040;
      border: none;
      color: white;
      padding: 0.5rem 1rem;
      border-radius: 4px;
      cursor: pointer;
      font-size: 1rem;
    }
    .nav-btn:hover { background: #505050; }
    .nav-btn:disabled { opacity: 0.5; cursor: not-allowed; }
    .page-info { min-width: 100px; text-align: center; }
    .spacer { flex: 1; }
    .download-btn {
      background: #4a7c4e;
      border: none;
      color: white;
      padding: 0.5rem 1rem;
      border-radius: 4px;
      text-decoration: none;
      font-size: 0.9rem;
    }
    .download-btn:hover { background: #5a8c5e; }
    .viewer-container {
      flex: 1;
      overflow: hidden;
      display: flex;
      justify-content: center;
      align-items: center;
      padding: 1rem;
    }
    .viewer-container canvas {
      max-width: 100%;
      max-height: 100%;
      box-shadow: 0 4px 20px rgba(0,0,0,0.5);
    }
    body.scroll-mode { overflow: auto; }
    body.scroll-mode .viewer-container {
      flex: none;
      overflow: visible;
      flex-direction: column;
      align-items: center;
      justify-content: flex-start;
      gap: 1rem;
      padding: 1rem;
    }
    body.scroll-mode .viewer-container canvas {
      max-height: none;
      width: 100%;
      max-width: 100%;
      box-shadow: 0 2px 10px rgba(0,0,0,0.5);
    }
    body.scroll-mode .nav-controls { display: none; }
    .nav-controls { display: flex; align-items: center; gap: 1rem; }
    .loading {
      color: white;
      font-size: 1.2rem;
      display: flex;
      align-items: center;
      justify-content: center;
      height: 100%;
    }
  </style>
</head>
<body>
  <div class="toolbar">
    <a href="/">← Back to list</a>
    <div class="spacer"></div>
    <div class="nav-controls">
      <button class="nav-btn" id="prev-btn">◀ Prev</button>
      <span class="page-info"><span id="page-num">1</span> / <span id="page-count">-</span></span>
      <button class="nav-btn" id="next-btn">Next ▶</button>
    </div>
    <div class="spacer"></div>
    <a class="download-btn" href="/${name}.pdf" download>Download PDF</a>
  </div>
  <div class="viewer-container" id="viewer-container">
    <div class="loading">Loading...</div>
  </div>
  <script type="module">
    const pdfjsLib = await import('https://cdnjs.cloudflare.com/ajax/libs/pdf.js/4.0.379/pdf.min.mjs');
    pdfjsLib.GlobalWorkerOptions.workerSrc = 'https://cdnjs.cloudflare.com/ajax/libs/pdf.js/4.0.379/pdf.worker.min.mjs';

    const pdfFile = '${name}.pdf';
    const pdfDoc = await pdfjsLib.getDocument({
      url: '/' + pdfFile,
      cMapUrl: 'https://cdn.jsdelivr.net/npm/pdfjs-dist@4.0.379/cmaps/',
      cMapPacked: true,
      standardFontDataUrl: 'https://cdn.jsdelivr.net/npm/pdfjs-dist@4.0.379/standard_fonts/',
    }).promise;

    document.getElementById('page-count').textContent = pdfDoc.numPages;

    const container = document.getElementById('viewer-container');
    const isPortrait = () => window.innerHeight > window.innerWidth;

    let currentMode = null;
    let pageNum = 1;

    const canvasA = document.createElement('canvas');
    const canvasB = document.createElement('canvas');
    const ctxA = canvasA.getContext('2d');
    const ctxB = canvasB.getContext('2d');
    let activeCanvas = canvasA;
    let backCanvas = canvasB;
    let activeCtx = ctxA;
    let backCtx = ctxB;

    async function renderSlidePage(num) {
      const page = await pdfDoc.getPage(num);
      const scale = 2;
      const viewport = page.getViewport({ scale });
      backCanvas.height = viewport.height;
      backCanvas.width = viewport.width;
      await page.render({ canvasContext: backCtx, viewport }).promise;
      [activeCanvas, backCanvas] = [backCanvas, activeCanvas];
      [activeCtx, backCtx] = [backCtx, activeCtx];
      container.innerHTML = '';
      container.appendChild(activeCanvas);
      document.getElementById('page-num').textContent = num;
      document.getElementById('prev-btn').disabled = num <= 1;
      document.getElementById('next-btn').disabled = num >= pdfDoc.numPages;
    }

    async function renderScrollMode() {
      container.innerHTML = '';
      for (let i = 1; i <= pdfDoc.numPages; i++) {
        const page = await pdfDoc.getPage(i);
        const scale = 2;
        const viewport = page.getViewport({ scale });
        const canvas = document.createElement('canvas');
        canvas.height = viewport.height;
        canvas.width = viewport.width;
        const ctx = canvas.getContext('2d');
        container.appendChild(canvas);
        page.render({ canvasContext: ctx, viewport });
      }
      window.scrollTo(0, 0);
    }

    async function initSlideMode() {
      await renderSlidePage(pageNum);
    }

    async function updateMode() {
      const newMode = isPortrait() ? 'scroll' : 'slide';
      if (newMode === currentMode) return;
      currentMode = newMode;
      if (newMode === 'scroll') {
        document.body.classList.add('scroll-mode');
        await renderScrollMode();
      } else {
        document.body.classList.remove('scroll-mode');
        await initSlideMode();
      }
    }

    function prevPage() {
      if (currentMode === 'slide' && pageNum > 1) {
        pageNum--;
        renderSlidePage(pageNum);
      }
    }

    function nextPage() {
      if (currentMode === 'slide' && pageNum < pdfDoc.numPages) {
        pageNum++;
        renderSlidePage(pageNum);
      }
    }

    document.getElementById('prev-btn').addEventListener('click', prevPage);
    document.getElementById('next-btn').addEventListener('click', nextPage);

    document.addEventListener('keydown', (e) => {
      if (currentMode !== 'slide') return;
      if (e.key === 'ArrowLeft' || e.key === 'ArrowUp') {
        prevPage();
      } else if (e.key === 'ArrowRight' || e.key === 'ArrowDown' || e.key === ' ') {
        e.preventDefault();
        nextPage();
      }
    });

    let resizeTimeout;
    window.addEventListener('resize', () => {
      clearTimeout(resizeTimeout);
      resizeTimeout = setTimeout(updateMode, 150);
    });

    await updateMode();
  </script>
</body>
</html>
SLIDE_PAGE
done

cat >>"$DIST_DIR/index.html" <<'FOOTER'
  </div>
</body>
</html>
FOOTER
