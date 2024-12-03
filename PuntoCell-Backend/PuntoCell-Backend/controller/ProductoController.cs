using Amazon.DynamoDBv2.DataModel;
using Amazon.DynamoDBv2.Model;
using PuntoCell_Backend.model;

namespace PuntoCell_Backend.controller
{
    public class ProductoController
    {
        private readonly DynamoDBContext _dynamoDBContext;

        public ProductoController(DynamoDBContext dynamoDBContext)
        {
            _dynamoDBContext = dynamoDBContext;
        }

        public async Task saveProducto(Producto producto)
        {
            if (producto == null) 
            {
                throw new ArgumentNullException(nameof(producto));
            }
            
            try
            {
                await _dynamoDBContext.SaveAsync(producto);
            }
            catch (Exception ex)
            {
                throw new Exception(ex.Message);
            }

        }

        public async Task deleteProducto(string Id)
        {
            try
            {
                var requestDelete = new DeleteItemRequest
                {
                    
                    TableName = "Producto",
                    Key = new Dictionary<string, AttributeValue>
                    {
                        { "Id", new AttributeValue { S = Id } }
                    }
                };
                await _dynamoDBContext.DeleteAsync<Producto>(Id);
            }
            catch (Exception ex)
            {
                throw new Exception(ex.Message);
            }
        }

        public async Task<List<Producto>> getAllProducto()
        {
            try
            {
                var productos = new List<Producto>();
                Console.WriteLine("Esperando..");
                var search = _dynamoDBContext.ScanAsync<Producto>(new List<ScanCondition>());
                Console.WriteLine("datos obtenidos!");

                do
                {
                    var page = await search.GetNextSetAsync();
                    productos.AddRange(page);
                } while (!search.IsDone);
                return productos;
            }
            catch (Exception ex)
            {
                throw new Exception(ex.Message);
            }
        }
        public async Task<Producto> getProductoId(string Id)
        {
            try
            {
                return await _dynamoDBContext.LoadAsync<Producto>(Id);
            }
            catch (Exception ex)
            {
                throw new Exception(ex.Message);
            }
        }
    }
}
