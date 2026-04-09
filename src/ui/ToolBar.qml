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
    text: boxing_timer.timer_active_property ? "stop" : "start"
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
      top: root.top
      bottom: root.bottom
      left: start_interval.left
      right: root.right
    }
  }
}
