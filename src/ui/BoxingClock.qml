import QtQuick 2.15

Rectangle {
  id: root

  color: boxing_timer.time_to_rest_property ? "green" : "red"

  Text {
    id: title
    anchors.horizontalCenter: root.horizontalCenter
    anchors.top: root.top
    anchors.topMargin: 24
    text: boxing_timer.time_to_rest_property ? "Dags att vila gubbar!" : "Dags att slåss!"
    color: boxing_timer.time_to_rest_property ? "black" : "white"
    font.pixelSize: 24
    renderType: Text.CurveRendering
    antialiasing: true
  }

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
