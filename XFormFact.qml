import QtQuick 2.0
import QtWebEngine 1.5

Item {
    id: r
    anchors.fill: parent
    property int mod: 0
    property var prods: []
    XFormFactPrep{
        id: xFormFactPrep
        height: r.height
        visible: r.mod===0
        currentTableName: 'productos'
    }
    WebEngineView{//Necesita args app --disable-web-security
        id: wv
        width: 2480*0.5
        height:3508*0.5
        settings.localContentCanAccessRemoteUrls: true
        settings.localStorageEnabled: true
        property string fn: ''
        visible: r.mod===1
        onLoadProgressChanged:{
            if(loadProgress===100){
                wv.printToPdf('facts/'+wv.fn+'.pdf', WebEngineView.A4, WebEngineView.Portrait)
            }
        }
        onPdfPrintingFinished:{
            console.log(filePath+' '+success)
        }
    }
    Flickable{
        width: itemPDF.width
        height: itemPDF.height
        contentWidth: itemPDF.width
        contentHeight: itemPDF.height*2
        visible: r.mod===1
        Rectangle{
            id: itemPDF
            width: 2480*0.5
            height:colPdfPages.height//3508*0.5
            Column{
                id: colPdfPages
                spacing: 5
            }
        }
        BotonUX{
            text: 'Print'
            onClicked: {
                //itemToImage(itemPDF)
                setFactData()
            }
        }
    }
    property int printMarginTop: 60
    property int fontSize: 16
    property int hRows: 30
    property var colsWidth: [0.07, 0.52, 0.10, 0.10, 0.06,0.15]
    Component{
        id: compPdfPage
        Rectangle{
            id: pdfPage
            width: 2480*0.5
            height:3508*0.5+1
            //color: '#ff8833'
            border.width: 1
            property int cabHeight: 0
            property var prods: []
            Component.onCompleted: {
                let comp=compCabFact
                let obj=comp.createObject(pdfPage, {})

                let compRCT=compRowCabTabla
                let objRCT=compRCT.createObject(pdfPage, {})
                objRCT.y=objRCT.parent.cabHeight+r.printMarginTop+r.hRows

                let yr=objRCT.height+objRCT.y
                for(let i=0;i<prods.length;i++){
                    //uLogView.showLog('cod: '+prods[0].cod)
                    let compRT=compRowTabla
                    let objProdRT={}
                    objProdRT.y=yr
                    objProdRT.cod=prods[i].cod
                    objProdRT.des=prods[i].des
                    objProdRT.cant=prods[i].cant
                    objProdRT.prec=prods[i].prec
                    objProdRT.dto=prods[i].dto

                    let objRT=compRT.createObject(pdfPage, objProdRT)
                    yr+=r.hRows
                }

                let compRPT=compRowPieTablaTotal
                let objRPT=compRPT.createObject(pdfPage, {})
            }
        }
    }
    Component{
        id: compCabFact
        Rectangle{
            id: xCabFact
            width: parent.width*0.8
            height: colCabFact.height
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: r.printMarginTop
            property int hRows: 30
            property int horSpacing: 30
            property string fecha: '00/00/000'
            property string srs: 'Salta'
            property string domicilio: 'Rodney 5561 Gregorio de Laferrere'
            property string cuit: '30-18546365-3'
            //            Rectangle{
            //                anchors.fill: parent
            //                border.width: 4
            //                border.color: 'red'
            //                color: 'green'
            //            }
            Column{
                id: colCabFact
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 10
                Row{
                    spacing: xCabFact.horSpacing
                    anchors.horizontalCenter: parent.horizontalCenter
                    Rectangle{
                        width:xCabFact.width*0.5-xCabFact.horSpacing*0.5
                        height: xCabFact.hRows*1.5
                        color: '#888'
                        border.width: 1
                        radius: 6
                        UText{
                            text: '<b>Presupuesto</b> '
                            font.pixelSize: r.fontSize*1.5
                            anchors.centerIn: parent
                            color: 'white'
                        }
                    }
                    Rectangle{
                        width:xCabFact.width*0.5-xCabFact.horSpacing*0.5
                        height: xCabFact.hRows*1.5
                        color: '#888'
                        border.width: 1
                        radius: 6
                        UText{
                            text: '<b>Fecha:</b> '+xCabFact.fecha;
                            font.pixelSize: r.fontSize*1.5
                            color: 'white'
                            anchors.centerIn: parent
                        }
                    }
                }
                Row{
                    spacing: xCabFact.horSpacing
                    anchors.horizontalCenter: parent.horizontalCenter
                    Item{
                        width: xCabFact.width*0.5-xCabFact.horSpacing*0.5
                        height: 30
                        UText{
                            text: '<b>Señor/es: </b>'+xCabFact.srs
                            color: 'black'
                            font.pixelSize: r.fontSize
                            anchors.verticalCenter: parent.verticalCenter
                        }
                        Rectangle{
                            width: parent.width
                            height: 2
                            color: 'black'
                            anchors.bottom: parent.bottom
                        }
                    }
                    Item{
                        width: xCabFact.width*0.5-xCabFact.horSpacing*0.5
                        height: 30
                        UText{
                            text: '<b>IVA: </b>'
                            color: 'black'
                            font.pixelSize: r.fontSize
                            anchors.verticalCenter: parent.verticalCenter
                        }
                        Rectangle{
                            width: parent.width
                            height: 2
                            color: 'black'
                            anchors.bottom: parent.bottom
                        }
                    }
                }
                Row{
                    spacing: xCabFact.horSpacing
                    anchors.horizontalCenter: parent.horizontalCenter
                    Item{
                        width: xCabFact.width*0.5-xCabFact.horSpacing*0.5
                        height: 30
                        UText{
                            text: '<b>Domicilio: </b>'+xCabFact.domicilio
                            color: 'black'
                            font.pixelSize: r.fontSize
                            anchors.verticalCenter: parent.verticalCenter
                        }
                        Rectangle{
                            width: parent.width
                            height: 2
                            color: 'black'
                            anchors.bottom: parent.bottom
                        }
                    }
                    Item{
                        width: xCabFact.width*0.5-xCabFact.horSpacing*0.5
                        height: 30
                        UText{
                            text: '<b>CUIT: </b>'+xCabFact.cuit
                            color: 'black'
                            font.pixelSize: r.fontSize
                            anchors.verticalCenter: parent.verticalCenter
                        }
                        Rectangle{
                            width: parent.width
                            height: 2
                            color: 'black'
                            anchors.bottom: parent.bottom
                        }
                    }
                }
                Item{
                    width: xCabFact.width
                    height: 30
                    UText{
                        text: '<b>Condiciones: </b>'
                        color: 'black'
                        font.pixelSize: r.fontSize
                        anchors.verticalCenter: parent.verticalCenter
                    }
                    Rectangle{
                        width: parent.width
                        height: 2
                        color: 'black'
                        anchors.bottom: parent.bottom
                    }
                }
            }
            Component.onCompleted: {
                parent.cabHeight=height
            }
        }
    }
    Component{
        id: compRowCabTabla
        Item{
            id: xRowCabTabla
            width: parent.width*0.8
            height: r.hRows*1.5
            anchors.horizontalCenter: parent.horizontalCenter
            Rectangle{
                width: parent.width
                height: parent.height
                clip: true
                Row{
                    Rectangle{
                        width: xRowCabTabla.width*r.colsWidth[0]
                        height: r.hRows*1.5+10
                        border.width: 2
                        radius: 10
                        UText{
                            text: 'Código'
                            font.pixelSize: r.fontSize
                            color: 'black'
                            anchors.centerIn: parent
                            anchors.verticalCenterOffset: -5
                        }
                    }
                    Item{
                        width: xRowCabTabla.width*r.colsWidth[1]
                        height: r.hRows*1.5+10
                        Rectangle{
                            width: parent.width+6
                            height: parent.height
                            border.width: 2
                            radius: 10
                            x:-2
                            UText{
                                text: 'Descripción'
                                font.pixelSize: r.fontSize
                                color: 'black'
                                anchors.centerIn: parent
                                anchors.verticalCenterOffset: -5
                            }
                        }
                    }
                    Rectangle{
                        width: xRowCabTabla.width*r.colsWidth[2]
                        height: r.hRows*1.5+10
                        border.width: 2
                        radius: 10
                        UText{
                            text: 'Cantidad'
                            font.pixelSize: r.fontSize
                            color: 'black'
                            anchors.centerIn: parent
                            anchors.verticalCenterOffset: -5
                        }
                    }
                    Item{
                        width: xRowCabTabla.width*r.colsWidth[3]
                        height: r.hRows*1.5+10
                        Rectangle{
                            width: parent.width+6
                            height: parent.height
                            border.width: 2
                            radius: 10
                            x:-2
                            UText{
                                text: 'Precio\nUnitario'
                                font.pixelSize: r.fontSize
                                color: 'black'
                                anchors.centerIn: parent
                                horizontalAlignment: Text.AlignHCenter
                                anchors.verticalCenterOffset: -5
                            }
                        }
                    }
                    Item{
                        width: xRowCabTabla.width*r.colsWidth[4]
                        height: r.hRows*1.5+10
                        Rectangle{
                            width: parent.width+6
                            height: parent.height
                            border.width: 2
                            radius: 10
                            x:-2
                            UText{
                                text: '% Dto.'
                                font.pixelSize: r.fontSize
                                color: 'black'
                                anchors.centerIn: parent
                                horizontalAlignment: Text.AlignHCenter
                                anchors.verticalCenterOffset: -5
                            }
                        }
                    }
                    Rectangle{
                        width: xRowCabTabla.width*r.colsWidth[5]
                        height: r.hRows*1.5+10
                        border.width: 2
                        radius: 10
                        UText{
                            text: 'Total'
                            font.pixelSize: r.fontSize
                            color: 'black'
                            anchors.centerIn: parent
                            anchors.verticalCenterOffset: -5
                        }
                    }
                }
                Rectangle{
                    width: xRowCabTabla.width
                    height: 2
                    color: 'black'
                    anchors.bottom: parent.bottom
                }
            }
            Rectangle{
                width: 2
                height: xRowCabTabla.parent.height-xRowCabTabla.parent.cabHeight*2-parent.height
                color: 'black'
                anchors.top: parent.bottom
            }
            Row{
                anchors.top: parent.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                Repeater{
                    model: 6
                    Item{
                        width: xRowCabTabla.width*r.colsWidth[index]
                        height: xRowCabTabla.parent.height-xRowCabTabla.parent.cabHeight*2-parent.parent.height
                        Rectangle{
                            width: 2
                            height: parent.height
                            color: 'black'
                            anchors.right: parent.right
                            Component.onCompleted: {
                                if(index===1){
                                    anchors.rightMargin=-2
                                }
                                if(index===4){
                                    anchors.rightMargin=-2
                                }
                            }
                        }

                    }
                }
                Component.onCompleted: {

                }
            }
        }
    }
    Component{
        id: compRowTabla
        Item{
            id: xRowTabla
            width: parent.width*0.8
            height: r.hRows
            anchors.horizontalCenter: parent.horizontalCenter
            property string cod: '000000'
            property string des: 'abc'
            property int cant: 0
            property int dto: 0
            property real prec: 0
            Item{
                width: parent.width
                height: parent.height
                clip: true
                Row{
                    Item{
                        width: xRowTabla.width*r.colsWidth[0]
                        height: r.hRows
                        UText{
                            text: xRowTabla.cod
                            font.pixelSize: r.fontSize
                            color: 'black'
                            anchors.centerIn: parent
                        }
                    }
                    Item{
                        width: xRowTabla.width*r.colsWidth[1]
                        height: r.hRows
                        Item{
                            width: parent.width+6
                            height: parent.height
                            x:-2
                            UText{
                                text: xRowTabla.des
                                font.pixelSize: r.fontSize
                                color: 'black'
                                anchors.centerIn: parent
                            }
                        }
                    }
                    Item{
                        width: xRowTabla.width*r.colsWidth[2]
                        height: r.hRows
                        UText{
                            text: xRowTabla.cant
                            font.pixelSize: r.fontSize
                            color: 'black'
                            anchors.centerIn: parent
                        }
                    }
                    Item{
                        width: xRowTabla.width*r.colsWidth[3]
                        height: r.hRows
                        Item{
                            width: parent.width+6
                            height: parent.height
                            x:-2
                            UText{
                                text: xRowTabla.prec
                                font.pixelSize: r.fontSize
                                color: 'black'
                                anchors.centerIn: parent
                                horizontalAlignment: Text.AlignHCenter
                            }
                        }
                    }
                    Item{
                        width: xRowTabla.width*r.colsWidth[4]
                        height: r.hRows
                        UText{
                            text: '%'+xRowTabla.dto
                            font.pixelSize: r.fontSize
                            color: 'black'
                            anchors.centerIn: parent
                        }
                    }
                    Item{
                        width: xRowTabla.width*r.colsWidth[5]
                        height: r.hRows
                        UText{
                            //text: '$'+parseFloat(xRowTabla.prec*xRowTabla.cant)
                            font.pixelSize: r.fontSize
                            color: 'black'
                            anchors.centerIn: parent
                            Component.onCompleted: {
                                let totalSinDto=parseFloat(xRowTabla.prec*xRowTabla.cant)
                                let vdto=totalSinDto / 100 * parseInt(dto)
                                let totalConDto=parseFloat(totalSinDto-vdto).toFixed(2)
                                text='$'+totalConDto
                            }
                        }
                    }
                }
                Rectangle{
                    width: xRowTabla.width
                    height: 2
                    color: 'black'
                    anchors.bottom: parent.bottom
                }
            }
        }
    }
    Component{
        id: compRowPieTablaTotal
        Rectangle{
            id: xRowPieTablaTotal
            width: parent.width*0.8
            height: r.hRows
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            anchors.bottomMargin: r.printMarginTop
            clip: true
            property int total: 0
            property int saldoAnterior: 0
            Row{
                Item{
                    width: xRowPieTablaTotal.width*(r.colsWidth[0]+r.colsWidth[1]+r.colsWidth[2]+r.colsWidth[3]+r.colsWidth[4])
                    height: r.hRows+10
                    Rectangle{
                        width: parent.width+2
                        height: parent.height
                        y:-10
                        border.width: 2
                        radius: 10
                        UText{
                            text: '<b>Saldo anterior: </b>$'+saldoAnterior+' <b>Total: </b>'
                            font.pixelSize: r.fontSize
                            color: 'black'
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.verticalCenterOffset: 5
                            anchors.right: parent.right
                            anchors.rightMargin: r.fontSize
                        }
                    }
                }
                Rectangle{
                    width: xRowPieTablaTotal.width*r.colsWidth[5]
                    height: r.hRows+10
                    y:-10
                    border.width: 2
                    radius: 10
                    UText{
                        text: '$'+xRowPieTablaTotal.total
                        font.pixelSize: r.fontSize
                        color: 'black'
                        anchors.centerIn: parent
                        anchors.verticalCenterOffset: 5
                    }
                }
            }
            Rectangle{
                width: xRowPieTablaTotal.width
                height: 2
                color: 'black'
                anchors.top: parent.top
            }
        }
    }

    Timer{
        id: tPrint
        running: false
        repeat: false
        interval: 1500
        onTriggered: {
            itemToImage(itemPDF)
        }
    }
    Component.onCompleted:{
        /*let cPdfPage=compPdfPage

        let pds=[]
        for(let i=0;i<45;i++){
            let prod={}
            prod.cod='cod-'+parseInt(i + 1)
            prod.des='des-'+i
            prod.cant=10
            prod.prec=33
            prod.descu=10
            pds.push(prod)
        }
        let oPdfPage=cPdfPage.createObject(colPdfPages, {prods:pds})
        tPrint.start()*/
    }
    function itemToImage(item){
        let d = new Date(Date.now())
        let fn='fact_'+d.getTime()
        wv.fn=fn
        item.grabToImage(function(result) {
            result.saveToFile('facts/'+fn+".jpg");
            let html='<!DOCTYPE html>'+
                '<html>'+
                '<body style="width:100%; margin:0 auto;text-align:center;">'+
                '<img style="width:790px;" src="file:///facts/'+fn+'.jpg" />'+
                '</body>'+
                '</html>'
            wv.loadHtml(html)
        });
    }
    function setFactData(){
        let cPdfPage=compPdfPage

        let pds=[]
        for(let i=0;i<r.prods.length;i++){
            let prod={}
            prod.cod=r.prods[i].cod
            prod.des=r.prods[i].des
            prod.cant=r.prods[i].cant
            prod.prec=r.prods[i].ven
            prod.dto=r.prods[i].dto
            pds.push(prod)
        }
        let oPdfPage=cPdfPage.createObject(colPdfPages, {prods:pds})
        tPrint.start()
    }
}
