using Amazon.Lambda.APIGatewayEvents;
using Amazon.Lambda.Core;
using PuntoCell_Backend.controller;
using PuntoCell_Backend.model;
using System.Text.Json;

namespace PuntoCell_Backend.view
{
    public class ProductoFunction
    {
        private readonly ProductoController _controller;

        public ProductoFunction()
        {
            var context = DynamoConfig.CreateContext();
            _controller = new ProductoController(context);
        }

        public async Task<APIGatewayProxyResponse> saveProducto(APIGatewayProxyRequest request, ILambdaContext context)
        {
            var producto = JsonSerializer.Deserialize<Producto>(request.Body);
            if (producto == null)
            {
                throw new ArgumentNullException(nameof(producto));
            }
            if (producto.Id == null)
            {
                producto.Id = Guid.NewGuid().ToString();
            }
            await _controller.saveProducto(producto);

            return new APIGatewayProxyResponse
            {
                StatusCode = 200,
                Body = $"Producto guardado exitosamente. Id:{producto.Id}"
            };
        }
        public async Task<APIGatewayProxyResponse> getAllProducto(APIGatewayProxyRequest request, ILambdaContext context)
        {
            try
            {
                var responseBody = JsonSerializer.Serialize(await _controller.getAllProducto());

                return new APIGatewayProxyResponse
                {
                    StatusCode = 200,
                    Body = responseBody,
                    Headers = new Dictionary<string, string>
                    {
                        { "Content-Type", "application/json" }
                    }
                };
            }
            catch (Exception ex)
            {
                throw new Exception(ex.Message);
            }
        }
        public async Task<APIGatewayHttpApiV2ProxyResponse> getProductoId(APIGatewayProxyRequest request, ILambdaContext context)
        {
            try
            {
                var producto = JsonSerializer.Deserialize<Producto>(request.Body);
                if (producto == null)
                {
                    throw new ArgumentNullException(nameof(producto));
                }
                var responseBody = JsonSerializer.Serialize(await _controller.getProductoId(producto.Id));
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
            catch (Exception ex)
            {
                throw new Exception(ex.Message);
            }
        }
        public async Task<APIGatewayProxyResponse> deteleProducto(APIGatewayProxyRequest request, ILambdaContext context)
        {
            try
            {
                var producto = JsonSerializer.Deserialize<Producto>(request.Body);
                if(producto == null)
                {
                    throw new ArgumentNullException(nameof(producto));
                }
                if (producto.Id == null)
                {
                    throw new ArgumentException("Id es nulo");
                }
                await _controller.deleteProducto(producto.Id);

                return new APIGatewayProxyResponse
                {
                    StatusCode = 200,
                    Body = $"Produto eliminado! Id: {producto.Id}",

                };
            }
            catch (Exception ex)
            {
                throw new Exception(ex.Message);
            }
        }
    }
}
