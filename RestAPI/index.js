//Initiallising node modules
var express = require("express");
var bodyParser = require("body-parser");
var sql = require("mssql");
var app = express(); 

app.use(bodyParser.urlencoded({ extended: false }))
// Body Parser Middleware
app.use(bodyParser.json()); 

//CORS Middleware
app.use(function (req, res, next) {
    //Enabling CORS 
    res.header("Access-Control-Allow-Origin", "*");
    res.header("Access-Control-Allow-Methods", "GET,HEAD,OPTIONS,POST,PUT");
    res.header("Access-Control-Allow-Headers", "Origin, X-Requested-With, contentType,Content-Type, Accept, Authorization");
    next();
});

//Setting up server
 var server = app.listen(process.env.PORT || 4000, function () {
    var port = server.address().port;
    console.log("App now running on port", port);
 });

//Initiallising connection string
var dbConfig = {  
    options: {
        encrypt: true
    },
    user: "deos",  
    password: "SacredHell.1984",  
    server: "deossql.database.windows.net",  
    database: "DC_Testdb"  
};  

//Function to connect to database and execute query
var  executeQuery = function(res, query){     
    sql.close()        
     sql.connect(dbConfig, function (err) {
         if (err) {   
                     console.log("Error while connecting database :- " + err);
                     res.send(err);
                  }
                  else {
                         // create Request object
                         var request = new sql.Request();
                         // query to the database
                         request.query(query, function (err, responseResult) {
                           if (err) {
                                      console.log("Error while querying database :- " + err);
                                      res.send(err);
                                     }
                                     else {
                                       res.send(responseResult);
                                            }
                               });
                       }
      });           
}

  
//GET API  Client
app.get("/clients/:id", function(req ,res){  
    var Sqlquery = "EXEC dbo.GetClient @ClientId = " + req.params.id;  
    executeQuery (res, Sqlquery);  
});  


//POST API
//app.post("/api/user", function(req , res){
//    var query = "INSERT INTO [user] (Name,Email,Password) VALUES (req.body.Name,req.body.Email,req.body.Password”);
//    executeQuery (res, query);
//});

//PUT API Client
app.post("/clients", function(req ,res){  
    //console.log(_req.body);
    app.use(bodyParser.json());    

    console.log(req.body);  
    
    var Sqlquery = `DECLARE @ClientId INT = NULL
    EXEC dbo.PutClient  @ClientId = @ClientId , @ClientName = ` + req.body.ClientName + `,
                       @UserName = ` + req.body.UserName + `,
                       @VersionId = NULL             -- timestamp
    
    SELECT @ClientId AS ClientId`
    executeQuery(res, Sqlquery);  
});  