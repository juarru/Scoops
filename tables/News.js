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

/*
* Permisos de acceso a la tabla
* */

table.read.access = 'authenticated';
//table.update.access = 'disabled';

module.exports = table;