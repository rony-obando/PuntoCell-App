using Amazon.Lambda.APIGatewayEvents;
using Amazon.Lambda.Core;
using PuntoCell_Backend.controller;
using PuntoCell_Backend.model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.Json;
using System.Threading.Tasks;

[assembly: LambdaSerializer(typeof(Amazon.Lambda.Serialization.SystemTextJson.DefaultLambdaJsonSerializer))]

namespace PuntoCell_Backend.view
{
    public class VentaFunction
    {
        private readonly VentaController _controller;
        public VentaFunction()
        {
            var context = DynamoConfig.CreateContext();
            _controller = new VentaController(context);
        }
        public async Task<APIGatewayProxyResponse> saveVenta(APIGatewayProxyRequest request, ILambdaContext context)
        {
            var venta = JsonSerializer.Deserialize<Venta>(request.Body);
            if (venta == null)
            {
                throw new ArgumentNullException(nameof(venta));
            }
            if (venta.Id == null)
            {
                venta.Id = Guid.NewGuid().ToString();
            }
            await _controller.saveVenta(venta);

            return new APIGatewayProxyResponse
            {
                StatusCode = 200,
                Body = $"Venta guardado exitosamente. Id:{venta.Id}"
            };
        }
        public async Task<APIGatewayProxyResponse> getAllventa(APIGatewayProxyRequest request, ILambdaContext context)
        {
            try
            {
                var responseBody = JsonSerializer.Serialize(await _controller.getAllVenta());

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
        public async Task<APIGatewayProxyResponse> getVentaId(APIGatewayProxyRequest request, ILambdaContext context)
        {
            try
            {
                var venta = JsonSerializer.Deserialize<Venta>(request.Body);
                if (venta == null)
                {
                    throw new ArgumentNullException(nameof(venta));
                }
                var responseBody = JsonSerializer.Serialize(await _controller.getVentaId(venta.Id));
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
        public async Task<APIGatewayProxyResponse> deleteVenta(APIGatewayProxyRequest request, ILambdaContext context)
        {
            try
            {
                var venta = JsonSerializer.Deserialize<Venta>(request.Body);
                if (venta == null)
                {
                    throw new ArgumentNullException(nameof(venta));
                }
                if (venta.Id == null)
                {
                    throw new ArgumentException("Id es nulo");
                }
                await _controller.deleteVenta(venta.Id);

                return new APIGatewayProxyResponse
                {
                    StatusCode = 200,
                    Body = $"Venta eliminado! Id: {venta.Id}",

                };
            }
            catch (Exception ex)
            {
                throw new Exception(ex.Message);
            }
        }

    }
}
