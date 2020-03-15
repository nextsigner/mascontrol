import QtQuick 2.0
import QtWebEngine 1.5

Item {
    id: r
    anchors.fill: parent
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
                    UText {
                        text: 'PDF ejemplo '+parseInt(index+1)
                        color: 'white'
                        font.pixelSize: app.fs*3
                        anchors.centerIn: parent
                    }
                    Component.onCompleted: {
                        let comp=compCabFact
                        let obj=comp.createObject(pdfPage, {})
                    }
                }
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
            anchors.topMargin: 60
            property int hRows: 30
            property string fecha: '00/00/000'
            property string srs: 'Salta'
            property string domicilio: 'Rodney 5561 Gregorio de Laferrere'
            property string cuit: '30-18546365-3'
            Column{
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 10
                Row{
                    id: colCabFact
                    spacing: 60
                    Rectangle{
                        width:xCabFact.width*0.5
                        height: xCabFact.hRows
                        color: '#888'
                        border.width: 1
                        radius: 6
                        UText{
                            text: '<b>Presupuesto</b> '
                            font.pixelSize: 24
                            anchors.centerIn: parent
                            color: 'white'
                        }
                    }
                    Rectangle{
                        width:xCabFact.width*0.5
                        height: xCabFact.hRows
                        color: '#888'
                        border.width: 1
                        radius: 6
                        UText{
                            text: '<b>Fecha:</b> '+xCabFact.fecha;
                            font.pixelSize: 24
                            color: 'white'
                            anchors.centerIn: parent
                        }
                    }
                }
                Row{
                    spacing: 30
                    anchors.horizontalCenter: parent.horizontalCenter
                    Rectangle{
                        width: xCabFact.width*0.5-parent.spacing*0.5
                        height: 30
                        UText{
                            text: '<b>Señor/es: </b>'+xCabFact.srs
                            color: 'black'
                            font.pixelSize: 24
                            anchors.verticalCenter: parent.verticalCenter
                        }
                        Rectangle{
                            width: parent.width
                            height: 2
                            color: 'black'
                            anchors.bottom: parent.bottom
                        }
                    }
                    Rectangle{
                        width: xCabFact.width*0.5-parent.spacing*0.5
                        height: 30
                        UText{
                            text: '<b>IVA: </b>'
                            color: 'black'
                            font.pixelSize: 24
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
                    spacing: 30
                    anchors.horizontalCenter: parent.horizontalCenter
                    Rectangle{
                        width: xCabFact.width*0.5-parent.spacing*0.5
                        height: 30
                        UText{
                            text: '<b>Domicilio: </b>'+xCabFact.domicilio
                            color: 'black'
                            font.pixelSize: 24
                            anchors.verticalCenter: parent.verticalCenter
                        }
                        Rectangle{
                            width: parent.width
                            height: 2
                            color: 'black'
                            anchors.bottom: parent.bottom
                        }
                    }
                    Rectangle{
                        width: xCabFact.width*0.5-parent.spacing*0.5
                        height: 30
                        UText{
                            text: '<b>CUIT: </b>'+xCabFact.cuit
                            color: 'black'
                            font.pixelSize: 24
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

            }
        }
    }
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
