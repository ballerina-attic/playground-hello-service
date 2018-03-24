import ballerina/net.http;
import ballerina/io;


@Description {value:"HTTP interface for the service."}
endpoint http:ServiceEndpoint httpListener {
    port:9090
};


@http:ServiceConfig { basePath:"/hello" }
service<http:Service> helloService bind httpListener {

    @Description {value:"By default Ballerina assumes that the service is to be exposed via HTTP/1.1."}
    @http:ResourceConfig {
        path:"/",
        methods:["POST"]
    }
    sayHello (endpoint caller, http:Request request) {
        http:Response response = {};
        var reqPayloadVar = request.getStringPayload();

        match reqPayloadVar {
            string reqPayload => {
                response.setStringPayload("Hello, " + reqPayload + "\n");
            }
            any | null => {
                io:println("No payload found!");
            }
        }
        _ = caller -> respond(response);
    }
}