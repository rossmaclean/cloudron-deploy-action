# Cloudron Deploy Action
This actions deploys a Docker image to a Cloudron server.

## Arguments
### Image
- **Key**: image
- **Required**: true

Docker image to be deployed to Cloudron e.g. `myuser/myimage:myversion`

### App Domain
- **Key**: app-domain
- **Required**: true

Domain where the app should be installed/updated in Cloudron e.g. `myapp.server.com`

### Cloudron Server
- **Key**: cloudron-server
- **Required**: true

Cloudron server e.g. my.server.com

### Cloudron Token
- **Key**: cloudron-token
- **Required**: true

Cloudron auth token

### Install If Missing
- **Key**: install-if-missing 
- **Required**: true
- **Default**: "true"

Should the app be installed if not currently? False results in using update only. `true/false`