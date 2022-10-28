local openidc = require("resty.openidc")
local token, err = openidc.bearer_jwt_verify({
    discovery = "https://token.actions.githubusercontent.com/.well-known/openid-configuration",
    token_signing_alg_values_expected = { "RS256" },
    auth_accept_token_as_header_name = "Authorization",
    -- iat_slack = math.huge, -- for DEVELOPMENT purpose only
})

if err or not token then
    ngx.status = ngx.HTTP_UNAUTHORIZED
    ngx.say(err and err or "no access_token provided")
    ngx.exit(ngx.status)
end

local permitted = true
-- permitted = permitted and token.aud:match("^qoomon.me$") ~= nil
permitted = permitted and token.sub:match("^repo:qoomon/*")
-- permitted = permitted and token.repository_owner:match("^qoomon$")

if not permitted then
    ngx.status = ngx.HTTP_FORBIDDEN
    ngx.say("Forbidden")
    ngx.exit(ngx.status)
end
