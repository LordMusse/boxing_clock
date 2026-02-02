import QtQuick 2.15

Rectangle {
  id: picture_space
  width: parent.width
  height: parent.height

  color: "#2A83A7"

  anchors {
    bottom: parent.bottom
    left: parent.left
  }

  Text {
    id: timer
    text: "00:00"
  }

}
