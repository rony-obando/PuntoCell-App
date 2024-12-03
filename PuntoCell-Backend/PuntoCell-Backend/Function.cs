using Amazon.DynamoDBv2;
using Amazon.DynamoDBv2.Model;
using Amazon.APIGateway.Endpoints;
using Amazon.Lambda.APIGatewayEvents;
using Amazon.Lambda.Core;
using System.Net;
using PuntoCell_Backend.model;
using System.Text.Json;
using PuntoCell_Backend.controller;



// Assembly attribute to enable the Lambda function's JSON input to be converted into a .NET class.


namespace PuntoCell_Backend;


public class Function
{

    private readonly ProductoController _controller;

    public Function()
    {
        var context = DynamoConfig.CreateContext();
        _controller = new ProductoController(context);
    }

    public async Task<APIGatewayHttpApiV2ProxyResponse> FunctionHandler(APIGatewayProxyRequest request, ILambdaContext context)
    {
        Console.WriteLine("ya ingresado al function");

        var responseBody = JsonSerializer.Serialize(await _controller.getAllProducto());

        Console.WriteLine("ya paso por aqui");

        return new APIGatewayHttpApiV2ProxyResponse
        {
            StatusCode = 200,
            Body = responseBody,
            Headers = new Dictionary<string, string>
                {
                    { "Content-Type", "application/json" }
                }
        };
    }

    /// <summary>
    /// A simple function that takes a string and does a ToUpper
    /// </summary>
    /// <param name="input">The event for the Lambda function handler to process.</param>
    /// <param name="context">The ILambdaContext that provides methods for logging and describing the Lambda environment.</param>
    /// <returns></returns>
    //public async void FunctionHandler(APIGatewayProxyRequest request, ILambdaContext context) 
    //{
    //    var client = new AmazonDynamoDBClient();

    //    var request1 = new PutItemRequest
    //    {
    //        TableName = "Producto",
    //        Item = new Dictionary<string, AttributeValue>
    //        {
    //            { "id", new AttributeValue { S = "P123" } },
    //            { "nombre", new AttributeValue { S = "iPhone 15" } },
    //            { "marca", new AttributeValue { S = "Apple" } },
    //            { "precio", new AttributeValue { N = "999.99" } },
    //            { "stock", new AttributeValue { N = "10" } }
    //        }
    //    };

    //    await client.PutItemAsync(request1);
    //    Console.WriteLine("¡Ítem insertado con éxito!");

    //    //return new APIGatewayProxyResponse
    //    //{
    //    //    StatusCode = (int)HttpStatusCode.OK,
    //    //    Body = request.Body.ToUpper(), // Serializa el cuerpo
    //    //    Headers = new Dictionary<string, string>
    //    //{
    //    //    { "Content-Type", "application/json" }
    //    //}
    //    //};
    //}
}
