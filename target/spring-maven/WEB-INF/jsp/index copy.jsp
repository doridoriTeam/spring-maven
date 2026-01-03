<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <!DOCTYPE html>
    <html lang="ko">

    <head>
        <meta charset="UTF-8" />
        <title>Winwheel 룰렛 (정확한 CDN)</title>
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
        <script src="http://cdnjs.cloudflare.com/ajax/libs/gsap/latest/TweenMax.min.js"></script>
        <script src="../../js/Winwheel.js"></script>

        <style>
            body {
                display: flex;
                flex-direction: column;
                align-items: center;
                justify-content: center;
                height: 100vh;
                background: #f0f0f0;
                font-family: Arial, sans-serif;
            }

            #canvas-container {
                position: relative;
            }

            canvas {
                border: 2px solid #333;
            }

            #spin-btn {
                margin-top: 20px;
                padding: 10px 20px;
                font-size: 16px;
                cursor: pointer;
            }

            #result {
                margin-top: 15px;
                font-size: 20px;
                font-weight: bold;
            }
        </style>
    </head>

    <body>
        <div id="canvas-container">
            <canvas id="wheel" width="500" height="500"></canvas>
        </div>
        <button id="spin-btn">Spin!</button>
        <div id="result"></div>

        <script>
            $(function () {
                const theWheel = new Winwheel({
                    canvasId: 'wheel',
                    numSegments: 8,
                    outerRadius: 200,
                    innerRadius: 50,
                    textFontSize: 16,
                    segments: [
                        { fillStyle: '#eae56f', text: '1번' },
                        { fillStyle: '#89f26e', text: '2번' },
                        { fillStyle: '#7de6ef', text: '3번' },
                        { fillStyle: '#e7706f', text: '4번' },
                        { fillStyle: '#f3a43b', text: '5번' },
                        { fillStyle: '#ff6384', text: '6번' },
                        { fillStyle: '#36a2eb', text: '7번' },
                        { fillStyle: '#4bc0c0', text: '8번' }
                    ],
                    animation: {
                        type: 'spinToStop',
                        duration: 5,
                        spins: 8,
                        callbackFinished: alertPrize,
                        easing: 'Power2.easeInOut'
                    }
                });

                $('#spin-btn').click(function () {
                    $('#result').text('돌리는 중...');
                    theWheel.startAnimation();
                });

                function alertPrize(indicatedSegment) {
                    $('#result').text('당첨: ' + indicatedSegment.text);
                }
            });
        </script>

    </body>

    </html>