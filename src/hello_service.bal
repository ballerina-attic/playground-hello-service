import ballerina/net.http;
import ballerina/io;

@Description {value:"HTTP interface for the service."}
endpoint http:ServiceEndpoint httpListener {
    port:9090
};

@Description {
    value:"Service binds to httpListener on path '/hello'."
}
service<http:Service> hello bind httpListener {

    @Description {
        value:"Resource accepts request on path '/sayHello'."
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