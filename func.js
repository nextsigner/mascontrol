function setBd() {
    let folderBds=""+pws+"/mascontrol/bds"
    let bd=apps.bdFileName.indexOf('\\')<0?""+folderBds+"/"+apps.bdFileName:""+apps.bdFileName.replace(/\\\\/g, '/')
    if(!unik.fileExist(bd)){
        apps.bdFileName=getNewBdName()
        bd=""+folderBds+"/"+apps.bdFileName
    }
    //bd="C:\\Users\\qt\\Documents\\unik\\mascontrol\\bds\\productos_24_2_20_17_4_1.sqlite"
    //uLogView.showLog('Iniciando Bd: '+bd)
    let iniciado=unik.sqliteInit(bd)
    //uLogView.showLog('Iniciado: '+iniciado)

    let sql='CREATE TABLE IF NOT EXISTS productos'
        +'('
        +'id INTEGER PRIMARY KEY AUTOINCREMENT,'
        +'cod TEXT NOT NULL,'
        +'des TEXT NOT NULL,'
        +'pco DECIMAL(14,2) NOT NULL,'
        +'pve DECIMAL(14,2) NOT NULL,'
        +'stock INTEGER NOT NULL,'
        +'gan INTEGER NOT NULL'
        +')'
    unik.sqlQuery(sql)
    sql='CREATE TABLE IF NOT EXISTS '+app.tableNamaCli+''
            +'('
            +'id INTEGER PRIMARY KEY AUTOINCREMENT,'
            +'cod TEXT NOT NULL,'
            +'nomcom TEXT NOT NULL,'
            +'nomcli TEXT NOT NULL,'
            +'tel TEXT NOT NULL,'
            +'dir TEXT NOT NULL,'
            +'cuit TEXT NOT NULL,'
            +'email TEXT NOT NULL,'
            +'saldo DECIMAL(14,2) NOT NULL'
            +')'
    unik.sqlQuery(sql)
    sql='CREATE TABLE IF NOT EXISTS facts'
            +'('
            +'id INTEGER PRIMARY KEY AUTOINCREMENT,'
            +'ms NUMERIC NOT NULL,'
            +'codcli TEXT NOT NULL,'
            +'com TEXT NOT NULL'
            +')'
    unik.sqlQuery(sql)
    sql='CREATE TABLE IF NOT EXISTS prodfact'
            +'('
            +'id INTEGER PRIMARY KEY AUTOINCREMENT,'
            +'cod TEXT NOT NULL,'
            +'des TEXT NOT NULL,'
            +'desc NUMERIC NOT NULL,'
            +'cant NUMERIC NOT NULL,'
            +'pve DECIMAL(14,2) NOT NULL'
            +')'
    unik.sqlQuery(sql)
    //console.log('Ejecutado: '+ejecutado)
}

function setFolders(){
    if(!unik.folderExist('facts')){
        unik.mkdir('facts')
    }
    unik.debugLog=true

    if(!unik.folderExist(pws+'/mascontrol')){
        unik.mkdir(pws+'/mascontrol')
    }
    if(!unik.folderExist(pws+'/mascontrol/bds')){
        unik.mkdir(pws+'/mascontrol/bds')
    }
    //apps.bdFileName=''
    //apps.bdFileName=unik.currentFolderPath()+'/bds/p.sqlite'
}
