<!DOCTYPE html>

<html lang="ko">

<head>

<meta charset="utf-8" />

<meta name="viewport" content="width=device-width, initial-scale=1" />

<title>이벤트 룰렛 게임</title>

<style>

  :root{

    --glass-bg: rgba(255,255,255,0.12);

    --glass-brd: rgba(255,255,255,0.25);

    --shadow: 0 20px 60px rgba(0,0,0,0.25);

    --accent: #7c3aed; /* 보라 */

    --accent-2: #22d3ee; /* 하늘 */

    --ok: #16a34a;

    --danger: #ef4444;

  }

  * { box-sizing: border-box; }

  html, body {
    width: 100vw;

    height: 100vh;

    position: fixed;

    overflow-y: auto;

    margin: 0;

    font-family: ui-sans-serif, system-ui, -apple-system, "Segoe UI", Roboto, "Apple SD Gothic Neo", "Noto Sans KR", "Malgun Gothic", Arial, "Helvetica Neue", sans-serif;

    color: #1f2937;

    background:

      radial-gradient(1200px 800px at 15% 20%, rgba(124,58,237,0.18), transparent 60%),

      radial-gradient(1000px 700px at 85% 30%, rgba(34,211,238,0.20), transparent 60%),

      linear-gradient(180deg, #0b1220, #0f172a 40%, #0b1220 100%);

  }

  .wrap {
    position: relative;

    display: flex;

    align-items: center;

    justify-content: center;

    width: 100%;

    min-height: 100%;

    padding: 40px 0;

  }

  .card {

    position: relative;

    width: min(92vw, 760px);

    padding: 28px 24px 32px;

    border-radius: 24px;

    background: linear-gradient(180deg, rgba(255,255,255,0.22), rgba(255,255,255,0.06));

    border: 1px solid var(--glass-brd);

    backdrop-filter: blur(10px);

    box-shadow: var(--shadow);

  }

  .title {

    display: flex; align-items: center; gap: 12px;

    font-weight: 800; color: white; letter-spacing: .4px;

    margin: 0 0 18px;

  }

  .title .dot {

    width: 12px; height: 12px; border-radius: 50%;

    background: radial-gradient(circle at 30% 30%, #fff, #ffd166 40%, #f97316 70%, #ef4444 100%);

    box-shadow: 0 0 10px rgba(255,255,255,.6);

  }

  .stage {

    display: grid;

    grid-template-columns: 1fr;

    gap: 18px;

  }

  .wheel-area {

    place-self: center;

    position: relative;

    width: min(80vw, 420px);

    aspect-ratio: 1/1;

    display: grid; place-items: center;

  }

  /* 고정 포인터 (상단) */

  .pointer {

    position: absolute;

    top: -6px; left: 50%; transform: translateX(-50%);

    width: 0; height: 0;

    border-left: 18px solid transparent;

    border-right: 18px solid transparent;

    border-bottom: 28px solid #f43f5e;

    filter: drop-shadow(0 4px 10px rgba(0,0,0,0.45));

  }

  .pointer::after{

    content:"";

    position: absolute; left: -12px; top: 20px;

    width: 24px; height: 8px; border-radius: 6px;

    background: linear-gradient(180deg, #fee2e2, #fecaca);

  }

  /* 캔버스 휠 */

  .wheel {

    width: 100%; height: 100%;

    border-radius: 50%;

    background:

      radial-gradient(circle at 30% 30%, rgba(255,255,255,0.35), rgba(255,255,255,0) 60%),

      radial-gradient(circle at 70% 70%, rgba(255,255,255,0.15), rgba(255,255,255,0) 60%),

      #0b1220;

    box-shadow:

      inset 0 0 0 10px rgba(255,255,255,0.06),

      inset 0 0 0 22px rgba(0,0,0,0.28),

      0 18px 40px rgba(0,0,0,0.35);

    transition: transform 4.2s cubic-bezier(.16,1,.3,1);

    will-change: transform;

  }

  /* 중앙 캡 */

  .cap {

    position: absolute; width: 18%;

    aspect-ratio: 1 / 1;

    border-radius: 50%;

    background:

      radial-gradient(circle at 30% 30%, #ffffff, #c7d2fe 45%, #6366f1 75%);

    box-shadow:

      inset 0 4px 12px rgba(255,255,255,0.7),

      0 10px 24px rgba(0,0,0,0.45);

  }

  .cap::after{

    content:"";

    position: absolute; inset: 8%;

    border-radius: 50%;

    background:

      radial-gradient(circle at 30% 30%, #fef3c7, #fde68a 50%, #f59e0b);

    box-shadow: inset 0 2px 8px rgba(0,0,0,0.25);

  }

  /* 컨트롤 */

  .controls {

    display: grid; gap: 12px;

    justify-items: center;

    margin-top: 6px;

  }

  .btn {

    appearance: none; user-select: none; cursor: pointer;

    border: none; border-radius: 14px;

    padding: 14px 22px; font-weight: 700; font-size: 16px; letter-spacing:.3px;

    color: white;

    background: linear-gradient(135deg, var(--accent), var(--accent-2));

    box-shadow: 0 10px 28px rgba(124,58,237,.35);

    transition: transform .08s ease, box-shadow .2s ease, opacity .2s ease;

  }

  .btn:active { transform: translateY(1px) scale(0.99); }

  .btn:disabled { opacity: .55; cursor: not-allowed; filter: grayscale(.2); }

  .labels {

    font-size: 12px; color: #cbd5e1; text-align: center;

  }

  /* 결과 토스트 */

  .toast {

    position: fixed; left: 50%; bottom: 28px; transform: translateX(-50%) translateY(20px);

    min-width: min(90vw, 360px);

    padding: 14px 16px; border-radius: 12px;

    color: #0b1220; font-weight: 800; text-align: center;

    background: linear-gradient(180deg, #e0f2fe, #f0f9ff);

    border: 1px solid rgba(255,255,255,0.65);

    box-shadow: 0 12px 30px rgba(0,0,0,0.25);

    opacity: 0; pointer-events: none;

    transition: opacity .25s ease, transform .25s ease;

  }

  .toast.show { opacity: 1; transform: translateX(-50%) translateY(0); }

  /* 컨페티 캔버스 */

  #confettiCanvas {

    position: fixed; inset: 0; pointer-events: none;

  }

  /* 푸터 텍스트 */

  .hint { margin-top: 2px; font-size: 12px; color: #94a3b8; text-align: center; }

</style>

</head>

<body>

<canvas id="confettiCanvas"></canvas>

<div class="wrap">

  <div class="card">

    <h1 class="title"><span class="dot"></span>이벤트 룰렛</h1>

    <div class="stage">

      <div class="wheel-area">

        <div class="pointer" aria-hidden="true"></div>

        <canvas id="wheel" class="wheel" width="900" height="900" aria-label="룰렛 휠"></canvas>

        <div class="cap" aria-hidden="true"></div>

      </div>

      <div class="controls">

        <button id="spinBtn" class="btn">돌리기 🎡</button>

        <div class="labels">상단 붉은 포인터 방향이 당첨입니다</div>

        <div class="hint">경품은 코드 상단 <code>options</code> 배열을 수정하세요.</div>

      </div>

    </div>

  </div>

</div>

<div id="toast" class="toast" role="status" aria-live="polite">결과: -</div>

<script>

  /***************

   * 설정 영역

   ***************/

  const options = [

    "1등(아이패드)",

    "2등(에어팟)",

    "음료쿠폰",

    "꽝",

    "기프티콘 5천원",

    "사은품 A",

    "커피쿠폰 2매",

    "꽝",

  ];

  // 스타일 팔레트 (슬라이스 색)

  const sliceColors = [

    "#fca5a5", "#fde68a", "#86efac", "#93c5fd",

    "#f5d0fe", "#fcd34d", "#a7f3d0", "#c4b5fd"

  ];

  // 텍스트 색상 자동 대비

  function pickTextColor(bg){

    try{

      const c = bg.startsWith("#") ? bg.substring(1) : bg;

      const r = parseInt(c.substr(0,2),16), g = parseInt(c.substr(2,2),16), b = parseInt(c.substr(4,2),16);

      const yiq = (r*299 + g*587 + b*114) / 1000;

      return yiq >= 140 ? "#0b1220" : "#ffffff";

    } catch { return "#111827"; }

  }

  /***************

   * 휠 그리기

   ***************/

  const wheelCanvas = document.getElementById("wheel");

  const wctx = wheelCanvas.getContext("2d");

  const deviceRatio = Math.max(1, Math.min(2, window.devicePixelRatio || 1));

  // 고해상도 렌더링

  (function scaleCanvas(){

    const size = 900;

    wheelCanvas.width = size * deviceRatio;

    wheelCanvas.height = size * deviceRatio;

    wheelCanvas.style.width = "100%";

    wheelCanvas.style.height = "100%";

    console.log(wheelCanvas)
    wctx.setTransform(deviceRatio, 0, 0, deviceRatio, 0, 0);

  })();

  const center = { x: wheelCanvas.width / (2*deviceRatio), y: wheelCanvas.height / (2*deviceRatio) };

  const radius = Math.min(center.x, center.y) - 12;

  function drawWheel(){

    const n = options.length;

    const slice = (Math.PI * 2) / n;

    wctx.clearRect(0,0,wheelCanvas.width, wheelCanvas.height);

    // 바닥 원(광택)

    const baseGrad = wctx.createRadialGradient(center.x*0.75, center.y*0.75, radius*0.1, center.x, center.y, radius);

    baseGrad.addColorStop(0, "rgba(255,255,255,0.45)");

    baseGrad.addColorStop(1, "rgba(255,255,255,0.02)");

    wctx.fillStyle = baseGrad;

    wctx.beginPath();

    wctx.arc(center.x, center.y, radius, 0, Math.PI*2);

    wctx.fill();

    for(let i=0;i<n;i++){

      const start = -Math.PI/2 + i*slice; // 위쪽(포인터 방향)부터 시계방향

      const end   = start + slice;

      // 슬라이스

      const color = sliceColors[i % sliceColors.length];

      wctx.beginPath();

      wctx.moveTo(center.x, center.y);

      wctx.arc(center.x, center.y, radius, start, end);

      wctx.closePath();

      const grad = wctx.createLinearGradient(center.x, center.y - radius, center.x, center.y + radius);

      grad.addColorStop(0, color);

      grad.addColorStop(1, shade(color, -12));

      wctx.fillStyle = grad;

      wctx.fill();

      // 경계선

      wctx.strokeStyle = "rgba(0,0,0,0.2)";

      wctx.lineWidth = 1.2;

      wctx.beginPath();

      wctx.moveTo(center.x, center.y);

      wctx.arc(center.x, center.y, radius, start, end);

      wctx.lineTo(center.x, center.y);

      wctx.stroke();

      // 텍스트

      const mid = start + slice/2;

      wctx.save();

      wctx.translate(center.x, center.y);

      wctx.rotate(mid);

      wctx.textAlign = "right";

      wctx.textBaseline = "middle";


      wctx.fillStyle = pickTextColor(color);

      fitText(options[i], radius*0.78, 38, 12);

      wctx.restore();

    }

    // 외곽 링

    wctx.beginPath();

    wctx.arc(center.x, center.y, radius, 0, Math.PI*2);

    wctx.strokeStyle = "rgba(255,255,255,0.65)";

    wctx.lineWidth = 10;

    wctx.stroke();

  }

  function fitText(str, maxX, baseSize, minSize){

    let size = baseSize;

    wctx.font = `700 ${size}px/1 "Pretendard", "Apple SD Gothic Neo", "Noto Sans KR", system-ui, sans-serif`;

    while(wctx.measureText(str).width > maxX && size > minSize){

      size -= 1;

      wctx.font = `700 ${size}px/1 "Pretendard", "Apple SD Gothic Neo", "Noto Sans KR", system-ui, sans-serif`;

    }

    wctx.fillText(str, radius*0.9, 0); // 오른쪽 정렬 상태

  }

  // 색상 명도 조절

  function shade(hex, percent){

    const f = parseInt(hex.slice(1),16),

          t = percent < 0 ? 0 : 255,

          p = Math.abs(percent)/100,

          R = f>>16, G=f>>8&0x00FF, B=f&0x0000FF;

    const to = c => Math.round((t - c)*p) + c;

    return `#${(0x1000000 + (to(R)<<16) + (to(G)<<8) + to(B)).toString(16).slice(1)}`;

  }

  drawWheel();

  /***************

   * 스핀 로직

   ***************/

  const spinBtn = document.getElementById("spinBtn");

  const toast = document.getElementById("toast");

  let spinning = false;

  let currentRotation = 0; // 누적 회전 각도 (deg)

  spinBtn.addEventListener("click", () => {

    if(spinning) return;

    spinning = true;

    spinBtn.disabled = true;

    const n = options.length;

    const sliceDeg = 360 / n;

    // 결과를 먼저 선택해 해당 칸의 중앙에 멈추도록 계산

    const chosenIndex = Math.floor(Math.random() * n);

    const randNudge = (Math.random() - 0.5) * (sliceDeg * 0.28); // 중앙에서 약간 무작위 오프셋

    // 포인터는 0deg(상단). index i 중앙각이 포인터에 오도록 휠을 역으로 회전.

    // start가 -90deg에서 시작하므로, index i 중앙은: -90 + i*sliceDeg + sliceDeg/2

    const targetAtTop = -90 + chosenIndex*sliceDeg + sliceDeg/2 + randNudge;

    // 현재 회전을 고려하여 앞으로 돌 각도 계산 (최소 3~5바퀴)

    const baseTurns = 360 * (3 + Math.floor(Math.random()*3)); // 3~5바퀴

    // 휠을 시계방향으로 돌리면 deg 증가 → 포인터 기준으로는 반대 방향이므로

    // 최종 목표 각도 = baseTurns + (360 - (targetAtTop mod 360))

    const normalizedTarget = ((targetAtTop % 360) + 360) % 360;

    const finalRotation = baseTurns + (360 - normalizedTarget);

    currentRotation = finalRotation;

    // 애니메이션

    wheelCanvas.style.transition = "transform 4.2s cubic-bezier(.16,1,.3,1)";

    wheelCanvas.style.transform = `rotate(${finalRotation}deg)`;

    // 스핀 종료 처리

    const duration = 4200;

    setTimeout(() => {

      spinning = false;

      spinBtn.disabled = false;

      // 안전을 위해 실제 최종 각도로부터 index 재계산 (표시용)

      const finalDeg = ((currentRotation % 360) + 360) % 360; // 0~359

      // 포인터 기준 슬라이스 계산: 우리가 그릴 때 시작을 -90으로 잡았으니 보정

      const effective = (360 - (finalDeg - 0) + 270) % 360; // +270 == -90 보정

      const idx = Math.floor(effective / sliceDeg) % n;

      const result = options[idx];

      showToast(`🎉 결과: ${result}`);

      burstConfetti();

    }, duration + 30);

  });

  function showToast(text){

    toast.textContent = text;

    toast.classList.add("show");

    setTimeout(()=> toast.classList.remove("show"), 2600);

  }

  /***************

   * 컨페티 (경량)

   ***************/

  const confettiCanvas = document.getElementById("confettiCanvas");

  const cctx = confettiCanvas.getContext("2d");

  function resizeConfetti(){

    confettiCanvas.width = innerWidth;

    confettiCanvas.height = innerHeight;

  }

  addEventListener("resize", resizeConfetti);

  resizeConfetti();

  function burstConfetti(){

    const pieces = [];

    const count = 140;

    for(let i=0;i<count;i++){

      pieces.push({

        x: innerWidth/2 + (Math.random()*120 - 60),

        y: innerHeight*0.35,

        r: Math.random()*6 + 3,

        a: Math.random()*Math.PI*2,

        vx: (Math.random()-0.5) * 6,

        vy: -Math.random()*8 - 6,

        g: 0.22 + Math.random()*0.08,

        c: sliceColors[i % sliceColors.length]

      });

    }

    const start = performance.now();

    (function animate(t){

      const dt = (t - start) / 1000;

      cctx.clearRect(0,0,confettiCanvas.width, confettiCanvas.height);

      pieces.forEach(p => {

        p.vy += p.g;

        p.x += p.vx;

        p.y += p.vy;

        p.a += 0.15;

        cctx.save();

        cctx.translate(p.x, p.y);

        cctx.rotate(p.a);

        cctx.fillStyle = p.c;

        cctx.fillRect(-p.r, -p.r*0.6, p.r*2, p.r*1.2);

        cctx.restore();

      });

      if(dt < 2.2) requestAnimationFrame(animate);

      else cctx.clearRect(0,0,confettiCanvas.width, confettiCanvas.height);

    })(start);

  }

</script>

</body>

</html>