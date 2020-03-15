import QtQuick 2.0
import QtWebEngine 1.5

Item {
    id: r
    anchors.fill: parent
    Rectangle{
        id: itemPDF
        width: 2480*0.5
        height:3508*0.5
        color: 'red'
        border.width: 4
        border.color: 'green'
        UText {
            id: name
            text: 'PDF ejemplo'
            color: 'white'
            font.pixelSize: app.fs*3
            anchors.centerIn: parent
        }
    }
    WebEngineView{
        id: wv
        width: 2480*0.5
        height:3508*0.5
        settings.localContentCanAccessRemoteUrls: true
        settings.localStorageEnabled: true
        //url: 'file:///C:/Users/qt/Downloads/a4.jpg'
        onPdfPrintingFinished:{
            console.log(filePath+' '+success)
        }
        Component.onCompleted: {
            let html='<!DOCTYPE html>'+
                '<html>'+
                '<head>'+
                '  <meta charset="UTF-8">'+
                '</head>'+
                '<body style="width:100%; color:yellow">'+
                '<img style="width:100%;" src="file:///E:/nsp/unik-dev-apps/mascontrol/a4_2.jpg" />'+
                '</body>'+
                '</html>'
            wv.loadHtml(html)
        }
    }
    BotonUX{
        text: 'Print'
        onClicked: {
            itemToImage(itemPDF)
        }
    }

    function itemToImage(item){
        item.grabToImage(function(result) {
            result.saveToFile("a4_2.jpg");
            let html='<!DOCTYPE html>'+
                '<html>'+
                '<body style="width:100%; color:yellow">'+
                '<img style="width:100%;" src="./a4_2.jpg" />'+
                '</body>'+
                '</html>'
            wv.loadHtml(html)
            wv.printToPdf('aaa.pdf', WebEngineView.A4, WebEngineView.Portrait)
        });
    }
}
