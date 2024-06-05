--定义签名秘钥
local sk = "token"
local args = ngx.req.get_uri_args()
local token = tostring(args["token"])
local now_time = ngx.now()*1000
local tpe = tostring(args["tpe"])

local timestamp = args["time"]

--判断请求时间是否为空
if timestamp == nil then
    ngx.exit(ngx.HTTP_FORBIDDEN)
end

if tpe == 'long' then
    --判断请求时间是否超时,3 day
    if (now_time-(timestamp*1000)) > 259200000 then
        ngx.exit(ngx.HTTP_FORBIDDEN)
    end
else
    --判断请求时间是否超时,1800秒
    if (now_time-(timestamp*1000)) > 3600000 then
        ngx.exit(ngx.HTTP_FORBIDDEN)
    end
end

--获取请求路径（不含域名），加入签名
local file_path = ngx.var.uri
local sign_str = ''

if tpe == 'long' then
    sign_str = ngx.md5(ngx.md5(file_path..timestamp..'long')..sk)
else
    sign_str = ngx.md5(ngx.md5(file_path..timestamp)..sk)
end

--校验签名
if sign_str ~= token then
    ngx.exit(ngx.HTTP_FORBIDDEN)
end
