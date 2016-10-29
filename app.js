/**
 * Created by juan_arillo on 29/10/16.
 */

var express = require("express"),
    azuremobileapps = require("azure-mobile-apps");

var app = express(),
    mobile = azuremobileapps();

mobile.table.add("./tables");

mobile.api.add("./api");

app.use(mobile);

app.listen(process.env.PORT || 3000);
