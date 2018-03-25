import ballerina/net.http;
import ballerina/io;

// A service endpoint listens to HTTP request on port 9090
endpoint http:ServiceEndpoint listener {
    port:9090
};

// A service is a network-accessible API
// Advertise on '/greeting', port comes from listener endpoint
@http:ServiceConfig {basePath:"/greeting"}
service<http:Service> greeting bind listener {

    // A resource is an invokable API method
    // This resource only accepts HTTP POST requests
    // 'caller' is the client invoking this resource
    @http:ResourceConfig{
        path: "/",  methods: ["POST"]
    }
    greet (endpoint caller, http:Request request) {
        http:Response response = {};

        // Get the request payload as a string
        var reqPayloadVar = request.getStringPayload();
        match reqPayloadVar {
            string reqPayload => {
                // Set a string as the response body.
                response.setStringPayload("Hello, "
                    + reqPayload + "!\n");
            }
            any | null => {
                io:println("No payload found!");
            }
        }
        // Send a response back to caller
        // Errors that could occur are ignored using '_'
        _ = caller -> respond(response);
    }
}