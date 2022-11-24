const AWS = require("aws-sdk");

const dynamo = new AWS.DynamoDB.DocumentClient();
const { randomUUID } = require('crypto');

exports.handler = async (event, context) => {
  let body;
  const tableName = "unicorntracker"
  let statusCode = 200;
  const headers = {
    "Content-Type": "application/json"
  };

  try {
    switch (event.routeKey) {
      case "DELETE /items/{id}":
        body = await dynamo
          .get({
            TableName: tableName,
            Key: {
              UnicornID: event.pathParameters.id
            }
          })
          .promise();
          if (body.Item){
            await dynamo
              .delete({
                TableName: tableName,
                Key: {
                  UnicornID: event.pathParameters.id
                }
              })
              .promise();
            body = `Deleted item ${event.pathParameters.id}`;
          }else{
            body = `Item not found`;
          }
        break;
      case "GET /items/{id}":
        body = await dynamo
          .get({
            TableName: tableName,
            Key: {
              UnicornID: event.pathParameters.id
            }
          })
          .promise();
        break;
      case "GET /items":
        body = await dynamo.scan({ TableName: tableName }).promise();
        break;
      case "PUT /items":
        let requestJSON = JSON.parse(event.body);
        uuid = AWS.util.uuid.v4();
        if (!requestJSON.name | !requestJSON.length){
          throw new Error(`Unicorn name or length not provided`);
        }
        await dynamo
          .put({
            TableName: tableName,
            Item: {
              UnicornID: uuid,
              UnicornName: requestJSON.name,
              UnicornLength: requestJSON.length
            }
          })
          .promise();
        body = JSON.stringify({ id: uuid});
        break;
      default:
        console.log(`Unsupported route: "${event.pathParameters}" with context "${context}"`);
        throw new Error(`Unsupported route: "${JSON.stringify(event)}" with context "${JSON.stringify(context)}" and routekey : "${routeKey}`);
    }
  } catch (err) {
    statusCode = 400;
    body = err.message;
  } finally {
    body = JSON.stringify(body);
  }

  return {
    statusCode,
    body,
    headers
  };
};