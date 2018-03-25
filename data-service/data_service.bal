import ballerina/net.http;
import ballerina/data.sql;

endpoint http:ServiceEndpoint dataServiceEP {
    port:9090
};

endpoint sql:Client customers_db {
    database:sql:DB.H2_FILE,
    host:"./",
    port:10,
    name:"CUSTOMER_DB",
    username:"root",
    password:"root",
    options:{maximumPoolSize:5}
};


@http:ServiceConfig {
    basePath:"/"
}
service<http:Service> data_service bind dataServiceEP {

    @http:ResourceConfig {
        methods:["GET"],
        path:"/customer"
    }
    customers (endpoint client, http:Request req) {
        table dt =? customers_db -> select("SELECT * FROM CUSTOMER", null, null);
        var response =? <json>dt;
        http:Response res = {};
        res.setJsonPayload(response);
        _ = client -> respond(res);
    }
}