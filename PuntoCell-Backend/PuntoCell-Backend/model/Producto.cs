using Amazon.DynamoDBv2.DataModel;

namespace PuntoCell_Backend.model
{
    [DynamoDBTable("Producto")]

    public class Producto
{
        [DynamoDBHashKey]
        public string Id { get; set; }
        [DynamoDBProperty]
        public string nombre { get; set; }
        [DynamoDBProperty]
        public string marca { get; set; }
        [DynamoDBProperty]
        public int stock { get; set; }
}
}
