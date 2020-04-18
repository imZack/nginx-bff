
local http = require "resty.http"
local cjson = require "cjson"
local shell = require "resty.shell"

local args, err = ngx.req.get_uri_args()
local api = args["api"]

if not api then
    ngx.say("please provid ?api=")
    return
end

-- Load api information
local file = io.open("/app/apis/" .. api .. ".json", "r") 
local config_str = file:read("*a")
local config = cjson.decode(config_str)

-- Assemble pipeline config
local responses = {}
local currentIdx = 0
for key, value in pairs(config["endpoints"]) do
    -- Send Pipeline requests
    local httpc = http.new()
    local params = {}

    if value["headers"] then
        params["headers"] = value["headers"]
    end

    if value["ssl_verify"] then
        params["ssl_verify"] = value["ssl_verify"]
    end

    local res, err = httpc:request_uri(value["endpoint"], params)
    if not res then
        ngx.say("failed to request: ", err)
        return
    end
    responses[key] = cjson.decode(res.body)
end

-- Responding

ngx.header.content_type = "application/json"
if config["transform"]["method"] == "none" then
    ngx.say(cjson.encode(responses))
    ngx.exit(ngx.HTTP_OK)
    return
end

-- jq formatting data
local stdin = cjson.encode(responses)
local timeout = 5000  -- ms
local max_size = 40960  -- byte
local command = "jq '" .. config["transform"]["data"]["filter"] .. "'"
local ok, stdout, stderr, reason, status =
    shell.run(command, stdin, timeout, max_size)
if not ok then
    ngx.say("failed to jq", stderr)
    return
end

-- Respond
ngx.say(stdout)
ngx.exit(ngx.HTTP_OK)
