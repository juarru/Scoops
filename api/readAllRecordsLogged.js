/**
 * Created by juan_arillo on 30/10/16.
 */

/**
 * Created by juan_arillo on 29/10/16.
 */

var api = {

    get: function (req, res, next) {

        // chequeo de parametros
        //if (typeof req.params.length <0) {
        //    return next();
        //}

        var context = req.azureMobile;
        var user = context.user.id;

        var query = {
            sql: "Select * from News where userId = '" + user + "'"
        };

        context.data.execute(query)
            .then(function (result) {
                res.json(result);
            });

    }

};

api.get.access = 'authenticated';
module.exports = api;