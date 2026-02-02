import QtQuick 2.15
import QtQuick.Controls 2.15
import "ui"

ApplicationWindow {
    visible: true
    visibility: Window.FullScreen
    title: "Boxing Clock"

    BoxingClock {
      id: boxing_clock
    }

}
