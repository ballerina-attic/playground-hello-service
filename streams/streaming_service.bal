import ballerina/http;
import ballerina/mime;
import ballerina/io;

type  StockUpdate {
  string symbol;
  float price;
};

type Result {
  string symbol;
  int count;
  float average;
};

future f1 = async initStockStreamConsumer();


stream<StockUpdate> inStream;

function initStockStreamConsumer () {

    stream<Result> resultStream;

    resultStream.subscribe(resultEventListenerFn1);
    resultStream.subscribe(resultEventListenerFn2);

    forever {
        from inStream where price > 1000
             window timeBatch(5000)
        select symbol
               , count(symbol) as count
               , avg(price) as average
        group by symbol
                          having count > 3
        => (Result [] result) {
            resultStream.publish(result);
        }
    }
}

function resultEventListenerFn1 (Result result) {
    io:println("Result Event Listener 1 : Received more than 3 requests within 5s from "
               + result.symbol + ", in which stock price is > 1000.0");
}

function resultEventListenerFn2 (Result result) {
    io:println("Result Event Listener 2: Average stock price : "
               + result.average + " of "
               + result.symbol + " within 5s.");
}



@http:ServiceConfig {
    basePath:"/nasdaq"
}
service<http:Service> StoreService bind {} {


    @http:ResourceConfig {
        methods:["POST"],
        path:"/quotes/GOOG"
    }
    requests (endpoint conn, http:Request req) {
        string reqStr = check req.getStringPayload();
        float stockPrice  = check <float> reqStr;

        string stockSymbol = "GOOG";

        //io:println("Stock Info : " + stockSymbol + " - "
        //              + stockPrice);

        StockUpdate stockUpdate = {symbol:stockSymbol,
                                      price:stockPrice};
        inStream.publish(stockUpdate);

        http:Response res = {statusCode:202};
        _ = conn -> respond(res);
    }

}