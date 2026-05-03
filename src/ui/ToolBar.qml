import QtQuick 2.15
import QtQuick.Controls 2.15

Rectangle {
  id: toolbar

  Button {
    id: shutdown
    width: toolbar.width * 0.15
    anchors {
      top: toolbar.top
      bottom: toolbar.bottom
      left: toolbar.left
    }
    text: "shutdown"
    font.pixelSize: 32
    font.bold: true
    palette.buttonText: "black"
    z: 1000
    onClicked: Qt.quit()
  }

  Button {
    id: start_interval
    width: toolbar.width * 0.35
    anchors {
      top: toolbar.top
      bottom: toolbar.bottom
      left: shutdown.right
    }
    text: boxing_timer.timer_active_property ? "stop" : "start"
    font.pixelSize: 32
    font.bold: true
    palette.buttonText: "black"
    z: 1000
    onClicked: {
      if (boxing_timer.timer_active_property){
        boxing_timer.stop_timer();
      } else {
        boxing_timer.start_interval();
      }
    }
  }

  Stats {
    id: stats
    anchors {
      top: parent.top
      bottom: toolbar.bottom
      left: start_interval.right
      right: toolbar.right
    }
  }
}
