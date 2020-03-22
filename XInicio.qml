import QtQuick 2.0
import Qt.labs.platform 1.1
import Qt.labs.settings 1.0

Item {
    id: r
    anchors.centerIn: parent
    onVisibleChanged: {
        if(visible){
            xApp.focus=visible
        }
    }
    Settings{
        id: inicioSettings
        property string uFolder
    }

    Column{
        anchors.centerIn: parent
        spacing: app.fs
        UText{
            text: '<b>+Control</b>'
            font.pixelSize: app.fs*2
            anchors.horizontalCenter: parent.horizontalCenter
        }
        UText{
            text: 'Aplicación para la gestión, control\ny facturación de productos'
            font.pixelSize: app.fs
            horizontalAlignment: Text.AlignHCenter
            anchors.horizontalCenter: parent.horizontalCenter
        }
        Item{width: 1;height: app.fs*3}
        Row{
            spacing: app.fs
            UText{
                text: '<b>Base de Datos: </b>'+apps.bdFileName
                font.pixelSize: app.fs
                anchors.verticalCenter: parent.verticalCenter
            }
            BotonUX{
                text: 'Hacer Copia de Seguridad'
                onClicked: {
                    folderDialog.visible=true
                }
            }
        }
        UText{
            id: backUpStatus
            font.pixelSize: app.fs
        }
        Item{width: 1;height: app.fs*3}
        UText{
            id: labelCountProds
            text: '<b>Cantidad de Productos: </b> Contando...'
            font.pixelSize: app.fs
        }
        UText{
            text: '<b>Color actual: </b>'+unikSettings.currentNumColor
            font.pixelSize: app.fs
        }
    }
    Timer{
        running: r.visible
        repeat: true
        interval: 1500
        onTriggered: actualizar()
    }
    FolderDialog {
        id: folderDialog
        currentFolder: inicioSettings.uFolder!==''?inicioSettings.uFolder:unik.getPath(3)
        folder: StandardPaths.standardLocations(StandardPaths.Documents)[0]
        onAccepted: {
            inicioSettings.uFolder=folder
            let d=new Date(Date.now())
            let dia=d.getDate()
            let mes=d.getMonth()
            let anio=(''+d.getYear()).split('')

            let hora=d.getHours()
            let minuto=d.getMinutes()
            let segundos=d.getSeconds()

            let bdFN='productos_'+dia+'_'+mes+'_'+anio[anio.length-2]+anio[anio.length-1]+'_'+hora+'_'+minuto+'_'+segundos+'.sqlite'

            let fs=(''+folder).replace('file:///', '')
            let folderCurrentBds=""+pws+"/mascontrol/bds"
            let folderBds=""+fs+""
            let currentBd=(""+folderCurrentBds+"/"+apps.bdFileName).replace(/\//g, "\\\\")

            let bd=(""+folderBds+"/"+bdFN).replace(/\//g, "\\\\")
            let cmd='cmd /c copy "'+currentBd+'" "'+bd+'"'
            //unik.run(cmd)
            unik.ejecutarLineaDeComandoAparte(cmd)
            backUpStatus.text='Archivo '+bdFN+' copiado en la carpeta '+folderBds
            //backUpStatus.text='Copiando archivo '+bdFN+' en la carpeta '+folderBds
            //tCheckBK.file='"'+bd+'"'
            //tCheckBK.v=0
            //tCheckBK.repeat=true
            //tCheckBK.start()
        }
    }
    Timer{
        id: tCheckBK
        repeat: true
        running: false
        interval: 3000
        property string file
        property int v: 0
        onTriggered: {
            let fn=file//.replace(/\\\\\\\\/g, '/')
            uLogView.showLog('fn: '+fn)
            if(unik.fileExist(fn)){
                backUpStatus.text='Base de datos copiada correctamente.'
                tCheckBK.repeat=false
                tCheckBK.running=false
                tCheckBK.stop()
            }else{
                backUpStatus.text+='.'
            }
            if(v>30){
                backUpStatus.text='La copia está demorando demasiado.\nEsto significa que algo está funcionando mal.'
            }
            v++
        }
    }
    function actualizar(){
        let sql = 'select * from productos'
        let rows = unik.getSqlData(sql)
        labelCountProds.text='<b>Cantidad de Productos: </b>'+rows.length
    }
}
