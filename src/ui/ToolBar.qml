import QtQuick 2.15
import QtQuick.Controls 2.15

Rectangle {
  id: root

  Button {
    id: start_interval
    width: root.width/2
    anchors {
      top: root.top
      bottom: root.bottom
      left: root.left
    }
    text: "start"
    z: 1000
    onClicked: {
      boxing_timer.start_interval();
    }
  }

  Button {
    id: stop_timer
    anchors {
      top: root.top
      bottom: root.bottom
      right: root.right
      left: start_interval.right
    }
    text: "stop"
    onClicked: {
      boxing_timer.stop_timer();
    }
  }
}
