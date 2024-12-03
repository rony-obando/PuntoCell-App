using Amazon.DynamoDBv2.DataModel;
using Amazon.DynamoDBv2;
using Amazon;


namespace PuntoCell_Backend.model
{
    public class DynamoConfig
{
    public static DynamoDBContext CreateContext()
    {
        var client = new AmazonDynamoDBClient(RegionEndpoint.USEast2);
        return new DynamoDBContext(client);
    }
}
}
