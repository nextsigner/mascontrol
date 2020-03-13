import QtQuick 2.7
import QtQuick.Controls 2.12
import QtQuick.Controls.Styles 1.4

RadioButton {
    id: r
    property int d: app.fs
    indicator: Rectangle {
        implicitWidth: r.d
        implicitHeight: r.d
        radius: r.d*0.5
        border.color: r.activeFocus ? app.c3 : app.c4
        border.width: unikSettings.borderWidth
        anchors.verticalCenter: parent.verticalCenter
        //anchors.right: parent.right
        //anchors.rightMargin: 0-app.fs*1.5
        Rectangle {
            anchors.fill: parent
            visible: r.checked
            color: app.c2
            radius: r.d*0.5
            anchors.margins: app.fs*0.25
        }
    }
}
