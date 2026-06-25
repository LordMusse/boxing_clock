import QtQuick 2.15

FocusScope {
    id: toolbar
    focus: true

    property int workMinutes: 0
    property int workSeconds: 0
    property int restMinutes: 0
    property int restSeconds: 0
    property int rounds: 0

    Component.onCompleted: {
        var workParts = boxing_timer.work_interval_property.split(":")
        workMinutes = parseInt(workParts[0])
        workSeconds = parseInt(workParts[1])
        var restParts = boxing_timer.rest_interval_property.split(":")
        restMinutes = parseInt(restParts[0])
        restSeconds = parseInt(restParts[1])
        rounds = boxing_timer.total_repetitions_property
    }

    function applyWorkInterval() {
        var secStr = workSeconds < 10 ? "0" + workSeconds : "" + workSeconds
        boxing_timer.work_interval_property = workMinutes + ":" + secStr
    }

    function applyRestInterval() {
        var secStr = restSeconds < 10 ? "0" + restSeconds : "" + restSeconds
        boxing_timer.rest_interval_property = restMinutes + ":" + secStr
    }

    Rectangle {
        anchors.fill: parent
        color: "#333333"
    }

    Row {
        anchors.fill: parent
        spacing: 2

        Rectangle {
            id: shutdownCell
            width: toolbar.width * 0.08
            height: toolbar.height
            color: activeFocus ? "#3355cc" : "#555555"
            border.color: activeFocus ? "#ffcc00" : "#444444"
            border.width: 3
            radius: 4
            KeyNavigation.right: musicCell
            KeyNavigation.left: restSecCell

            Text {
                anchors.centerIn: parent
                text: "Shutdown"
                font.pixelSize: 24
                font.bold: true
                color: parent.activeFocus ? "white" : "#cccccc"
            }

            Keys.onReturnPressed: Qt.quit()
            Keys.onEnterPressed: Qt.quit()

            MouseArea {
                anchors.fill: parent
                onClicked: { parent.forceActiveFocus(); Qt.quit() }
            }
        }

        Rectangle {
            id: musicCell
            width: toolbar.width * 0.08
            height: toolbar.height
            color: activeFocus ? "#3355cc" : "#555555"
            border.color: activeFocus ? "#ffcc00" : "#444444"
            border.width: 3
            radius: 4
            KeyNavigation.left: shutdownCell
            KeyNavigation.right: startCell

            Text {
                anchors.centerIn: parent
                text: "Musik"
                font.pixelSize: 24
                font.bold: true
                color: parent.activeFocus ? "white" : "#cccccc"
            }

            Keys.onReturnPressed: boxing_timer.switch_window()
            Keys.onEnterPressed: boxing_timer.switch_window()

            MouseArea {
                anchors.fill: parent
                onClicked: { parent.forceActiveFocus(); boxing_timer.switch_window() }
            }
        }

        Rectangle {
            id: startCell
            width: toolbar.width * 0.11
            height: toolbar.height
            color: activeFocus ? "#3355cc" : "#555555"
            border.color: activeFocus ? "#ffcc00" : "#444444"
            border.width: 3
            radius: 4
            focus: true
            KeyNavigation.left: musicCell
            KeyNavigation.right: roundsCell

            Text {
                anchors.centerIn: parent
                text: boxing_timer.timer_active_property ? "Stop" : "Start"
                font.pixelSize: 28
                font.bold: true
                color: parent.activeFocus ? "white" : "#cccccc"
            }

            Keys.onReturnPressed: {
                if (boxing_timer.timer_active_property)
                    boxing_timer.stop_timer()
                else
                    boxing_timer.start_interval()
            }
            Keys.onEnterPressed: {
                if (boxing_timer.timer_active_property)
                    boxing_timer.stop_timer()
                else
                    boxing_timer.start_interval()
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    parent.forceActiveFocus()
                    if (boxing_timer.timer_active_property)
                        boxing_timer.stop_timer()
                    else
                        boxing_timer.start_interval()
                }
            }
        }

        Rectangle {
            id: statusDisplay
            width: toolbar.width * 0.06
            height: toolbar.height
            color: "#444444"

            Column {
                anchors.centerIn: parent
                spacing: 2
                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: boxing_timer.current_repetition_property
                    font.pixelSize: 22
                    color: "white"
                }
                Rectangle {
                    width: 30; height: 2; color: "white"
                    anchors.horizontalCenter: parent.horizontalCenter
                }
                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: boxing_timer.total_repetitions_property
                    font.pixelSize: 22
                    color: "white"
                }
            }
        }

        Rectangle {
            id: roundsCell
            width: toolbar.width * 0.10
            height: toolbar.height
            color: activeFocus ? "#3355cc" : "#555555"
            border.color: activeFocus ? "#ffcc00" : "#444444"
            border.width: 3
            radius: 4
            KeyNavigation.left: startCell
            KeyNavigation.right: workMinCell

            Column {
                anchors.centerIn: parent
                spacing: 2
                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "Rundor"
                    font.pixelSize: 16
                    color: roundsCell.activeFocus ? "#dddddd" : "#999999"
                }
                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: toolbar.rounds
                    font.pixelSize: 32
                    font.bold: true
                    color: "white"
                }
            }

            Keys.onPressed: function(event) {
                if (event.key >= Qt.Key_0 && event.key <= Qt.Key_9) {
                    var digit = event.key - Qt.Key_0
                    var newVal = toolbar.rounds * 10 + digit
                    if (newVal > 999) newVal = digit
                    if (newVal >= 1) {
                        toolbar.rounds = newVal
                        boxing_timer.total_repetitions_property = toolbar.rounds
                    }
                    event.accepted = true
                } else if (event.key === Qt.Key_Backspace) {
                    toolbar.rounds = Math.floor(toolbar.rounds / 10)
                    if (toolbar.rounds < 1) toolbar.rounds = 1
                    boxing_timer.total_repetitions_property = toolbar.rounds
                    event.accepted = true
                } else if (event.key === Qt.Key_Up) {
                    toolbar.rounds = Math.min(toolbar.rounds + 1, 999)
                    boxing_timer.total_repetitions_property = toolbar.rounds
                    event.accepted = true
                } else if (event.key === Qt.Key_Down) {
                    toolbar.rounds = Math.max(toolbar.rounds - 1, 1)
                    boxing_timer.total_repetitions_property = toolbar.rounds
                    event.accepted = true
                }
            }

            MouseArea {
                anchors.fill: parent
                onClicked: parent.forceActiveFocus()
            }
        }

        Rectangle {
            id: workMinCell
            width: toolbar.width * 0.13
            height: toolbar.height
            color: activeFocus ? "#3355cc" : "#555555"
            border.color: activeFocus ? "#ffcc00" : "#444444"
            border.width: 3
            radius: 4
            KeyNavigation.left: roundsCell
            KeyNavigation.right: workSecCell

            Column {
                anchors.centerIn: parent
                spacing: 2
                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "Slåss min"
                    font.pixelSize: 16
                    color: workMinCell.activeFocus ? "#dddddd" : "#999999"
                }
                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: toolbar.workMinutes
                    font.pixelSize: 32
                    font.bold: true
                    color: "white"
                }
            }

            Keys.onPressed: function(event) {
                if (event.key >= Qt.Key_0 && event.key <= Qt.Key_9) {
                    var digit = event.key - Qt.Key_0
                    var newVal = toolbar.workMinutes * 10 + digit
                    if (newVal > 99) newVal = digit
                    toolbar.workMinutes = newVal
                    toolbar.applyWorkInterval()
                    event.accepted = true
                } else if (event.key === Qt.Key_Backspace) {
                    toolbar.workMinutes = Math.floor(toolbar.workMinutes / 10)
                    toolbar.applyWorkInterval()
                    event.accepted = true
                } else if (event.key === Qt.Key_Up) {
                    toolbar.workMinutes = Math.min(toolbar.workMinutes + 1, 99)
                    toolbar.applyWorkInterval()
                    event.accepted = true
                } else if (event.key === Qt.Key_Down) {
                    toolbar.workMinutes = Math.max(toolbar.workMinutes - 1, 0)
                    toolbar.applyWorkInterval()
                    event.accepted = true
                }
            }

            MouseArea {
                anchors.fill: parent
                onClicked: parent.forceActiveFocus()
            }
        }

        Rectangle {
            id: workSecCell
            width: toolbar.width * 0.13
            height: toolbar.height
            color: activeFocus ? "#3355cc" : "#555555"
            border.color: activeFocus ? "#ffcc00" : "#444444"
            border.width: 3
            radius: 4
            KeyNavigation.left: workMinCell
            KeyNavigation.right: restMinCell

            Column {
                anchors.centerIn: parent
                spacing: 2
                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "Slåss sek"
                    font.pixelSize: 16
                    color: workSecCell.activeFocus ? "#dddddd" : "#999999"
                }
                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: toolbar.workSeconds < 10 ? "0" + toolbar.workSeconds : "" + toolbar.workSeconds
                    font.pixelSize: 32
                    font.bold: true
                    color: "white"
                }
            }

            Keys.onPressed: function(event) {
                if (event.key >= Qt.Key_0 && event.key <= Qt.Key_9) {
                    var digit = event.key - Qt.Key_0
                    var newVal = toolbar.workSeconds * 10 + digit
                    if (newVal > 59) newVal = digit
                    toolbar.workSeconds = newVal
                    toolbar.applyWorkInterval()
                    event.accepted = true
                } else if (event.key === Qt.Key_Backspace) {
                    toolbar.workSeconds = Math.floor(toolbar.workSeconds / 10)
                    toolbar.applyWorkInterval()
                    event.accepted = true
                } else if (event.key === Qt.Key_Up) {
                    toolbar.workSeconds = Math.min(toolbar.workSeconds + 1, 59)
                    toolbar.applyWorkInterval()
                    event.accepted = true
                } else if (event.key === Qt.Key_Down) {
                    toolbar.workSeconds = Math.max(toolbar.workSeconds - 1, 0)
                    toolbar.applyWorkInterval()
                    event.accepted = true
                }
            }

            MouseArea {
                anchors.fill: parent
                onClicked: parent.forceActiveFocus()
            }
        }

        Rectangle {
            id: restMinCell
            width: toolbar.width * 0.13
            height: toolbar.height
            color: activeFocus ? "#3355cc" : "#555555"
            border.color: activeFocus ? "#ffcc00" : "#444444"
            border.width: 3
            radius: 4
            KeyNavigation.left: workSecCell
            KeyNavigation.right: restSecCell

            Column {
                anchors.centerIn: parent
                spacing: 2
                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "Vila min"
                    font.pixelSize: 16
                    color: restMinCell.activeFocus ? "#dddddd" : "#999999"
                }
                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: toolbar.restMinutes
                    font.pixelSize: 32
                    font.bold: true
                    color: "white"
                }
            }

            Keys.onPressed: function(event) {
                if (event.key >= Qt.Key_0 && event.key <= Qt.Key_9) {
                    var digit = event.key - Qt.Key_0
                    var newVal = toolbar.restMinutes * 10 + digit
                    if (newVal > 99) newVal = digit
                    toolbar.restMinutes = newVal
                    toolbar.applyRestInterval()
                    event.accepted = true
                } else if (event.key === Qt.Key_Backspace) {
                    toolbar.restMinutes = Math.floor(toolbar.restMinutes / 10)
                    toolbar.applyRestInterval()
                    event.accepted = true
                } else if (event.key === Qt.Key_Up) {
                    toolbar.restMinutes = Math.min(toolbar.restMinutes + 1, 99)
                    toolbar.applyRestInterval()
                    event.accepted = true
                } else if (event.key === Qt.Key_Down) {
                    toolbar.restMinutes = Math.max(toolbar.restMinutes - 1, 0)
                    toolbar.applyRestInterval()
                    event.accepted = true
                }
            }

            MouseArea {
                anchors.fill: parent
                onClicked: parent.forceActiveFocus()
            }
        }

        Rectangle {
            id: restSecCell
            width: toolbar.width * 0.13
            height: toolbar.height
            color: activeFocus ? "#3355cc" : "#555555"
            border.color: activeFocus ? "#ffcc00" : "#444444"
            border.width: 3
            radius: 4
            KeyNavigation.left: restMinCell
            KeyNavigation.right: shutdownCell

            Column {
                anchors.centerIn: parent
                spacing: 2
                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "Vila sek"
                    font.pixelSize: 16
                    color: restSecCell.activeFocus ? "#dddddd" : "#999999"
                }
                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: toolbar.restSeconds < 10 ? "0" + toolbar.restSeconds : "" + toolbar.restSeconds
                    font.pixelSize: 32
                    font.bold: true
                    color: "white"
                }
            }

            Keys.onPressed: function(event) {
                if (event.key >= Qt.Key_0 && event.key <= Qt.Key_9) {
                    var digit = event.key - Qt.Key_0
                    var newVal = toolbar.restSeconds * 10 + digit
                    if (newVal > 59) newVal = digit
                    toolbar.restSeconds = newVal
                    toolbar.applyRestInterval()
                    event.accepted = true
                } else if (event.key === Qt.Key_Backspace) {
                    toolbar.restSeconds = Math.floor(toolbar.restSeconds / 10)
                    toolbar.applyRestInterval()
                    event.accepted = true
                } else if (event.key === Qt.Key_Up) {
                    toolbar.restSeconds = Math.min(toolbar.restSeconds + 1, 59)
                    toolbar.applyRestInterval()
                    event.accepted = true
                } else if (event.key === Qt.Key_Down) {
                    toolbar.restSeconds = Math.max(toolbar.restSeconds - 1, 0)
                    toolbar.applyRestInterval()
                    event.accepted = true
                }
            }

            MouseArea {
                anchors.fill: parent
                onClicked: parent.forceActiveFocus()
            }
        }
    }
}
