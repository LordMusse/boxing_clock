import QtQuick 2.15

Rectangle {
  id: root

  color: "red"

  Text {
    id: timer
    anchors.centerIn: root
    text: boxing_timer.time_remaining_property
    color: "white"
    font.pixelSize: root.height*9/10
    renderType: Text.CurveRendering
    antialiasing: true
  }
}
