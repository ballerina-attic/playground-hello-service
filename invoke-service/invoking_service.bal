import ballerina/net.http;
import ballerina/io;

endpoint http:ServiceEndpoint httpListenerEP {
    port:9090
};


endpoint http:SimpleClientEndpoint backendEP {
    url:"http://localhost:9095"
};


@Description {value:""}
@http:ServiceConfig {basePath:"/time"}
service<http:Service> timeMgr bind httpListenerEP {

    @Description {value:""}
    @http:ResourceConfig {
        methods:["GET"],
        path:"/"
    }
    getTime (endpoint caller, http:Request req) {
        http:Response res = {};

        var clientResponse = backendEP -> get("/localtime", {});

        match clientResponse {
            http:Response response => {
                json time =? response.getJsonPayload();
                json payload = {From: "Ballerina", time: time};
                response.setJsonPayload(payload);
                _ = caller -> forward(response);
            }
            http:HttpConnectorError err => {
                http:Response errorRes = {};
                errorRes.statusCode = 500;
                errorRes.setStringPayload(err.message);
                _ = caller -> respond(errorRes);
            }
        }
    }
}
