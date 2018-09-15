// Packages contain functions, annotations and connectors. This
// package is referenced with ‘http’ namespace in the code body.
import ballerina/http;
import ballerina/io;

// A service is a network-accessible API. This service is accessed
// at '/hello', and bound to a listener on port 9090.
// `http:Service`is a protocol object in the `http` package.
service<http:Service> hello bind { port: 9090 } {

  // A resource is an invokable API method. This resource accessed
  // at '/hello/sayHello’. `caller` is the client calling us.
  sayHello (endpoint caller, http:Request request) {

    // Create object to carry data back to caller.
    http:Response response = new;

    // Objects have function calls.
    response.setTextPayload("Hello Ballerina!\n");

    // Send a response to the caller. Ignore errors with `_`.
    // ‘->’ is a synchronous network-bound call.
    _ = caller -> respond(response);
  }
}
