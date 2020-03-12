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
                label: 'Buscar:'
                width: r.width-botSearch.width-app.fs*2
            }
            BotonUX{
                id: botSearch
                text: 'Buscar'
                height: app.fs*2
            }
        }
    }
}
