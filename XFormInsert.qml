import QtQuick 2.0

Item {
    id: r
    anchors.fill: parent
    property bool modificando: false
    property int pIdAModificar: -1
    property string tableName: ''
    property string uCodInserted: ''
    property var cols: []
    onVisibleChanged: {
        if(visible){
            updateGui()
            tiCodigo.focus=visible
        }else{
            tiCodigo.focus=false
            tiDescripcion.focus=false
            tiPrecioCosto.focus=false
            tiPrecioVenta.focus=false
            tiStock.focus=false
            tiPorcGan.focus=false
        }
    }
    Column{
        spacing: app.fs*0.5
        anchors.centerIn: parent
        UText{
            text:  !r.modificando?'<b>Insertando un Producto</b>':'<b>Modificando un Producto</b>'
            font.pixelSize: app.fs*2
        }
        Row{
            spacing: app.fs
            UTextInput{
                id: tiCodigo
                label: 'Código: '
                width: app.fs*10
                maximumLength: 10
                KeyNavigation.tab: tiDescripcion
                property string uCodExist: ''
                onTextChanged: {
                    tCheckCodExist.restart()
                }
                Timer{
                    id: tCheckCodExist
                    running: false
                    repeat: false
                    interval: 3000
                    onTriggered: {
                        let ce=r.codExist()
                        if(tiCodigo.text!==r.uCodInserted&&ce&&tiCodigo.text!==tiCodigo.uCodExist){
                            let msg='<b>Atención!: </b>El código actual ya existe.'
                            unik.speak(msg.replace(/<[^>]*>?/gm, ''))
                            labelStatus.text=msg
                        }
                        if(!ce){
                            r.modificando=false
                        }
                        tiCodigo.uCodExist=tiCodigo.text
                    }
                }
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
                onTextChanged: {
                    tiPrecioVenta.text=calcPorcVen(parseFloat(tiPrecioCosto.text), parseFloat(tiPorcGan.text))
                }
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
                enabled: false
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
                text: !r.modificando?'Guardar Producto':'Modificar Producto'
                height: app.fs*2
                onClicked: {
                    if(!r.modificando){
                        insert()
                    }else{
                        modify()
                    }
                }
                KeyNavigation.tab: tiCodigo
                Keys.onReturnPressed: {
                    if(!r.modificando){
                        insert()
                    }else{
                        modify()
                    }
                }
            }
        }
    }
    Timer{
        repeat: true
        running: r.visible
        interval: 15000
        onTriggered: updateGui()
    }
    Component{
        id: compExist
        Rectangle{
            id: xCodExists
            width: r.width*0.5
            height: colExists.height+app.fs
            radius: app.fs*0.1
            border.width: 2
            anchors.centerIn: parent
            color: parseInt(vpid)!==-10?app.c1:app.c2
            property string vpid: ''
            property string vpdes: ''
            property string vpcod: ''
            property string vpcos: ''
            property string vpven: ''
            property string vpstock: ''
            property string vpgan: ''
            Column{
                id: colExists
                spacing: app.fs
                width: parent.width-app.fs
                anchors.centerIn: parent
                UText{
                    id: txt
                    color:parseInt(vpid)!==-10?app.c2:app.c1
                    font.pixelSize: app.fs
                    text: parseInt(vpid)!==-10? '<b style="font-size:'+app.fs+'px;">Código: </b><span style="font-size:'+app.fs+'px;">'+vpcod+'</span><br /><br /><b  style="font-size:'+app.fs*1.4+'px;">Descripción: </b><span style="font-size:'+app.fs+'px;">'+vpdes+'</span><br /><br /><b style="font-size:'+app.fs+'px;">Precio de Costo: </b> <span style="font-size:'+app.fs+'px;">$'+vpcos+'</span><br><b style="font-size:'+app.fs+'px;">Precio de Venta: </b> <span style="font-size:'+app.fs+'px;">$'+vpven+'</span><br /><b>Cantidad en Stock: </b>'+vpstock+'<br /><b>Ganancia: </b>'+vpgan:'<b>Resultados por descripción:</b> '+tiSearch.text
                    textFormat: Text.RichText
                    width: parent.width-app.fs
                    wrapMode: Text.WordWrap
                }
                Row{
                    spacing: app.fs
                    BotonUX{
                        id: botCodExistsMod
                        text: 'Modificar'
                        height: app.fs*1.6
                        fontColor: focus?app.c1:app.c2
                        bg.color: focus?app.c2:app.c1
                        glow.radius:focus?2:6
                        Keys.onReturnPressed: loadProd()
                        onClicked: loadProd()
                        function loadProd(){
                            xCodExists.visible=false
                            xCodExists.destroy(3000)
                            tiCodigo.text=vpcod
                            tiDescripcion.text=vpdes
                            tiPrecioCosto.text=vpcos
                            tiPrecioVenta.text=vpven
                            tiStock.text=vpstock
                            tiPorcGan.text=vpgan
                            r.modificando=true
                            r.pIdAModificar=parseInt(vpid)
                        }
                    }
                    BotonUX{
                        text: 'Cerrar'
                        height: app.fs*1.6
                        fontColor: focus?app.c1:app.c2
                        bg.color: focus?app.c2:app.c1
                        glow.radius:focus?2:6
                        onClicked: xCodExists.destroy(10)
                    }
                }
            }
            Component.onCompleted: botCodExistsMod.focus=true
        }
    }
    function codExist(){
        let sql = 'select * from '+r.tableName+' where cod=\''+tiCodigo.text+'\''
        let rows = unik.getSqlData(sql)
        let exists= rows.length>0
        if(exists){
            let comp = compExist
            let obj = comp.createObject(r, {vpid:rows[0].col[0], vpcod:rows[0].col[1],  vpdes:rows[0].col[2], vpcos: rows[0].col[3], vpven: rows[0].col[4], vpstock:rows[0].col[5], vpgan:rows[0].col[6]})
        }
        return exists
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
            r.uCodInserted=tiCodigo.text
        }
        //uLogView.showLog('Registro Insertado: '+insertado)
    }
    function modify(){
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
        let pco=tiPrecioCosto.text
        if(pco.indexOf('.')<0){
            pco+='.00'
        }
        let pve=tiPrecioVenta.text
        if(pve.indexOf('.')<0){
            pve+='.00'
        }
        let sql = 'update '+r.tableName+' set '+
            'cod=\''+tiCodigo.text+'\','+
            'des=\''+tiDescripcion.text+'\','+
            'pco='+pco+','+
            'pve='+pve+','+
            'stock='+tiStock.text+','+
            'gan='+tiPorcGan.text+''+
            ' where id='+r.pIdAModificar
        let insertado = unik.sqlQuery(sql)
        if(insertado){
            let msg='Se ha modificado el producto con el código '+tiCodigo.text
            unik.speak(msg)
            labelStatus.text=msg
        }else{
            let msg='El producto con el código '+tiCodigo.text+' no ha sido modificado correctamente.'
            unik.speak(msg)
            labelStatus.text=msg
            r.uCodInserted=tiCodigo.text
        }
        //uLogView.showLog('Registro Insertado: '+insertado)
    }
    function updateGui(){
        labelCount.text=!r.modificando?'Creando el registro número '+parseInt(getCount() + 1):'Modificando el registro con código '+tiCodigo.text
    }
}
