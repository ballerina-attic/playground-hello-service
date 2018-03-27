import ballerina/net.http;
import ballerina/io;
import ballerina/log;

json previousRes;

endpoint http:ServiceEndpoint listener {
    port:9090
};


// Client endpoints represent remote network location
// Circuit breaker resilient invocation of such an endpoint.
// Circuit is in CLOSED state by default
// Circuit goes to OPEN state when there are errors or timeouts
// When the circuit is OPEN, it won't invoke the remote
// endpoint. Rather it returns an error in which user has to handle.
endpoint http:ClientEndpoint legacyServiceResilientEP {
    circuitBreaker: {
                    // failures allowed
                        failureThreshold:0,
                    // max circuit open time
                        resetTimeout:3000,
                    // error codes to open the circuit
                        httpStatusCodes:[400, 404, 500]
                    },
// URI of the network bound service
    targets: [{ uri: "http://localhost:9095"}],
// Maximum time that it waits for a response
// from the remote network location.
    endpointTimeout:6000
};


@http:ServiceConfig {basePath:"/resilient/time"}
service<http:Service> timeInfo bind listener {

    @http:ResourceConfig {
        methods:["GET"],
        path:"/"
    }
    getTime (endpoint caller, http:Request req) {



        var response = legacyServiceResilientEP
                       -> get("/legacy/localtime", {});

        // Match response for successful or failed messages.
        match response {
            http:Response res => {
                if (res.statusCode == 200) {
                    log:printInfo(">>> Remote service invocation successful!");
                    previousRes =? res.getJsonPayload();
                } else {
                    // Remote endpoint returns and error.
                    log:printInfo(">>> Error message received from remote service.");
                }
                _ = caller -> forward(res);
            }
            http:HttpConnectorError err => {
                // When circuit breaker is open, it suspends
                // the invocation of the network endpoint and
                // throws an error. This is the logic
                // that you write to handle the such cases
                // gracefully.
                http:Response errResponse = {};
                log:printInfo(">>> Circuit Breaker : Open State - "
                            + "Remote service invocation is suspended!");
                // Set Service Unavailable status code
                errResponse.statusCode = 503;
                // Reply with a cached response.
                json errJ = { CACHED_RESPONSE:previousRes };
                errResponse.setJsonPayload(errJ);
                _ = caller -> respond(errResponse);
            }
        }

    }
}




