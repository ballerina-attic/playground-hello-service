import ballerina/net.http;
import ballerina/io;

@Description {value:"HTTP interface for the service."}
endpoint http:ServiceEndpoint httpListener {
    port:9090
};

@Description {value:"Service that binds to HTTP listern with service path '/hello'."}
@http:ServiceConfig { basePath:"/hello" }
service<http:Service> helloService bind httpListener {

    @Description {value:"Resource that only allows POST requests coming on path '/' "}
    @http:ResourceConfig {
        path:"/",
        methods:["POST"]
    }
    sayHello (endpoint caller, http:Request request) {
        http:Response response = {};

        // Get request payload as a string
        var reqPayloadVar = request.getStringPayload();

        match reqPayloadVar {
            string reqPayload => {
                // set the response payload
                response.setStringPayload("Hello, " + reqPayload + "\n");
            }
            any | null => {
                io:println("No payload found!");
            }
        }
        // Send response back to caller.
        _ = caller -> respond(response);
    }
}