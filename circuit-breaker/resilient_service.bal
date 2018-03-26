import ballerina/net.http;
import ballerina/io;

json previousRes;

// A ServiceEndpoint listens to HTTP request on port 9090
// Represents how this service listens
endpoint http:ServiceEndpoint httpListenerEP {
    port:9090
};


endpoint http:ClientEndpoint legacyServiceResilientEP {
    circuitBreaker: {
                        failureThreshold:0,
                        resetTimeout:3000,
                        httpStatusCodes:[400, 404, 500]
                    },
    targets: [{ uri: "http://localhost:9095"}],
    endpointTimeout:6000
};

@http:ServiceConfig {basePath:"/resilient/time"}
service<http:Service> timeInfo bind httpListenerEP {


    @http:ResourceConfig {
        methods:["GET"],
        path:"/"
    }
    getTime (endpoint caller, http:Request req) {

        var response = legacyServiceResilientEP -> get("/legacy/localtime", {});

        match response {
            http:Response res => {
                if (res.statusCode == 200){
                    io:println(" >>> Legacy service invocation successful!");
                    previousRes =? res.getJsonPayload();
                } else {
                    io:println(" >>> Error message received from legacy service");

                }
                _ = caller -> forward(res);
            }
            http:HttpConnectorError err => {
                http:Response errResponse = {};
                io:println(" >>> Circuit Breaker : Open State - "
                           + "Legacy service invocation is prevented!");
                errResponse.statusCode = 503;
                json errJ = {status:"Upstream Failure: " + err.message, cached_response:previousRes};
                errResponse.setJsonPayload(errJ);
                _ = caller -> respond(errResponse);
            }
        }

    }
}




