import ballerina/net.http;
import ballerina/io;

// An endpoint is a network interface
endpoint http:ServiceEndpoint listener {
    port:9090
};

// A service is a network-accessible API
// Advertise on '/hello', port comes from listener endpoint
service<http:Service> hello bind listener {

    // A resource is an invokable API method
    // Accessible on '/hello/sayHello
    // 'caller' is the client invoking this resource 
    sayHello (endpoint caller, http:Request request) {
        http:Response response = {};
        // set the response payload
        response.setStringPayload("Hello Ballerina!\n");
        // Send a response back to caller.
        _ = caller -> respond(response);
    }
}