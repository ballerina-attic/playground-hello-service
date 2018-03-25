import ballerina/net.http;
import ballerina/io;

// A service endpoint listens to HTTP request on port 9090
endpoint http:ServiceEndpoint httpListenerEP {
    port:9090
};

// A client endpoint can be used to invoke other services
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
        http:Response response =? timeServiceEP -> get("/localtime", {});
        json time =? response.getJsonPayload();
        json payload = {From: "Ballerina", time: time};
        response.setJsonPayload(payload);
        _ = caller -> forward(response);

    }
}
