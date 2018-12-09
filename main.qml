import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Window 2.2
import QtQuick.Particles 2.0
import "MyScript.js" as MyScript

Window {
    id: root
    title: qsTr("Hockey")
    width: 600
    height: 400

    maximumWidth : width
    minimumWidth : width
    minimumHeight : height
    maximumHeight : height

    visible: true

    property bool isGameStarted: false

    property int leftWins: 0
    property int rightWins: 0

    Rectangle {
        id: circle
        width: 200
        height: width
        radius: width/2
        x: root.width/2-radius
        y: root.height/2-radius
        color: "black"

    }
    Rectangle {
        id: insideCircle
        width: 196
        height: width
        radius: width/2
        x: root.width/2-radius
        y: root.height/2-radius
        color: "white"
    }
    Rectangle {
        id: line
        width: 4
        height: root.height
        x: root.width/2-width/2
        y: 0
        color: "black"
    }


    Rectangle {
        id: leftpaddle
        color: "red"
        width: 10
        height: 100
        radius: width/2

        anchors.left: parent.left
        y: parent.height/2 - height/2

        Affector {
            anchors.fill: parent
            height: 5
            system: ps
            onAffectParticles: {
                var ySpeedFactor = 0.2;
                var roundedPadFactor = 0.2;
                var xSpeedFactor = 0.8;
                for (var i=0; i<particles.length; i++) {
                    particles[i].vx *= -1;
                    if(particles[i].y - leftpaddle.y<= roundedPadFactor * leftpaddle.height){
                        particles[i].vy -= Math.abs(particles[i].vy)*ySpeedFactor;
                        particles[i].vx *= xSpeedFactor;
                    }
                    else if(particles[i].y - leftpaddle.y >= (1-roundedPadFactor) * leftpaddle.height){
                        particles[i].vy += Math.abs(particles[i].vy)*ySpeedFactor;
                        particles[i].vx *= xSpeedFactor;
                    }
                }
            }
        }

        Behavior on y { NumberAnimation { duration: 100 } }
    }

    Rectangle {
        id: rightpaddle
        color: "blue"
        width: 10
        height: 100
        radius: width/2

        anchors.right: parent.right
        y: parent.height/2 - height/2

        Affector {
            anchors.fill: parent
            height: 5
            system: ps
            onAffectParticles: {
                var ySpeedFactor = 0.2;
                var roundedPadFactor = 0.2;
                var xSpeedFactor = 0.8;
                for (var i=0; i<particles.length; i++) {
                    particles[i].vx *= -1;
                    if(particles[i].y - rightpaddle.y<= roundedPadFactor * rightpaddle.height){
                        particles[i].vy -= Math.abs(particles[i].vy)*ySpeedFactor;
                        particles[i].vx *= xSpeedFactor;
                    }
                    else if(particles[i].y - rightpaddle.y >= (1-roundedPadFactor) * rightpaddle.height){
                        particles[i].vy += Math.abs(particles[i].vy)*ySpeedFactor;
                        particles[i].vx *= xSpeedFactor;
                    }
                }
            }
        }

        Behavior on y { NumberAnimation { duration: 100 } }
    }

    Item {
        focus: true
        property int delta: 40
        Keys.onPressed: {
            if (event.key === Qt.Key_W) {
                if(leftpaddle.y >= 0)
                    leftpaddle.y = leftpaddle.y - delta
                if(leftpaddle.y <= 0)
                    leftpaddle.y = 0
            }
            if (event.key === Qt.Key_S) {
                if(leftpaddle.y + leftpaddle.height <= root.height)
                    leftpaddle.y = leftpaddle.y + delta
                if(leftpaddle.y + leftpaddle.height >= root.height)
                    leftpaddle.y = root.height - leftpaddle.height
            }
            if (event.key === Qt.Key_Up) {
                if(rightpaddle.y >= 0)
                    rightpaddle.y = rightpaddle.y - delta
                if(rightpaddle.y <= 0)
                    rightpaddle.y = 0
            }
            if (event.key === Qt.Key_Down) {
                if(rightpaddle.y + rightpaddle.height <= root.height)
                   rightpaddle.y = rightpaddle.y + delta
                if(rightpaddle.y + rightpaddle.height >= root.height)
                    rightpaddle.y = root.height - rightpaddle.height
            }
            if (event.key === Qt.Key_Space){
                if(isGameStarted === false){
                    emitter.burst(1)
                    isGameStarted = true
                }
            }
        }
    }

    ParticleSystem {
        id: ps
    }
    ItemParticle {
        system: ps
        fade: false
        delegate: Rectangle {
            width: 25
            height: width
            color: "black"
            radius: width/2
        }
    }
    Emitter {
        id: emitter
        system: ps
        emitRate: 0
        anchors.centerIn: parent
        lifeSpan: Emitter.InfiniteLife
        velocity: AngleDirection {
            property int randSeed: leftWins+rightWins+leftpaddle.y+rightpaddle.y
            angle: MyScript.getRandomAngle(randSeed)
            magnitude: MyScript.getRandomMagnitude(240,360,randSeed)
        }
    }
    // Górna krawędź
    Affector {
        anchors { left: parent.left; right: parent.right; top: parent.top }
        height: 5
        system: ps

        onAffectParticles: {
            for (var i=0; i<particles.length; i++) {
                particles[i].vy *= -1;
            }
        }
    }

    // Dolna krewędź
    Affector {
        anchors { left: parent.left; right: parent.right; bottom: parent.bottom }
        height: 5
        system: ps

        onAffectParticles: {
            for (var i=0; i<particles.length; i++) {
                particles[i].vy *= -1;
            }
        }
    }

    // Age afector - pozwala wpływać na cykl życia cząsteczki.
    // Jeżeli cząsteczka wpływa na ten afektor to zostaje on ubita
    // Lewa krawędź
    Age {
        anchors { right: parent.left; bottom: parent.bottom; top: parent.top }
        width: 5
        system: ps
        lifeLeft: 0
        onAffected: {root.rightWins++; isGameStarted = false}
    }
    //Prawa krawędź
    Age {
        anchors { left: parent.right; bottom: parent.bottom; top: parent.top }
        width: 5
        system: ps
        lifeLeft: 0
        onAffected: {root.leftWins++; isGameStarted = false}
    }

    Text {
        anchors { left: parent.left; top: parent.top; margins: 20}
        text: root.leftWins
        font.pointSize: 20
        color: "red"
    }
    Text {
        anchors { right: parent.right; top: parent.top; margins: 20}
        text: root.rightWins
        font.pointSize: 20
        color: "blue"
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            if(isGameStarted === false){
                emitter.burst(1)
                isGameStarted = false
            }
        }
    }
}
