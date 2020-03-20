import QtQuick 2.7
import QtQuick.Controls 2.0
import Qt.labs.settings 1.0

ApplicationWindow {
    id: app
    visible: true
    visibility: 'Maximized'
    color: app.c1
    property int fs: app.width*0.015
    property color c1: 'white'
    property color c2: 'black'
    property color c3: 'red'
    property color c4: 'gray'
    property int mod: apps.cMod
    FontLoader{name: "FontAwesome"; source: "qrc:/fontawesome-webfont.ttf"}
    onModChanged: apps.cMod=mod
    Settings{
        id: apps
        property int cMod
    }

    USettings{
        id: unikSettings
        url: './cfg'
        onCurrentNumColorChanged: {
            let mc=unikSettings.defaultColors.split('|')
            let cc=mc[unikSettings.currentNumColor].split('-')
            app.c1=cc[0]
            app.c2=cc[1]
            app.c3=cc[2]
            app.c4=cc[3]
        }
        Component.onCompleted: {
            let mc=unikSettings.defaultColors.split('|')
            let cc=mc[unikSettings.currentNumColor].split('-')
            app.c1=cc[0]
            app.c2=cc[1]
            app.c3=cc[2]
            app.c4=cc[3]
        }
    }

    Item{
        id: xApp
        anchors.fill: parent
        Column{
            anchors.fill: parent
            spacing: app.fs
            Item{width: 1;height: app.fs*0.25}
            XMenu{id: xMenu}
            Item{
                id: xForms
                width: parent.width
                height: xApp.height-xMenu.height-app.fs*2.25
                XInicio{visible: app.mod===-1}
                XFormInsert{
                    id: xFormInsert
                    visible: app.mod===0
                    tableName: 'productos'
                    cols: ['cod', 'des', 'pco', 'pve', 'stock', 'gan']
                }
                XFormSearch{
                    id: xFormSearch
                    visible: app.mod===1
                    currentTableName: xFormInsert.tableName
                }
                XFormFact{
                    id: xFormFact
                    visible: app.mod===2
                }
            }
        }
        ULogView{id:uLogView}
        UWarnings{id:uWarnings}
    }
    Component.onCompleted: {
        //unik.createLink(unik.getPath(1),  '-folder=', unik.getPath(7)+'/control.lnk', 'Ejecutar +Control', pws+'/mascontrol');
        if(!unik.folderExist('facts')){
            unik.mkdir('facts')
        }
        unik.debugLog=true
        unik.sqliteInit('productos.sqlite')
        let sql='CREATE TABLE IF NOT EXISTS productos
                            (
                                id INTEGER PRIMARY KEY AUTOINCREMENT,
                                cod TEXT NOT NULL,
                                des TEXT NOT NULL,
                                pco DECIMAL(14,2) NOT NULL,
                                pve DECIMAL(14,2) NOT NULL,
                                stock INTEGER NOT NULL,
                                gan INTEGER NOT NULL
                            )'
        let ejecutado = unik.sqlQuery(sql)
        console.log('Ejecutado: '+ejecutado)
    }
    Shortcut{
        sequence: 'Esc'
        onActivated: {
            if(uLogView.visible){
                uLogView.visible=false
                return
            }
            if(uWarnings.visible){
                uWarnings.visible=false
                return
            }
            if(app.mod!==-1){
                app.mod=-1
                return
            }
            Qt.quit()
        }
    }
    Shortcut{
        sequence: 'Ctrl+q'
        onActivated: Qt.quit()
    }
    Shortcut{
        sequence: 'Ctrl+Tab'
        onActivated: {
            if(app.mod<2){
                app.mod++
            }else{
                app.mod=-1
            }
        }
    }
    Shortcut{
        sequence: 'Ctrl+c'
        onActivated: {
            if(unikSettings.currentNumColor<16){
                unikSettings.currentNumColor++
            }else{
                unikSettings.currentNumColor=0
            }
        }
    }
}
