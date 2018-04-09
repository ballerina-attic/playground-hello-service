import ballerina/http;
import ballerina/sql;

endpoint http:ServiceEndpoint listener {
    port:9090
};


@http:ServiceConfig {
    basePath:"/"
}
service<http:Service> data_service bind listener {

    @http:ResourceConfig {
        methods:["GET"],
        path:"/customer"
    }
    customers (endpoint caller, http:Request req) {

        // Endpoints can connect to dbs with SQL connector
        endpoint sql:Client customerDB {
            database:sql:DB_H2_FILE,
            host:"./",
            port:10,
            name:"CUSTOMER_DB",
            username:"root",
            password:"root",
            options:{ maximumPoolSize:5 }
        };

        // Invoke 'select' command against remote database
        // table primitive type represents a set of records
        var retDt = customerDB -> select(
                                  "SELECT * FROM CUSTOMER",
                                  null,
                                  null);
        table dt = check retDt;
        // tables can be cast to JSON and XML
        json response = check <json>dt;

        http:Response res = new;
        res.setJsonPayload(response);
        _ = caller -> respond(res);
    }
}

