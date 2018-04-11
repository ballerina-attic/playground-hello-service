// Packages contain functions, annotations and
// connectors. This package is referenced by
// ‘http’ namespace in the code body.
import ballerina/http;
import ballerina/io;

// A service is a network-accessible API. This
// service accessible at '/hello', and bound to a
// default listener on port 9090. `http:Service`
// is a connector in the `http` package.
service<http:Service> hello bind {} {

    // A resource is an invokable API method
    // Accessible at '/hello/sayHello’
    // 'caller' is the client invoking this resource
    sayHello (endpoint caller, http:Request request) {

      // Create object to carry data back to caller
      http:Response response = new;

      // Objects have function calls
      response.setStringPayload("Hello Ballerina!\n");

      // Send a response back to caller
      // Errors are ignored with '_'
      // ‘->’ is a synchronous network-bound call

      _ = caller -> respond(response);
    }
}