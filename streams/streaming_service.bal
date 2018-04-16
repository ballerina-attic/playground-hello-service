import ballerina/http;
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

future f1 = start initStreamConsumer();

stream<StockUpdate> inStream;

function initStreamConsumer () {

    stream<Result> resultStream;

    resultStream.subscribe(quoteCountEventHandler);
    resultStream.subscribe(quoteAverageEventHandler);

    forever {
        from inStream where price > 1000
             window timeBatch(3000)
        select symbol
               , count(symbol) as count
               , avg(price) as average
        group by symbol
        => (Result [] result) {
            resultStream.publish(result);
        }
    }
}

function quoteCountEventHandler (Result result) {
    io:println("Quote - " + result.symbol
                  + " : count = " + result.count);
}

function quoteAverageEventHandler (Result result) {
    io:println("Quote - " + result.symbol
                  + " : average = " + result.average);
}


service<http:Service> nasdaq bind {} {


    publishQuote (endpoint conn, http:Request req) {
        string reqStr = check req.getStringPayload();
        float stockPrice  = check <float> reqStr;

        string stockSymbol = "GOOG";

        StockUpdate stockUpdate = {symbol:stockSymbol,
                                      price:stockPrice};
        inStream.publish(stockUpdate);

        http:Response res = new;
        res.statusCode = 202;
        _ = conn -> respond(res);
    }

}