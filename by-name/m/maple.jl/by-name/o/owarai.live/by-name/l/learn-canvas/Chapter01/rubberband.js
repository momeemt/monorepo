const canvas = document.getElementById('canvas')
const context = canvas.getContext('2d')
const rubberbandDiv = document.getElementById('rubberbandDiv')
const resetButton = document.getElementById('resetButton')
const image = new Image()
const mousedown = {}
let rubberbandRectangle = {}
let dragging = false

const rubberbandStart = (x, y) => {
  mousedown.x = x
  mousedown.y = y
  rubberbandRectangle.left = mousedown.x
  rubberbandRectangle.top = mousedown.y
  moveRubberbandDiv()
  showRubberbandDiv()
  dragging = true
}

const rubberbandStretch = (x, y) => {
  rubberbandRectangle.left = x < mousedown.x ? x : mousedown.x
  rubberbandRectangle.top = y < mousedown.y ? y : mousedown.y
  rubberbandRectangle.width = Math.abs(x - mousedown.x)
  rubberbandRectangle.height = Math.abs(y - mousedown.y)
  moveRubberbandDiv()
  resizeRubberbandDiv()
}

const rubberbandEnd = () => {
  const bbox = canvas.getBoundingClientRect()
  try {
    context.drawImage(
      canvas,
      rubberbandRectangle.left - bbox.left,
      rubberbandRectangle.top - bbox.top,
      rubberbandRectangle.width,
      rubberbandRectangle.height,
      0,
      0,
      canvas.width,
      canvas.height
    )
  } catch (e) {
    // 公式が握り潰しているんだが
  }
  resetRubberbandRectangle()
  rubberbandDiv.style.width = '0'
  rubberbandDiv.style.height = '0'
  hideRubberbandDiv()
  dragging = false
}

const moveRubberbandDiv = () => {
  rubberbandDiv.style.top = rubberbandRectangle.top.toString() + 'px'
  rubberbandDiv.style.left = rubberbandRectangle.left.toString() + 'px'
}

const resizeRubberbandDiv = () => {
  rubberbandDiv.style.width = rubberbandRectangle.width.toString() + 'px'
  rubberbandDiv.style.height = rubberbandRectangle.height.toString() + 'px'
}

const showRubberbandDiv = () => {
  rubberbandDiv.style.display = 'inline'
}

const hideRubberbandDiv = () => {
  rubberbandDiv.style.display = 'none'
}

const resetRubberbandRectangle = () => {
  rubberbandRectangle = {
    top: 0,
    left: 0,
    width: 0,
    height: 0
  }
}

canvas.onmousedown = (e) => {
  const x = e.x || e.clientX
  const y = e.y || e.clientY
  e.preventDefault()
  rubberbandStart(x, y)
}

window.onmousemove = (e) => {
  const x = e.x || e.clientX
  const y = e.y || e.clientY
  e.preventDefault()
  if (dragging) {
    rubberbandStretch(x, y)
  }
}

window.onmouseup = (e) => {
  e.preventDefault()
  rubberbandEnd()
}

image.onload = () => {
  context.drawImage(image, 0, 0, canvas.width, canvas.height)
}

resetButton.onclick = (e) => {
  context.clearRect(0, 0, context.canvas.width, context.canvas.height)
  context.drawImage(image, 0, 0, canvas.width, canvas.height)
}

image.src = '../assets/arch.png'
