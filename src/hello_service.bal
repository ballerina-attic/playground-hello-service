// Packages contain functions, annotations and connectors.
// This package is referenced by ‘http’ namespace in the code
// body.
import ballerina/http;
import ballerina/io;

// Listener endpoint which runs on port 9090, that a service
// binds to.
endpoint http:Listener listener {
  port:9090
};

// A service is a network-accessible API. This service
// is accessible at '/hello', and bound to a the listener.
// `http:Service`is a connector in the `http` package.
service<http:Service> hello bind listener {

  // A resource is an invokable API method.
  // Accessible at '/hello/sayHello’.
  // 'caller' is the client invoking this resource.
  sayHello (endpoint caller, http:Request request) {

    // Create object to carry data back to caller.
    http:Response response = new;

    // Objects have function calls.
    response.setTextPayload("Hello Ballerina!\n");

    // Send a response back to caller.
    // Errors are ignored with '_'.
    // ‘->’ is a synchronous network-bound call.
    _ = caller -> respond(response);
  }
}
