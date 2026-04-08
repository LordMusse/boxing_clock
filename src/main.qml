import QtQuick 2.15
import QtQuick.Controls 2.15
import "ui"

ApplicationWindow {
  visible: true
  visibility: Window.FullScreen
  title: "Boxing Clock"

  Item {
    id: root
    anchors.fill: parent

    ToolBar {
      id: side_bar
      height: root.height/10
      anchors {
        left: root.left
        right: root.right
        bottom: root.bottom
      }
    } 

    BoxingClock {
      id: boxing_clock
      anchors {
        bottom: side_bar.top
        top: root.top
        left: root.left
        right: root.right
      }
    }
  }
}
