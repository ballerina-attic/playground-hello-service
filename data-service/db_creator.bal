import ballerina/io;
import ballerina/data.sql;




//endpoint sql:Client customers_db {
//    database:sql:DB.H2_FILE,
//    name:"CUSTOMER_DB"
//};

//endpointsql:ClientEndpoint testDBEP {
//    database: sql:DB.H2_MEM,
//    name: "testdb"
//}


function main (string[] args) {

    //var testDB = testDBEP.getConnector();
    //
    //
    //int ret = testDB.update("CREATE TABLE CUSTOMER(ID INT AUTO_INCREMENT, NAME VARCHAR(255),
    // AGE INT, PRIMARY KEY (ID))", null);
    //
    //
    //
    //sql:Parameter[] params = [];
    //sql:Parameter para1 = {sqlType : sql:Type.VARCHAR, value : name};
    //sql:Parameter para2 = {sqlType : sql:Type.INTEGER, value : age};
    //params = [para1, para2];
    //
    //int update_row_cnt =? customers_db -> update("INSERT INTO CUSTOMER (NAME, AGE) VALUES (?,?)", params);
    //
    //table dt = testDB -> select("SELECT  * from Customers", null, null);

}
