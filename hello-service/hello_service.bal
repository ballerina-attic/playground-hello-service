// A system package containing protocol access constructs
// Package objects referenced with 'http:' in code
import ballerina/http;
import ballerina/io;

// A service is a network-accessible API
// Advertised on '/hello', port comes from listener endpoint
service<http:Service> hello bind {} {

    // A resource is an invokable API method
    // Accessible at '/hello/sayHello
    // 'caller' is the client invoking this resource 
    sayHello (endpoint caller, http:Request request) {

        // Create object to carry data back to caller
        http:Response response = new;

        // Objects and structs can have function calls
        response.setStringPayload("Hello Ballerina!\n");

        // Send a response back to caller
        // Errors are ignored with '_'
        // -> indicates a synchronous network-bound call
        _ = caller -> respond(response);
    }
}