import QtQuick 2.0

Row{
    id: r
    spacing: app.fs*0.5
    anchors.left: parent.left
    anchors.leftMargin: app.fs*0.5
    BotonUX{
        text: 'Inicio'
        height: app.fs*2
        fontColor: app.mod===-1?app.c1:app.c2
        bg.color: app.mod===-1?app.c2:app.c1
        glow.radius:app.mod===-1?2:6
        onClicked: {
            app.mod=-1
        }
    }
    BotonUX{
        text: 'Insertar Producto'
        height: app.fs*2
        fontColor: app.mod===0?app.c1:app.c2
        bg.color: app.mod===0?app.c2:app.c1
        glow.radius:app.mod===0?2:6
        onClicked: {
            app.mod=0
        }
    }
    BotonUX{
        text: 'Buscar Producto'
        height: app.fs*2
        fontColor: app.mod===1?app.c1:app.c2
        bg.color: app.mod===1?app.c2:app.c1
        glow.radius:app.mod===1?2:6
        onClicked: {
            app.mod=1
        }
    }
    BotonUX{
        text: 'Crear Factura'
        height: app.fs*2
        fontColor: app.mod===2?app.c1:app.c2
        bg.color: app.mod===2?app.c2:app.c1
        glow.radius:app.mod===2?2:6
        onClicked: {
            app.mod=2
        }
    }
}
