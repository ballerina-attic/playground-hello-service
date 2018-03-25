import ballerina/net.http;
import ballerina/io;

// A service endpoint listens to HTTP request on port 9090
endpoint http:ServiceEndpoint listener {
    port:9090
};

// A service is a network-accessible API
// Advertised on '/hello', port comes from listener endpoint
service<http:Service> hello bind listener {

    // A resource is an invokable API method
    // Accessible on '/hello/sayHello
    // 'caller' is the client invoking this resource 
    sayHello (endpoint caller, http:Request request) {
        http:Response response = {};
        // set the response payload
        response.setStringPayload("Hello Ballerina!\n");
        // Send a response back to caller
        // Errors that could occur are ignored using '_'
        _ = caller -> respond(response);
    }
}