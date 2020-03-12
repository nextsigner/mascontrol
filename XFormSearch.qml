import QtQuick 2.0

Item {
    id: r
    anchors.fill: parent
    Column{
        width: parent.width
        height: parent.height
        Row{
            spacing: app.fs
            anchors.horizontalCenter: parent.horizontalCenter
            UTextInput{
                id: tiSearch
                label: 'Buscar:'
                width: r.width-botSearch.width-app.fs*2
                onTextChanged: {
                    search()
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
            delegate: delPorCod
            spacing: app.fs*0.5
            width: parent.width
            height: r.height-tiSearch.height-app.fs*2-cant.height
            clip: true
        }
    }
    ListModel{
        id: lm
        function addProd(pid, pcod, pdes, pcos, pven, pstock){
            return{
                vpid: pid,
                vpcod: pcod,
                vpdes: pdes,
                vpcos:pcos,
                vpven: pven,
                vpstock: pstock
            }
        }
    }

    Component{
        id: delPorCod
        Rectangle{
            width: parent.width-app.fs*0.5
            height: txt.contentHeight+app.fs
            radius: app.fs*0.1
            border.width: 2
            anchors.horizontalCenter: parent.horizontalCenter
            color: parseInt(vpid)!==-10?app.c1:app.c2
            UText{
                id: txt
                color:parseInt(vpid)!==-10?app.c2:app.c1
                font.pixelSize: app.fs
                text: parseInt(vpid)!==-10? '<b style="font-size:'+app.fs+'px;">Código: </b><span style="font-size:'+app.fs+'px;">$'+vpcod+'</span><br /><br /><b  style="font-size:'+app.fs*1.4+'px;">Descripción:</b><span style="font-size:'+app.fs+'px;">'+vpdes+'</span><br /><br /><b style="font-size:'+app.fs+'px;">Precio de Costo:</b> <span style="font-size:'+app.fs+'px;">$'+vpcos+'</span><br><b style="font-size:'+app.fs+'px;">Precio de Venta:</b> <span style="font-size:'+app.fs+'px;">$'+vpven+'</span><br /><b>Cantidad en Stock:</b>'+vpstock :'<b>Resultados con por código:</b> '+tiSearch.text
                textFormat: Text.RichText
                width: parent.width-app.fs
                wrapMode: Text.WordWrap
                anchors.centerIn: parent
            }
        }
    }
    function search(){
        lm.clear()

        var p1=tiSearch.text.split(' ')
        lm.append(lm.addProd('-10', tiSearch.text, '', '',''))
        var b='cod like \'%'
        //b+=p1[0]+'%'
        for(var i=0;i<p1.length;i++){
            b+=p1[i]+'%'
        }
        b+='\' or cod like \'%'
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
            lm.append(lm.addProd(rows[i].col[0], rows[i].col[1], rows[i].col[2], rows[i].col[3], rows[i].col[4], rows[i].col[5]))
        }

        b=''
        for(var i=0;i<p1.length-1;i++){
            /*if(i===0){
                b+='nombre like \'%'+p1[i]+'%\' '
            }else{
                b+='or nombre like \'%'+p1[i]+'%\' '
            }*/
            lm.append(lm.addProd('-10', p1[i], '', '',''))
            sql='select distinct * from productos where nombre like \'%'+p1[i]+'%\''
            console.log('Sql 2: '+sql)
            var rows2=unik.getSqlData(sql)
            //console.log('Sql count result: '+rows.length)
            //cant.text='Resultados: '+parseInt(rows.length+rows2.length)
            for(var i2=0;i2<rows2.length;i2++){
                lm.append(lm.addProd(rows2[i2].col[0], rows2[i2].col[1], rows2[i2].col[2], rows2[i2].col[3], rows2[i2].col[4], rows[i].col[5]))
            }
        }
    }
}
