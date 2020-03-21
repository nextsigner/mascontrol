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
        UText{
            text: '<b>Base de Datos: </b>'+apps.bdFileName
            font.pixelSize: app.fs
        }
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
