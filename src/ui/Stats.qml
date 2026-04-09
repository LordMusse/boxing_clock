import QtQuick 2.15
import QtQuick.Controls 2.15

Rectangle {
  id: stats
  color: "gray"
  Grid {
    columns: 1
    spacing: 4
    anchors.centerIn: stats
    Text {
      text: boxing_timer.current_repetition_property
      font.pixelSize: 24
    }
    Rectangle {
      color: "black"
      width: 24
      height: 4
    }
    Text {
      text: boxing_timer.total_repetitions_property
      font.pixelSize: 24
    }
  }
}
