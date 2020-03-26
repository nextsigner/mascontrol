import QtQuick 2.0
import Qt.labs.settings 1.0

Item{
    id: r
    width: parent.width
    height: minimalista?app.fs*0.5:app.fs*1.4
    property bool minimalista: menuSettings.minimalista
    Settings{
        id: menuSettings
        property bool minimalista: false
    }
    MouseArea{
        anchors.fill: r
        onDoubleClicked: menuSettings.minimalista=!menuSettings.minimalista
    }
    Row{
        visible: r.minimalista
        anchors.centerIn: parent
        spacing: app.fs
        Repeater{
            model: 5
            Rectangle{
                width: app.fs*0.5
                height: width
                radius: width*0.5
                opacity: app.mod===index?1.0:0.5
                MouseArea{
                    width: parent.width*2
                    height: width
                    anchors.centerIn: parent
                    onClicked: app.mod=index
                }
            }
        }
    }
    Row{
        visible: !r.minimalista
        spacing: app.fs*0.5
        anchors.left: parent.left
        anchors.leftMargin: app.fs*0.5
        BotonUX{
            text: 'Inicio'
            height: app.fs*2
            fontColor: app.mod===0?app.c1:app.c2
            bg.color: app.mod===0?app.c2:app.c1
            glow.radius:app.mod===0?2:6
            onClicked: {
                app.mod=-1
            }
        }
        BotonUX{
            text: 'Insertar Producto'
            height: app.fs*2
            fontColor: app.mod===1?app.c1:app.c2
            bg.color: app.mod===1?app.c2:app.c1
            glow.radius:app.mod===1?2:6
            onClicked: {
                app.mod=0
            }
        }
        BotonUX{
            text: 'Buscar Producto'
            height: app.fs*2
            fontColor: app.mod===2?app.c1:app.c2
            bg.color: app.mod===2?app.c2:app.c1
            glow.radius:app.mod===2?2:6
            onClicked: {
                app.mod=1
            }
        }
        BotonUX{
            text: 'Crear Factura'
            height: app.fs*2
            fontColor: app.mod===3?app.c1:app.c2
            bg.color: app.mod===3?app.c2:app.c1
            glow.radius:app.mod===3?2:6
            onClicked: {
                app.mod=2
            }
        }
        BotonUX{
            text: 'Insertar Clientes'
            height: app.fs*2
            fontColor: app.mod===4?app.c1:app.c2
            bg.color: app.mod===4?app.c2:app.c1
            glow.radius:app.mod===4?2:6
            onClicked: {
                app.mod=3
            }
        }
    }
}
