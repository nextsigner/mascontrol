import QtQuick 2.7
import QtQuick.Controls 2.0
import Qt.labs.settings 1.0

ApplicationWindow {
    id: app
    visible: true
    visibility: 'Maximized'
    color: app.c1
    property var objFocus
    property int fs: app.width*0.015
    property color c1: 'white'
    property color c2: 'black'
    property color c3: 'red'
    property color c4: 'gray'
    property int mod: apps.cMod


    //Variables Globales
    property var colsProds: ['cod', 'des', 'pco', 'pve', 'stock', 'gan']
    property var colsNamesProds: ['Código', 'Descripción', 'Precio de Costo', 'Precio de Venta', 'Stock', 'Porcentaje de Ganancia']
    property var colsClis: ['cod', 'nom', 'dir', 'tel', 'email', 'saldo']


    FontLoader{name: "FontAwesome"; source: "qrc:/fontawesome-webfont.ttf"}
    onModChanged: apps.cMod=mod
    Settings{
        id: apps
        property int cMod
        property string bdFileName
        Component.onCompleted: {
            if(bdFileName===''){
                let d=new Date(Date.now())
                let dia=d.getDate()
                let mes=d.getMonth()
                let anio=(''+d.getYear()).split('')

                let hora=d.getHours()
                let minuto=d.getMinutes()
                let segundos=d.getSeconds()

                let bdFN='productos_'+dia+'_'+mes+'_'+anio[anio.length-2]+anio[anio.length-1]+'_'+hora+'_'+minuto+'_'+segundos+'.sqlite'

                bdFileName=bdFN
            }
        }
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
                XInicio{visible: app.mod===0}
                XFormInsert{
                    id: xFormInsert
                    visible: app.mod===1
                    tableName: 'productos'
                    cols: app.colsProds
                }
                XFormSearch{
                    id: xFormSearch
                    visible: app.mod===2
                    currentTableName: xFormInsert.tableName
                }
                XFormFact{
                    id: xFormFact
                    visible: app.mod===3
                }
                XFormInsertCli{
                    id: xFormInsertCli
                    visible: app.mod===4
                    tableName: 'clientes'
                    cols: app.colsClis
                }

            }
        }
        ULogView{id:uLogView}
        UWarnings{id:uWarnings}
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
            if(app.mod<4){
                app.mod++
            }else{
                app.mod=0
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
    Component.onCompleted: {
        //unik.createLink(unik.getPath(1),  '-folder=', unik.getPath(7)+'/control.lnk', 'Ejecutar +Control', pws+'/mascontrol');
        if(!unik.folderExist('facts')){
            unik.mkdir('facts')
        }
        unik.debugLog=true

        if(!unik.folderExist(pws+'/mascontrol')){
            unik.mkdir(pws+'/mascontrol')
        }
        if(!unik.folderExist(pws+'/mascontrol/bds')){
            unik.mkdir(pws+'/mascontrol/bds')
        }
        //apps.bdFileName=''
        //apps.bdFileName=unik.currentFolderPath()+'/bds/p.sqlite'

        let folderBds=""+pws+"/mascontrol/bds"
        let bd=apps.bdFileName.indexOf('\\')<0?""+folderBds+"/"+apps.bdFileName:""+apps.bdFileName.replace(/\\\\/g, '/')
        if(!unik.fileExist(bd)){
            apps.bdFileName=getNewBdName()
            bd=""+folderBds+"/"+apps.bdFileName
        }
        //bd="C:\\Users\\qt\\Documents\\unik\\mascontrol\\bds\\productos_24_2_20_17_4_1.sqlite"
        //uLogView.showLog('Iniciando Bd: '+bd)
        let iniciado=unik.sqliteInit(bd)
        //uLogView.showLog('Iniciado: '+iniciado)

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
        unik.sqlQuery(sql)
        sql='CREATE TABLE IF NOT EXISTS clientes
                            (
                                id INTEGER PRIMARY KEY AUTOINCREMENT,
                                cod TEXT NOT NULL,
                                nom TEXT NOT NULL,
                                dir TEXT NOT NULL,
                                tel TEXT NOT NULL,
                                email TEXT NOT NULL,
                                saldo DECIMAL(14,2) NOT NULL
                            )'
        unik.sqlQuery(sql)
        sql='CREATE TABLE IF NOT EXISTS facts
                            (
                                id INTEGER PRIMARY KEY AUTOINCREMENT,
                                ms NUMERIC NOT NULL,
                                codcli TEXT NOT NULL,
                                com TEXT NOT NULL
                            )'
        unik.sqlQuery(sql)
        sql='CREATE TABLE IF NOT EXISTS prodfact
                            (
                                id INTEGER PRIMARY KEY AUTOINCREMENT,
                                cod TEXT NOT NULL,
                                des TEXT NOT NULL,
                                desc NUMERIC NOT NULL,
                                cant NUMERIC NOT NULL,
                                pve DECIMAL(14,2) NOT NULL
                            )'
        unik.sqlQuery(sql)
        //console.log('Ejecutado: '+ejecutado)
    }
    function getNewBdName(){
        let d=new Date(Date.now())
        let dia=d.getDate()
        let mes=d.getMonth()
        let anio=(''+d.getYear()).split('')

        let hora=d.getHours()
        let minuto=d.getMinutes()
        let segundos=d.getSeconds()

        let bdFN='productos_'+dia+'_'+mes+'_'+anio[anio.length-2]+anio[anio.length-1]+'_'+hora+'_'+minuto+'_'+segundos+'.sqlite'
        return bdFN
    }
}
