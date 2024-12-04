using Amazon.DynamoDBv2.DataModel;
using Amazon.DynamoDBv2.Model;
using PuntoCell_Backend.model;

namespace PuntoCell_Backend.controller
{
    public class VentaController
    {
        private readonly DynamoDBContext _dynamoDBContext;

        public VentaController(DynamoDBContext dynamoDBContext)
        {
            _dynamoDBContext = dynamoDBContext;
        }

        public async Task saveVenta(Venta venta)
        {
            if (venta == null)
            {
                throw new ArgumentNullException(nameof(venta));
            }

            try
            {
                await _dynamoDBContext.SaveAsync(venta);
            }
            catch (Exception ex)
            {
                throw new Exception(ex.Message);
            }

        }

        public async Task deleteVenta(string Id)
        {
            try
            {
                var requestDelete = new DeleteItemRequest
                {

                    TableName = "Venta",
                    Key = new Dictionary<string, AttributeValue>
                    {
                        { "Id", new AttributeValue { S = Id } }
                    }
                };
                await _dynamoDBContext.DeleteAsync<Venta>(Id);
            }
            catch (Exception ex)
            {
                throw new Exception(ex.Message);
            }
        }

        public async Task<List<Venta>> getAllVenta()
        {
            try
            {
                var ventas = new List<Venta>();
                var search = _dynamoDBContext.ScanAsync<Venta>(new List<ScanCondition>());

                do
                {
                    var page = await search.GetNextSetAsync();
                    ventas.AddRange(page);
                } while (!search.IsDone);
                return ventas;
            }
            catch (Exception ex)
            {
                throw new Exception(ex.Message);
            }
        }
        public async Task<Venta> getVentaId(string Id)
        {
            try
            {
                return await _dynamoDBContext.LoadAsync<Venta>(Id);
            }
            catch (Exception ex)
            {
                throw new Exception(ex.Message);
            }
        }
    }
}
