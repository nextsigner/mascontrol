import QtQuick 2.0
import QtWebEngine 1.5

Item {
    id: r
    anchors.fill: parent
    WebEngineView{//Necesita args app --disable-web-security
        id: wv
        width: 2480*0.5
        height:3508*0.5
        settings.localContentCanAccessRemoteUrls: true
        settings.localStorageEnabled: true
        property string fn: ''
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
        Rectangle{
            id: itemPDF
            width: 2480*0.5
            height:colPdfPages.height//3508*0.5
            Column{
                id: colPdfPages
                spacing: 5
                Repeater{
                    model: 8
                    Rectangle{
                        id: pdfPage
                        width: 2480*0.5
                        height:3508*0.5+1
                        //color: '#ff8833'
                        border.width: 1
                        property int cabHeight: 0
                        UText {
                            text: 'PDF ejemplo '+parseInt(index+1)
                            color: 'white'
                            font.pixelSize: app.fs*3
                            anchors.centerIn: parent
                        }
                        Component.onCompleted: {
                            let comp=compCabFact
                            let obj=comp.createObject(pdfPage, {})

                            let compRCT=compRowCabTabla
                            let objRCT=compRCT.createObject(pdfPage, {})
                            objRCT.y=objRCT.parent.cabHeight+r.printMarginTop+r.hRows

                            let compRPT=compRowPieTablaTotal
                            let objRPT=compRPT.createObject(pdfPage, {})

                        }
                    }
                }
            }
        }
    }
    property int printMarginTop: 60
    property int fontSize: 16
    property int hRows: 30
    property var colsWidth: [0.08, 0.61, 0.08, 0.08,0.15]
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
                    Rectangle{
                        width: xRowCabTabla.width*r.colsWidth[4]
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
                height: xRowCabTabla.parent.height-xRowCabTabla.parent.cabHeight*2
                color: 'black'
            }
            Row{
                anchors.top: parent.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                Repeater{
                    model: 5
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
                                if(index===3){
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
                    width: xRowPieTablaTotal.width*(r.colsWidth[0]+r.colsWidth[1]+r.colsWidth[2]+r.colsWidth[3])
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
                    width: xRowPieTablaTotal.width*r.colsWidth[4]
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
    BotonUX{
        text: 'Print'
        onClicked: {
            itemToImage(itemPDF)
        }
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
}
