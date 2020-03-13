import QtQuick 2.0

Item {
    id: r
    anchors.fill: parent
    property string tableName: ''
    property var cols: []
    onVisibleChanged: {
        if(visible){
            tiCodigo.focus=true
            updateGui()
        }
    }
    Column{
        spacing: app.fs*0.5
        anchors.centerIn: parent
        Row{
            spacing: app.fs
            UTextInput{
                id: tiCodigo
                label: 'Código: '
                width: app.fs*10
                maximumLength: 10
                KeyNavigation.tab: tiDescripcion
            }
            UText{
                id: labelCount
                width: r.width-tiCodigo.width-app.fs*2
                height: contentHeight
                wrapMode: Text.WordWrap
                anchors.verticalCenter: parent.verticalCenter
            }
        }
        UTextInput{
            id: tiDescripcion
            label: 'Descripción: '
            width: r.width-app.fs
            maximumLength: 250
            KeyNavigation.tab: tiPrecioCosto
        }
        Row{
            spacing: app.fs
            anchors.horizontalCenter: parent.horizontalCenter
            UTextInput{
                id: tiPrecioCosto
                label: 'Precio de Costo: '
                width: app.fs*maximumLength
                maximumLength: 19
                regularExp: RegExpValidator{regExp: /^\d+(\.\d{1,2})?$/ }
                KeyNavigation.tab: tiPorcGan
            }
            UTextInput{
                id: tiPorcGan
                label: '% Ganancia: '
                width: app.fs*maximumLength*2
                maximumLength: 5
                regularExp: RegExpValidator{regExp: /^([1-9])([0-9]{10})/ }
                KeyNavigation.tab: tiPrecioVenta
                onTextChanged: {
                    tiPrecioVenta.text=calcPorcVen(parseFloat(tiPrecioCosto.text), parseFloat(tiPorcGan.text))
                }
            }
            UTextInput{
                id: tiPrecioVenta
                label: 'Precio de Venta: '
                width: app.fs*maximumLength
                maximumLength: 19
                regularExp: RegExpValidator{regExp: /^\d+(\.\d{1,2})?$/ }
                KeyNavigation.tab: tiStock
            }
            UTextInput{
                id: tiStock
                label: 'Stock: '
                width: app.fs*maximumLength
                maximumLength: 10
                regularExp: RegExpValidator{regExp: /^\d+(\.\d{1,2})?$/ }
                KeyNavigation.tab: botReg
            }
        }

        Item{width: 1;height: app.fs*2}
        Item{
            width: r.width-app.fs
            height: 1
            UText{
                id: labelStatus
                text: 'Esperando a que se registren productos.'
                width: r.width
                height: contentHeight
                wrapMode: Text.WordWrap
                anchors.verticalCenter: parent.verticalCenter
            }
        }
        Item{width: 1;height: app.fs*2}
        Row{
            spacing: app.fs
            anchors.right: parent.right
            BotonUX{
                text: 'Limpiar'
                height: app.fs*2
                onClicked: {
                    tiCodigo.text=''
                    tiDescripcion.text=''
                    tiPrecioCosto.text=''
                    tiPrecioVenta.text=''
                    tiStock.text=''
                    tiCodigo.focus=true
                    labelStatus.text='Formulario limpiado.'
                }
            }
            BotonUX{
                id: botReg
                text: 'Guardar Producto'
                height: app.fs*2
                onClicked: {
                    insert()
                }
                KeyNavigation.tab: tiCodigo
                Keys.onReturnPressed: insert()
            }
        }
    }
    Timer{
        repeat: true
        running: r.visible
        interval: 15000
        onTriggered: updateGui()
    }
    function calcPorcVen(pcos, porc){
        let diff=pcos/100*porc
        return parseFloat(pcos+diff).toFixed(2)
    }
    function getCount(){
        let sql = 'select '+r.cols[0]+' from '+r.tableName
        let rows = unik.getSqlData(sql)
        return rows.length
    }
    function insert(){
        if(tiCodigo.text===''||tiDescripcion.text===''||tiPrecioCosto.text===''||tiPrecioVenta.text===''||tiStock.text===''||tiPorcGan.text===''){
            uLogView.showLog('Error!\nNo se han introducido todos los datos requeridos.\nPara guardar este producto es necesario completar el formulario en su totalidad.')
            if(tiCodigo.text===''){
                uLogView.showLog('Faltan los datos de código.')
            }
            if(tiDescripcion.text===''){
                uLogView.showLog('Faltan los datos de descripción.')
            }
            if(tiPrecioCosto.text===''){
                uLogView.showLog('Faltan los datos de precio de costo.')
            }
            if(tiPrecioVenta.text===''){
                uLogView.showLog('Faltan los datos de precio de venta.')
            }
            if(tiStock.text===''){
                uLogView.showLog('Faltan los datos de stock.')
            }
            if(tiPorcGan.text===''){
                uLogView.showLog('Faltan los datos de porcentaje de ganancia.')
            }
            return
        }
        if(r.tableName===''){
            uLogView.showLog('Table Name is empty!')
            return
        }
        if(r.cols.length===0){
            uLogView.showLog('Cols is empty!')
            return
        }
        let sql = 'select '+r.cols[0]+' from '+r.tableName+' where '+r.cols[0]+'=\''+tiCodigo.text+'\''
        let rows = unik.getSqlData(sql)
        if(rows.length>=1){
            uLogView.showLog('Error! No se puede insertar un producto con este código.\nYa existe un producto con el código '+tiCodigo.text)
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
        sql = 'insert into '+r.tableName+'('+r.cols+')values('+
                '\''+tiCodigo.text+'\','+
                '\''+tiDescripcion.text+'\','+
                ''+pco+','+
                ''+pve+','+
                ''+tiStock.text+','+
                ''+tiPorcGan.text+''+
                ')'
        let insertado = unik.sqlQuery(sql)
        if(insertado){
            labelStatus.text='Se ha insertado el producto con el código '+tiCodigo.text
        }else{
            labelStatus.text='El producto con el código '+tiCodigo.text+' no ha sido registrado correctamente.'
        }
        //uLogView.showLog('Registro Insertado: '+insertado)
    }
    function updateGui(){
        labelCount.text='Creando el registro número '+parseInt(getCount() + 1)
    }
}
