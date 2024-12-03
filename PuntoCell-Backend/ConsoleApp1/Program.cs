using Amazon.DynamoDBv2;
using Amazon.DynamoDBv2.Model;
using Amazon.APIGateway.Endpoints;
using Amazon.Lambda.APIGatewayEvents;
using Amazon.Lambda.Core;
using System.Net;
using PuntoCell_Backend.model;
using PuntoCell_Backend.view;
using System.Text.Json;
using PuntoCell_Backend.controller;
using Amazon.DynamoDBv2.DataModel;
public class program
{

    /// <summary>
    /// A simple function that takes a string and does a ToUpper
    /// </summary>
    /// <param name="input">The event for the Lambda function handler to process.</param>
    /// <param name="context">The ILambdaContext that provides methods for logging and describing the Lambda environment.</param>
    /// <returns></returns>
    /// 

    static async System.Threading.Tasks.Task Main(string[] args)
    {
        var context = DynamoConfig.CreateContext();
        var _controller = new ProductoController(context);
        
        var body = JsonSerializer.Serialize(new
        {
            Id = "6a12289f-316c-45aa-a9e1-a41431b9f23b",
            nombre = "Samsung S21 5G",
            marca = "Samsung",
            stock = 1000
        });
        APIGatewayProxyRequest aPI = new APIGatewayProxyRequest();
        aPI.Body = body;
        ProductoFunction productoFunction = new ProductoFunction();
        Console.WriteLine("1");
        var r = await productoFunction.deteleProducto(aPI, null);
        Console.WriteLine(r.Body);


    }
}

public class DynamoConfig
{
    public static DynamoDBContext CreateContext()
    {
        var client = new AmazonDynamoDBClient();
        return new DynamoDBContext(client);
    }
}