# oidc-gateway

#### Setup
* clone repository
* adjust [`nginx.conf`](nginx.conf)
* adjust [`github_actions_oidc.lua`](github_actions_oidc.lua)
* build docker image `docker build -t local/github-actions-gateway .`
* start docker container `docker run --name github-actions-gateway --rm -p 443:8443 local/github-actions-gateway`

#### Local Development
##### Start Proxy Server
```shell  
docker build -t local/github-actions-gateway .
docker run --name github-actions-gateway --rm -p 443:8443 local/github-actions-gateway
# or watch for changes and rebuild and run automatically with entr (https://github.com/eradman/entr)
ls * | entr -r sh -c '
  docker build -t local/github-actions-gateway . \
  && docker run --name github-actions-gateway --rm -p 443:8443 local/github-actions-gateway
'
```
##### Call Proxy Server
```shell
ACTIONS_ID_TOKEN=eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsIng1dCI6ImVCWl9jbjNzWFlBZDBjaDRUSEJLSElnT3dPRSIsImtpZCI6Ijc4MTY3RjcyN0RFQzVEODAxREQxQzg3ODRDNzA0QTFDODgwRUMwRTEifQ.eyJqdGkiOiJjOTAzODNiMC01YTVjLTQ2YTMtODUxZi0wYzQwMDRiMWRkYmUiLCJzdWIiOiJyZXBvOnFvb21vbi9naXRodWItYWN0aW9ucy1hY2Nlc3MtbWFuYWdlcjpyZWY6cmVmcy9oZWFkcy9tYWluIiwiYXVkIjoiaHR0cHM6Ly9naXRodWIuY29tL3Fvb21vbiIsInJlZiI6InJlZnMvaGVhZHMvbWFpbiIsInNoYSI6ImE5Yzk1NDYyM2RkYWE5NTVhMmE3ZjJlYjViYWQ5MjJhNDAzZjAwYzgiLCJyZXBvc2l0b3J5IjoicW9vbW9uL2dpdGh1Yi1hY3Rpb25zLWFjY2Vzcy1tYW5hZ2VyIiwicmVwb3NpdG9yeV9vd25lciI6InFvb21vbiIsInJlcG9zaXRvcnlfb3duZXJfaWQiOiIzOTYzMzk0IiwicnVuX2lkIjoiMzI5MjgxMzc4NCIsInJ1bl9udW1iZXIiOiIxIiwicnVuX2F0dGVtcHQiOiIxIiwicmVwb3NpdG9yeV92aXNpYmlsaXR5IjoicHVibGljIiwicmVwb3NpdG9yeV9pZCI6IjUyMjkyNDUzMSIsImFjdG9yX2lkIjoiMzk2MzM5NCIsImFjdG9yIjoicW9vbW9uIiwid29ya2Zsb3ciOiIuZ2l0aHViL3dvcmtmbG93cy90b2tlbi55YW1sIiwiaGVhZF9yZWYiOiIiLCJiYXNlX3JlZiI6IiIsImV2ZW50X25hbWUiOiJ3b3JrZmxvd19kaXNwYXRjaCIsInJlZl90eXBlIjoiYnJhbmNoIiwiam9iX3dvcmtmbG93X3JlZiI6InFvb21vbi9naXRodWItYWN0aW9ucy1hY2Nlc3MtbWFuYWdlci8uZ2l0aHViL3dvcmtmbG93cy90b2tlbi55YW1sQHJlZnMvaGVhZHMvbWFpbiIsImlzcyI6Imh0dHBzOi8vdG9rZW4uYWN0aW9ucy5naXRodWJ1c2VyY29udGVudC5jb20iLCJuYmYiOjE2NjYyOTgxNjEsImV4cCI6MTY2NjI5OTA2MSwiaWF0IjoxNjY2Mjk4NzYxfQ.37dPzBp031doaTq1alL4s1vpn7ODAX8ks2_cPbloJd-Scaf9fbkdZjYON0Ogm0Gu3yURvSusFVbej22KwHYdTmxQh-NyudXpmqTnTI7RY-9ouiEScY0-D9mc7oUI8INb7phwUOdzOECb48HbPNA04MVwJ2YGQwyWBIXixScMMv3Au3g22NK6Kc_-MPXuSCbBzj2ZLyn2g57BMGs_OveFZy0uRzv5YuzS-QdjBgpesWuJrLgE4DPk3YTkpaLC0rTWo4feNUa53TZStrOREODO-TcWgIAkUJBcNoE3vhJJkBn2NFeovxzW5yj_sO3Kq4E24XYtUrXR52z_34yz9hzdsQ

curl --insecure https://127.0.0.1/foo -H "Authorization: Bearer $ACTIONS_ID_TOKEN"
# or
http --verify=no https://127.0.0.1/foo "Authorization: Bearer $ACTIONS_ID_TOKEN"
```
