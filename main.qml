import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15

Window {
    id: root

    property bool isLost : false
    width: 300
    height: 600
    visible: true
    title: isLost ? "LOST_LOST_LOST" : "SQUARE FALLDOWN 2"
    color: isLost ? "red" : "lightgray"

    function getRandomInt(max) {
      return Math.round(Math.random() * max);
    }

    Component.onCompleted: {
        dropTimer.start()
        spawnTimer.start()
    }

    Timer {
        id: dropTimer
        interval: 100
        repeat: true
    }

    Timer {
        id: spawnTimer
        interval: getRandomInt(900) + 100;
        onTriggered: {
            interval = getRandomInt(900) + 100;
            tile.createObject(root, {_x: getRandomInt(root.width -30),
                                     _y: getRandomInt(100),
                                    speed: getRandomInt(7)+2});
            start();
        }
    }

    Component {
        id: tile
        Button {
            id: backRect

            property int speed: 1
            property alias _x: backRect.x
            property alias _y: backRect.y

            width: 30
            height: 30
            hoverEnabled: true

            function moveDown () {
                backRect.y += backRect.hovered ? 2 * backRect.speed : backRect.speed
            }

            background: Rectangle {
                radius: 6
                border {
                    width: 2
                    color: "black"
                }
            }

            Connections {
                target: dropTimer
                function onTriggered() {backRect.moveDown()}
            }

            onClicked :{
                if (!root.isLost) {
                    backRect.destroy()
                }
            }

            onYChanged: {
                if ((backRect.y + backRect.height) >= root.height) {
                    root.isLost = true;
                }
                if ((backRect.y) >= root.height){
                    backRect.destroy()
                }
            }
        }
    }
}
