local openidc = require("resty.openidc")

local auth_header_name = "Authorization"
local auth_header = ngx.req.get_headers()[auth_header_name] or ""
local first_auth_header, other_auth_headers = auth_header:match("^([^,]*),? *(.*)$")
-- replace auth header with first value
ngx.req.set_header(auth_header_name, first_auth_header)
local token, token_err = openidc.bearer_jwt_verify({
    auth_accept_token_as_header_name = auth_header_name,
    discovery = "https://token.actions.githubusercontent.com/.well-known/openid-configuration",
    token_signing_alg_values_expected = { "RS256" },
    -- iat_slack = math.huge, -- for DEVELOPMENT purpose only
})
-- Remove first auth header to avoid leaking token to upstream
ngx.req.set_header(auth_header_name, other_auth_headers)
-- Set $remote_identity to be used within nginx config e.g. log_format or proxy_set_header X-Identity $remote_identity;
ngx.var.remote_identity = token and token.sub or "-"

if token_err then
    ngx.status = ngx.HTTP_UNAUTHORIZED
    ngx.say(token_err)
    return ngx.exit(ngx.status)
end

-- Check access conditions ----------------------------------------------------
-- TODO Adjust following conditions to your environment
local permitted = true
-- permitted = permitted and token.aud == "example.com"
-- permitted = permitted and token.sub:match("^repo:example/*")
permitted = permitted and token.repository_owner == "example"

if not permitted then
    ngx.status = ngx.HTTP_FORBIDDEN
    ngx.say("Forbidden")
    return ngx.exit(ngx.status)
end
