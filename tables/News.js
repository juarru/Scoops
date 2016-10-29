/**
 * Created by juan_arillo on 29/10/16.
 */

var azureMobileApps = require('azure-mobile-apps');

var table = azureMobileApps.table();

table.colums = {
    "title" : "string",
    "text" : "string",
    "photoUrl" : "string",
    "author" : "string",
    "latitude" : "number",
    "longitude": "number",
    "state" : "boolean",
    "points" : "number",
    "counter" : "number"
    
};

/**
 * Trigger para insert userId
 */

table.insert(function (context) {
    context.item.userId = context.user.id;
    return context.execute();
})

/**
 * Trigger para leer con filtros
 */


table.read(function (context) {
    context.query.where ({"state" : 1});
    return context.execute();
})


/*
* Permisos de acceso a la tabla
* */

table.read.access = 'anonymous';
table.update.access = 'authenticated';
table.delete.access = 'authenticated';
table.insert.access = 'authenticated';

module.exports = table;