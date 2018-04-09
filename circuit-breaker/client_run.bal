import ballerina/http;
import ballerina/io;



endpoint http:SimpleClientEndpoint timeServiceEP {
    url:"http://localhost:9090"
};





function main (string[] args) {

    var response =  timeServiceEP -> get("/resilient/time", new);

    match response {
        http:Response res => {
            string s = check res.getStringPayload();
            io:println("Response : " + s);
        }
        http:HttpConnectorError err => {
            io:println("Error : " + err.message);
        }
    }







}
