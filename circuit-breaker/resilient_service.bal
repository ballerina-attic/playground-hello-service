import ballerina/net.http;
import ballerina/io;
import ballerina/log;

json previousRes;

// Represents how this service listens on HTTP at port 9090
endpoint http:ServiceEndpoint httpListenerEP {
    port:9090
};


// Represents a HTTP Client endpoint represents a network-bound HTTP endpoint that we can invoke.
// Circuit breaker allows you to invoke such an endpoint in resilient manner.
// If there are failures when invoking the endpoint, circuit breaker goes to open states
// and prevent invoking the network bound endpoint for the subsequent requests.
endpoint http:ClientEndpoint legacyServiceResilientEP {
    circuitBreaker: {
                        failureThreshold:0, // allowed percentage of failures
                        resetTimeout:3000,  // circuit opening time
                        httpStatusCodes:[400, 404, 500] // http error codes can lead the service to go to open state
                    },
    targets: [{ uri: "http://localhost:9095"}], // URI of the network bound service
    endpointTimeout:6000    // maximum time that it waits for a response from the network bound service.
};


@http:ServiceConfig {basePath:"/resilient/time"}
service<http:Service> timeInfo bind httpListenerEP {

    @http:ResourceConfig {
        methods:["GET"],
        path:"/"
    }
    getTime (endpoint caller, http:Request req) {
        // Invoking the network-bound service by sending a HTTP GET request.
        var response = legacyServiceResilientEP -> get("/legacy/localtime", {});

        // Response coming from network-bound service can contain successful response or an error
        // Hence we can have matching logic for each of the different type
        match response {
            http:Response res => {
                if (res.statusCode == 200) {
                    log:printInfo(">>> Legacy service invocation successful!");
                    previousRes =? res.getJsonPayload();
                } else {
                    log:printInfo(">>> Error message received from legacy service.");
                }
                _ = caller -> forward(res);
            }
            http:HttpConnectorError err => {
                // When the circuit breaker is in open state, it won't allow any request to invoke the legacy service.
                // Rather it returns an error and we can
                http:Response errResponse = {};
                log:printInfo(">>> Circuit Breaker : Open State - "
                            + "Legacy service invocation is prevented!");
                errResponse.statusCode = 503;
                json errJ = {status:"Upstream failure: " + err.message, cached_response:previousRes};
                errResponse.setJsonPayload(errJ);
                _ = caller -> respond(errResponse);
            }
        }

    }
}




