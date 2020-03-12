import QtQuick 2.0

Item {
    id: r
    anchors.fill: parent
    property string tableName: ''
    onVisibleChanged: {
        if(visible)tiCodigo.focus=true
    }
    Column{
        spacing: app.fs*0.5
        anchors.centerIn: parent
        UTextInput{
            id: tiCodigo
            label: 'Código: '
            width: app.fs*10
            maximumLength: 10
        }
        UTextInput{
            id: tiDescripcion
            label: 'Descripción: '
            width: r.width-app.fs
            maximumLength: 250
        }
        Row{
            spacing: app.fs
            anchors.horizontalCenter: parent.horizontalCenter
            UTextInput{
                id: tiPrecioCosto
                label: 'Precio de Costo: '
                width: app.fs*maximumLength
                maximumLength: 19
                regularExp: RegExpValidator{regExp: /^(^([1-9][0-9]{15})[\.]{1}[0-9]{2})|^(^([1-9][0-9]{0})[\.]{1}[0-9]{2})/ }
            }
            UTextInput{
                id: tiPrecioVenta
                label: 'Precio de Venta: '
                width: app.fs*maximumLength
                maximumLength: 19
                regularExp: RegExpValidator{regExp: /^\d+(\.\d{1,2})?$/ }
            }
        }
        UTextInput{
            id: tiStock
            label: 'Stock: '
            width: app.fs*maximumLength
            maximumLength: 10
            regularExp: RegExpValidator{regExp: /^\d+(\.\d{1,2})?$/ }
        }
        Item{width: 1;height: app.fs*2}
        BotonUX{
            text: 'Guardar Producto'
            height: app.fs*2
            anchors.right: parent.right
            onClicked: {
                if(r.tableName===''){
                    uLogView.showLog('Table Name is empty!')
                    return
                }
                let pco=tiPrecioCosto.text
                if(pco.indexOf('.')<0){
                    pco+='.00'
                }
                let pve=tiPrecioVenta.text
                if(pve.indexOf('.')<0){
                    pve+='.00'
                }
                let sql = 'insert into tabla2(cod, des, pco, pve, stock)values('+
                    '\''+tiCodigo.text+'\','+
                    '\''+tiDescripcion.text+'\','+
                    ''+pco+','+
                    ''+pve+','+
                    ''+tiStock.text+''+
                    ')'
                unik.sqlQuery(sql)
            }
        }
    }
}
