import QtQuick 2.15
import QtQuick.Controls 2.15

Rectangle {
    id: stats
    color: "gray"
    // left to...
    Grid {
        id: interval_status
        columns: 1
        spacing: 4
        anchors.verticalCenter: stats.verticalCenter
        anchors.left: stats.left
        anchors.leftMargin: spacing
        Text {
            text: boxing_timer.current_repetition_property
            font.pixelSize: 24
        }
        Rectangle {
            color: "black"
            width: 16
            height: 4
        }
        Text {
            text: boxing_timer.total_repetitions_property
            font.pixelSize: 24
        }
    }

    Grid {
        id: interval_setting
        columns: 1
        spacing: 4
        anchors.verticalCenter: stats.verticalCenter
        anchors.left: interval_status.right
        anchors.leftMargin: spacing
        Text {
            text: "Mängd intervaller"
            font.pixelSize: 24
        }
        Rectangle {
            color: "black"
            width: 16 * 17
            height: 4
        }
        TextInput {
            text: boxing_timer.total_repetitions_property
            activeFocusOnTab: true
            font.pixelSize: 24
            onEditingFinished: {
                boxing_timer.total_repetitions_property = text;
            }
        }
    }

    Grid {
        id: work_setting
        columns: 1
        spacing: 4
        anchors.verticalCenter: stats.verticalCenter
        anchors.left: interval_setting.right
        anchors.leftMargin: spacing
        Text {
            text: "Tid att slåss"
            font.pixelSize: 24
        }
        Rectangle {
            color: "black"
            width: 16 * 13
            height: 4
        }
        TextInput {
            text: boxing_timer.total_repetitions_property
            activeFocusOnTab: true
            font.pixelSize: 24
            onEditingFinished: {
                boxing_timer.work_interval_property = text;
            }
        }
    }

    Grid {
        id: rest_setting
        columns: 1
        spacing: 4
        anchors.verticalCenter: stats.verticalCenter
        anchors.left: work_setting.right
        anchors.leftMargin: spacing
        Text {
            text: "Tid att vila"
            font.pixelSize: 24
        }
        Rectangle {
            color: "black"
            width: 16 * 12
            height: 4
        }
        TextInput {
            text: boxing_timer.total_repetitions_property
            activeFocusOnTab: true
            font.pixelSize: 24
            onEditingFinished: {
                boxing_timer.rest_interval_property = text;
            }
        }
    }
}
