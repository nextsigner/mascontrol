import QtQuick 2.0

Item {
    id: r
    anchors.fill: parent
    property bool buscando: false
    property string currentTableName: ''
    onVisibleChanged: {
        tiSearch.focus=visible
    }
    Column{
        width: parent.width-app.fs
        height: parent.height
        spacing: app.fs*0.5
        anchors.horizontalCenter: parent.horizontalCenter
        UText{text: 'Buscando en la planilla '+r.currentTableName; font.pixelSize: app.fs}
        Row{
            spacing: app.fs*0.5
            anchors.horizontalCenter: parent.horizontalCenter
            UTextInput{
                id: tiSearch
                label: 'Buscar:'
                width: app.fs*18
                KeyNavigation.tab: lv
                onTextChanged: {
                    r.buscando=true
                    lv.currentIndex=0
                    if(text===''){
                        lm.clear()
                        return
                    }
                    search()
                }
            }
            Rectangle{
                width: rowRB.width+app.fs
                height: app.fs*2
                anchors.verticalCenter: parent.verticalCenter
                border.width: unikSettings.borderWidth
                border.color: app.c1
                radius: app.fs*0.25
                color: 'transparent'
                Row{
                    id: rowRB
                    spacing: app.fs*0.5
                    anchors.verticalCenter: parent.verticalCenter
                    UText{text: '<b>Buscar por:</b>';anchors.verticalCenter: parent.verticalCenter}
                    URadioButton{
                        id: rbCod
                        text: 'Código'
                        font.pixelSize: app.fs
                        checked: true
                        d: app.fs*1.4
                        onCheckedChanged: search()
                    }
                    URadioButton{
                        id: rbDes
                        text: 'Descripción'
                        font.pixelSize: app.fs
                        d: app.fs*1.4
                        onCheckedChanged: search()
                    }
                }

            }
            BotonUX{
                id: botSearch
                text: 'Buscar'
                height: app.fs*2
            }
        }
        UText{id: cant}
        ListView{
            id: lv
            model: lm
            delegate: rbCod.checked?delPorCod:delPorDes
            spacing: app.fs*0.5
            width: parent.width
            height: r.height-tiSearch.height-app.fs*2-cant.height
            clip: true
            onFocusChanged: currentIndex=1
            KeyNavigation.tab: tiSearch
            Keys.onDownPressed: {
                if(currentIndex<lm.count-1){
                    currentIndex++
                }else{
                    currentIndex=1
                }
            }
            Keys.onUpPressed: {
                if(currentIndex>1){
                    currentIndex--
                }else{
                    currentIndex=lm.count-1
                }
            }
            ListModel{
                id: lm
                function addProd(pid, pcod, pdes, pcos, pven, pstock, pgan){
                    return{
                        vpid: pid,
                        vpcod: pcod,
                        vpdes: pdes,
                        vpcos:pcos,
                        vpven: pven,
                        vpstock: pstock,
                        vpgan: pgan
                    }
                }
            }
            Component{
                id: delPorCod
                Rectangle{
                    id:xRowDes
                    width: parent.width
                    height: parseInt(vpid)!==-10?txtDes.height+app.fs:app.fs*3
                    radius: app.fs*0.1
                    border.width: 2
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: parseInt(vpid)!==-10&&index!==lv.currentIndex?app.c1:app.c2
                    property string fontColor: index!==lv.currentIndex?app.c2:app.c1
                    Row{
                        visible: parseInt(vpid)!==-10
                        anchors.centerIn: parent
                        Rectangle{
                            id: xRD1
                            width: app.fs*10
                            height:xRD2.height
                            border.width: 2
                            border.color: app.c2
                            color: parseInt(vpid)!==-10&&index!==lv.currentIndex?app.c1:app.c2
                            UText{
                                text: vpcod
                                anchors.centerIn: parent
                                color: xRowDes.fontColor
                            }
                        }
                        Rectangle{
                            id: xRD2
                            width: xRowDes.width-xRD1.width-xRD3.width
                            height:txtDes.contentHeight+app.fs*2
                            border.width: 2
                            border.color: app.c2
                            color: parseInt(vpid)!==-10&&index!==lv.currentIndex?app.c1:app.c2
                            UText{
                                id: txtDes
                                text: vpdes
                                color: xRowDes.fontColor
                                width: parent.width-app.fs
                                wrapMode: Text.WordWrap
                                anchors.centerIn: parent
                            }
                        }
                        Rectangle{
                            id: xRD3
                            width: app.fs*10
                            height:xRD2.height
                            border.width: 2
                            border.color: app.c2
                            color: parseInt(vpid)!==-10&&index!==lv.currentIndex?app.c1:app.c2
                            UText{
                                text: '$'+vpcos
                                color: xRowDes.fontColor
                                anchors.centerIn: parent
                            }
                        }
                    }
                    Rectangle{
                        visible: parseInt(vpid)===-10
                        width: xRowDes.width
                        height:app.fs*3
                        border.width: 2
                        border.color: app.c2
                        color: app.c1
                        UText{
                            text: tiSearch.text==='*'?'Mostrando todos los productos.':'Resultados de '+tiSearch.text
                            color: app.c2
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: parent.left
                            anchors.leftMargin: app.fs
                        }
                    }
                BotonUX{
                    text: 'Eliminar'
                    height: app.fs*2
                    fontColor: app.c2
                    bg.color: app.c1
                    glow.radius: 2
                    visible: index===lv.currentIndex&&parseInt(vpid)!==-10
                    anchors.right: parent.right
                    anchors.rightMargin: app.fs*0.5
                    anchors.verticalCenter: parent.verticalCenter
                    onClicked: {
                        let sql='delete from '+r.currentTableName+' where id='+vpid
                        unik.sqlQuery(sql)
                        search()
                    }
                }
            }
        }
        Component{
            id: delPorDes
            Rectangle{
                width: parent.width
                height: txt.contentHeight+app.fs
                radius: app.fs*0.1
                border.width: 2
                anchors.horizontalCenter: parent.horizontalCenter
                color: parseInt(vpid)!==-10&&index!==lv.currentIndex?app.c1:app.c2
                UText{
                    id: txt
                    color:parseInt(vpid)!==-10&&index!==lv.currentIndex?app.c2:app.c1
                    font.pixelSize: app.fs
                    text: parseInt(vpid)!==-10? '<b style="font-size:'+app.fs+'px;">Código: </b><span style="font-size:'+app.fs+'px;">'+vpcod+'</span><br /><br /><b  style="font-size:'+app.fs*1.4+'px;">Descripción: </b><span style="font-size:'+app.fs+'px;">'+vpdes+'</span><br /><br /><b style="font-size:'+app.fs+'px;">Precio de Costo: </b> <span style="font-size:'+app.fs+'px;">$'+vpcos+'</span><br><b style="font-size:'+app.fs+'px;">Precio de Venta: </b> <span style="font-size:'+app.fs+'px;">$'+vpven+'</span><br /><b>Cantidad en Stock: </b>'+vpstock+'<br /><b>Ganancia: </b>'+vpgan:(tiSearch.text==='*'?'Mostrando todos los productos':'<b>Resultados por descripción:</b> '+tiSearch.text)
                    textFormat: Text.RichText
                    width: parent.width-app.fs
                    wrapMode: Text.WordWrap
                    anchors.centerIn: parent
                }
                BotonUX{
                    text: 'Eliminar'
                    height: app.fs*2
                    fontColor: app.c2
                    bg.color: app.c1
                    glow.radius: 2
                    visible: index===lv.currentIndex&&parseInt(vpid)!==-10
                    anchors.right: parent.right
                    anchors.rightMargin: app.fs*0.5
                    anchors.top: parent.top
                    anchors.topMargin: app.fs*0.5
                    onClicked: {
                        let sql='delete from '+r.currentTableName+' where id='+vpid
                        unik.sqlQuery(sql)
                        search()
                    }
                }
            }
        }
    }
}
function search(){
    if(!buscando)return
    lm.clear()

    let colSearch=''
    if(rbCod.checked){
        colSearch='cod'
    }else{
        colSearch='des'
    }

    var p1=tiSearch.text!=='*'?tiSearch.text.split(' '):('').split(' ')
    lm.append(lm.addProd('-10', tiSearch.text, '', '','','',''))
    var b=colSearch+' like \'%'
    //b+=p1[0]+'%'
    for(var i=0;i<p1.length;i++){
        b+=p1[i]+'%'
    }
    b+='\' or '+colSearch+' like \'%'
    for(i=p1.length-1;i>-1;i--){
        b+=p1[i]+'%'
    }
    b+='\''
    var sql='select distinct * from productos where '+b+''
    console.log('Sql: '+sql)

    var rows=unik.getSqlData(sql)
    //console.log('Sql count result: '+rows.length)
    cant.text='Resultados: '+rows.length
    for(i=0;i<rows.length;i++){
        lm.append(lm.addProd(rows[i].col[0], rows[i].col[1], rows[i].col[2], rows[i].col[3], rows[i].col[4], rows[i].col[5], rows[i].col[6]))
    }

    b=''
    for(var i=0;i<p1.length-1;i++){
        /*if(i===0){
                b+='nombre like \'%'+p1[i]+'%\' '
            }else{
                b+='or nombre like \'%'+p1[i]+'%\' '
            }*/
        lm.append(lm.addProd('-10', p1[i], '', '','','',''))
        sql='select distinct * from productos where '+colSearch+' like \'%'+p1[i]+'%\''
        console.log('Sql 2: '+sql)
        var rows2=unik.getSqlData(sql)
        //console.log('Sql count result: '+rows.length)
        //cant.text='Resultados: '+parseInt(rows.length+rows2.length)
        for(var i2=0;i2<rows2.length;i2++){
            lm.append(lm.addProd(rows2[i2].col[0], rows2[i2].col[1], rows2[i2].col[2], rows2[i2].col[3], rows2[i2].col[4], rows2[i].col[5], rows2[i].col[6]))
        }
    }
}
}
