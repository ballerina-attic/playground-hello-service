import ballerina/net.http;
import ballerina/data.sql;

// A ServiceEndpoint listens to HTTP request on port 9090
endpoint http:ServiceEndpoint listener {
    port:9090
};

// A sql client endpoint can be used to connect to a database
// and execute SQL queries against it.
endpoint sql:Client customerDB {
    database:sql:DB.H2_FILE,
    host:"./",
    port:10,
    name:"CUSTOMER_DB",
    username:"root",
    password:"root",
    options:{maximumPoolSize:5}
};

// A service is a network-accessible API
@http:ServiceConfig {
    basePath:"/"
}
service<http:Service> data_service bind dataServiceEP {

    // A resource is an invokable API method
    // This resource only accepts HTTP GET requests on '/customer'
    // 'caller' is the client invoking this resource
    @http:ResourceConfig {
        methods:["GET"],
        path:"/customer"
    }
    customers (endpoint caller, http:Request req) {

        // Invoking the 'customerDB' sql Client connector
        // and execute specified 'select' query on the database.
        // A table is returned as the response from the SQL Client connector.
        // Errors that could occur are ignored by using '=?'.
        // Table represents a database table with in the program.
        table dt =? customerDB -> select("SELECT * FROM CUSTOMER", null, null);
        // Convert data table to JSON object.
        json response =? <json>dt;
        http:Response res = {};
        // Set the JSON payload to the response message
        res.setJsonPayload(response);

        // Send the response back to the caller.
        _ = caller -> respond(res);
    }
}