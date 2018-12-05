// Packages contain functions, annotations and connectors. This
// package is referenced with ‘http’ namespace in the code body.
import ballerina/http;
import ballerina/io;

// A service is a network-accessible API. This service is accessed
// at '/hello', and bound to a listener on port 9090.
service hello on new http:Listener(9090) {

  //This resource accessed at '/hello/sayHello’.
  //`caller` is the client calling us.
  resource function sayHello(http:Caller caller, http:Request request) {

    // Create object to carry data back to caller.
    http:Response response = new;

    // Objects have function calls.
    response.setPayload("Hello Ballerina!\n");

    // Send a response to the caller. Ignore errors with `_`.
    // ‘->’ is a synchronous network-bound call.
    _ = caller -> respond(response);
  }
}
