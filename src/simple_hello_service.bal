
import ballerina/net.http;
import ballerina/io;

// An endpoint is a network interface
endpoint http:ServiceEndpoint listener {
    port:9090
};

// A service is a network-accessible API
// Advertise on '/hello', port comes from listener endpoint
service<http:Service> hello bind listener {

    // Service functions act as API resources
    // A resource is an invocable API method
    // 'caller' is the client invoking this resource 
    sayHello (endpoint caller, http:Request request) {
        http:Response response = {};
        // set the response payload
        response.setStringPayload("Hello Ballerina");
        // Send a response back to caller.
        _ = caller -> respond(response);
    }
}