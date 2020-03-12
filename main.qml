import QtQuick 2.7
import QtQuick.Controls 2.0

ApplicationWindow {
    id: app
    visible: true
    visibility: 'Maximized'
    property int fs: app.width*0.02
    property color c1: 'white'
    property color c2: 'black'
    property color c3: 'red'
    property color c4: 'gray'
    property int mod: -1

    USettings{
        id: unikSettings
        url: './cfg'
    }

    Item{
        id: xApp
        anchors.fill: parent
        Column{
            anchors.fill: parent
            spacing: app.fs
            Row{
                id: rowMenu
                spacing: app.fs*0.5
                anchors.left: parent.left
                anchors.leftMargin: app.fs*0.5
                BotonUX{
                    text: 'Inicio'
                    height: app.fs*2
                    onClicked: {
                        app.mod=-1
                    }
                }
                BotonUX{
                    text: 'Insertar Registro'
                    height: app.fs*2
                    fontColor: app.mod===0?app.c1:app.c2
                    bg.color: app.mod===0?app.c2:app.c1
                    glow.radius:app.mod===0?2:6
                    onClicked: {
                        app.mod=0
                    }
                }
                BotonUX{
                    text: 'Buscar Registro'
                    height: app.fs*2
                    fontColor: app.mod===1?app.c1:app.c2
                    bg.color: app.mod===1?app.c2:app.c1
                    glow.radius:app.mod===1?2:6
                    onClicked: {
                        app.mod=1
                    }
                }
            }
            Column{
                width: parent.width
                height: xApp.height-rowMenu.height
                XFormInsert{
                    visible: app.mod===0
                }
                XFormSearch{
                    visible: app.mod===1
                }
            }
        }
        ULogView{id:uLogView}
        UWarnings{id:uWarnings}
    }
    Component.onCompleted: {
        unik.debugLog=true
        unik.sqliteInit('productos2.sqlite')
        let sql='CREATE TABLE IF NOT EXISTS productos
                            (
                                id INTEGER PRIMARY KEY AUTOINCREMENT,
                                cod TEXT NOT NULL,
                                des TEXT NOT NULL,
                                pco DECIMAL(14,2) NOT NULL,
                                pve DECIMAL(14,2) NOT NULL,
                                stock INTEGER NOT NULL
                            )'
        let ejecutado = unik.sqlQuery(sql)
        console.log('Ejecutado: '+ejecutado)
    }
    Shortcut{
        sequence: 'Esc'
        onActivated: Qt.quit()
    }
}
