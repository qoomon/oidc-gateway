local openidc = require("resty.openidc")

local token, err = openidc.bearer_jwt_verify({
    auth_accept_token_as_header_name = "Authorization",
    discovery = "https://token.actions.githubusercontent.com/.well-known/openid-configuration",
    token_signing_alg_values_expected = { "RS256" },
    -- iat_slack = math.huge, -- for DEVELOPMENT purpose only
})

if err or not token then
    ngx.status = ngx.HTTP_UNAUTHORIZED
    ngx.say(err and err or "no access_token provided")
    return ngx.exit(ngx.status)
end

-- Set nginx variables --
ngx.var.remote_identity = token.sub

-- Check access conditions --
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

-- Adjust headers ---
ngx.req.clear_header("Authorization")
