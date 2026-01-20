const canvas = document.querySelector('#canvas')
const readout = document.querySelector('#readout')
const context = canvas.getContext('2d')
const spritesheet = new Image()

const windowToCanvas = (canvas, x, y) => {
  const bbox = canvas.getBoundingClientRect()
  return {
    x: (x - bbox.left) * (canvas.width / bbox.width),
    y: (y - bbox.top) * (canvas.height / bbox.height)
  }
}

const drawBackground = () => {
  const VERTICAL_LINE_SPACING = 12
  let height = context.canvas.height

  context.clearRect(0, 0, canvas.width, canvas.height)
  context.strokeStyle = 'lightgray'
  context.lineWidth = 0.5

  while (height > VERTICAL_LINE_SPACING * 4) {
    context.beginPath()
    context.moveTo(0, height)
    context.lineTo(context.canvas.width, height)
    context.stroke()
    height -= VERTICAL_LINE_SPACING
  }
}

const drawSpritesheet = () => {
  context.drawImage(spritesheet, 0, 0)
}

const drawGuidelines = (x, y) => {
  context.strokeStyle = 'rgba(0, 0, 230, 0.8)'
  context.lineWidth = 0.5
  drawVerticalLine(x)
  drawHorizontalLine(y)
}

const updateReadout = (x, y) => {
  if (x.toFixed(0) === y.toFixed(0)) {
    readout.innerHTML = `(${x.toFixed(0)}, ${y.toFixed(0)}) same number! cool!`
  } else {
    readout.innerHTML = `(${x.toFixed(0)}, ${y.toFixed(0)})`
  }
}

const drawHorizontalLine = (y) => {
  context.beginPath()
  context.moveTo(0, y+0.5)
  context.lineTo(context.canvas.width, y+0.5)
  context.stroke()
}

const drawVerticalLine = (x) => {
  context.beginPath()
  context.moveTo(x+0.5, 0)
  context.lineTo(x+0.5, context.canvas.height)
  context.stroke()
}

canvas.onmousemove = (e) => {
  const loc = windowToCanvas(canvas, e.clientX, e.clientY)

  drawBackground()
  drawSpritesheet()
  drawGuidelines(loc.x, loc.y)
  updateReadout(loc.x, loc.y)
}

canvas.onclick = (e) => {
  const loc = windowToCanvas(canvas, e.clientX, e.clientY)
  readout.innerHTML = `(click to ${loc.x.toFixed(0)}, ${loc.y.toFixed(0)})!`
}

spritesheet.src = '../assets/running-sprite-sheet.png'
spritesheet.onload = (e) => {
  drawSpritesheet()
}
drawBackground()
