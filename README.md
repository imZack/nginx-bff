# nginx-bff
Nginx + OpenResty = Backend for Frontend (BFF)

## Run

```sh
docker run --name api \
    -p 8080:8080 -it --rm \
    -v `pwd`/example/overview.json:/app/apis/overview.json \
    imZack/nginx-bff
```

## Example API Configuration

```javascript
{
    "endpoints": {
        // Name of the target endpoint
        "opcuaConfig": {
            // Target endpoint
            "endpoint": "http://www.mocky.io/v2/5e9a7d32330000b7c77b3015",
            "headers": {
                // custom headers can be configured here
                "mx-api-token": ""
            }
        },
        "opcuaSecurity": {
            "endpoint": "http://www.mocky.io/v2/5e9a7d7333000021bf7b3016",
            "headers": {
                "mx-api-token": ""
            }
        }
    },
    "transform": {
        "method": "jq", // Avaliable options: "none", "jq"
        "data": {
            "filter": "add" // if method=jq, filter will be your jq filter
        }
    }
}
```

### Example1
- Method: none

```javascript
{
    "opcuaSettings": {
        "data": {
            "maxNodeCount": 1500,
            "minSamplingInterval": 10,
            "maxNotesPerPublish": 1000,
            "maxSessionCount": 5,
            "maxPublishInterval": 50000,
            "allowAnonymous": 1,
            "maxSubscriptLifetime": 100000,
            "maxAuthUserCount": 10,
            "port": 4840,
            "maxMonItemQueueSize": 1,
            "disableCertValidate": 1,
            "minPublishInterval": 10,
            "lifetimeChkInterval": 1000,
            "maxSamplingInterval": 50000,
            "minSubscriptLifetime": 1000
        }
    },
    "opcuaSecurities": {
        "data": {
            "signBasic256": 0,
            "signandencryptBasic256sha256": 1,
            "signBasic128rsa15": 0,
            "signandencryptBasic256": 0,
            "noneNone": 0,
            "signandencryptBasic128rsa15": 0,
            "signBasic256sha256": 1
        }
    }
}
```

### Example 2

- Method: jq
- Filter: `to_entries | map( .value.data ) | add`

```javascript
{
  "maxNodeCount": 1500,
  "minSamplingInterval": 10,
  "maxNotesPerPublish": 1000,
  "maxSessionCount": 5,
  "maxPublishInterval": 50000,
  "allowAnonymous": 1,
  "maxSubscriptLifetime": 100000,
  "maxAuthUserCount": 10,
  "port": 4840,
  "maxMonItemQueueSize": 1,
  "disableCertValidate": 1,
  "minPublishInterval": 10,
  "lifetimeChkInterval": 1000,
  "maxSamplingInterval": 50000,
  "minSubscriptLifetime": 1000,
  "signBasic256": 0,
  "signandencryptBasic256sha256": 1,
  "signBasic128rsa15": 0,
  "signandencryptBasic256": 0,
  "noneNone": 0,
  "signandencryptBasic128rsa15": 0,
  "signBasic256sha256": 1
}
```