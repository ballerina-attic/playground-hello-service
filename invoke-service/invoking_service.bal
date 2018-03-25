import ballerina/net.http;
import ballerina/io;

// A ServiceEndpoint listens to HTTP request on port 9090
endpoint http:ServiceEndpoint httpListenerEP {
    port:9090
};

// A ClientEndpoint can be used to invoke an external services
endpoint http:SimpleClientEndpoint timeServiceEP {
    url:"http://localhost:9095"
};

// A service is a network-accessible API
// Advertise on '/time', port comes from listener endpoint
@http:ServiceConfig {basePath:"/time"}
service<http:Service> timeInfo bind httpListenerEP {

    // A resource is an invokable API method
    // This resource only accepts HTTP GET requests
    // 'caller' is the client invoking this resource
    @http:ResourceConfig {
        methods:["GET"],
        path:"/"
    }
    getTime (endpoint caller, http:Request req) {

        // Invoke the backend service through 'timeServiceEP' client endpoint
        // by sending a HTTP GET request on path '/localtime'.
        // The response received for the GET request is assigned
        // to a http:Response and errors are ignored by using =?.
        http:Response response =? timeServiceEP -> get("/localtime", {});
        // Get the JSON response body from the response ignore errors.
        json time =? response.getJsonPayload();

        // Create a custom JSON payload to be send as the response to the caller
        // Add the json response that we received from the backend service to
        // the new json payload.
        json payload = { From: "Ballerina", time: time };
        // Set the created JSON payload as the response message to the caller.
        response.setJsonPayload(payload);
        // Send response back to the caller.
        _ = caller -> forward(response);

    }
}
