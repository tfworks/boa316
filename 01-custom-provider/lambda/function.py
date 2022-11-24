import boto3
import botocore.exceptions
from crhelper import CfnResource
import requests
import json
import os

#backend_api = "https://ppnksjs3ld.execute-api.eu-west-1.amazonaws.com/prod"
backend_api = os.getenv('UT_ENDPOINT')
helper = CfnResource()

@helper.create
def create(event, _):
    if 'UnicornName' in event['ResourceProperties']:
        response = requests.put(f"{backend_api}/items",
                    json = {'name': event['ResourceProperties']['UnicornName'],
                            'length': 1234})
    else:
        raise ValueError("UnicornName is a required property.")
    res_dict = json.loads(response.json())
    helper.Data["UnicornId"] = res_dict['id']
    return res_dict['id']

@helper.update
def update(event, _):
    # not implemented
    return True

@helper.delete
def delete(event, _):
    id = event['PhysicalResourceId']
    response = requests.delete(f"{backend_api}/items/{id}")

def handler(event, context):
    helper(event, context)
