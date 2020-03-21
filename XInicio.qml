import QtQuick 2.0

Item {
    id: r
    anchors.centerIn: parent
    onVisibleChanged: {
        if(visible){
            xApp.focus=visible
        }
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
                let d=new Date(Date.now())
                let dia=d.getDate()
                let mes=d.getMonth()
                let anio=(''+d.getYear()).split('')

                let hora=d.getHours()
                let minuto=d.getMinutes()
                let segundos=d.getSeconds()

                let bdFN='productos_'+dia+'_'+mes+'_'+anio[anio.length-2]+anio[anio.length-1]+'_'+hora+'_'+minuto+'_'+segundos+'.sqlite'

                let folderBds=""+pws+"/mascontrol/bds"
                let currentBd=""+folderBds+"/"+apps.bdFileName

                let bd=""+folderBds+"/"+bdFN

                //apps.bdFileName=bdFN

                let cmd='cmd /c copy "'+currentBd+'" "'+bd+'"'
                uLogView.showLog('CMD COPY: '+cmd)
                unik.run(cmd)
                //unik.setFile(bd, unik.getFile(apps.bdFileName))
                //unik.sqliteClose()
                //unik.sqliteInit(bd)
            }
        }
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
    function actualizar(){
        let sql = 'select * from productos'
        let rows = unik.getSqlData(sql)
        labelCountProds.text='<b>Cantidad de Productos: </b>'+rows.length
    }
}
