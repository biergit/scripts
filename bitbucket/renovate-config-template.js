module.exports = {
    "platform": "bitbucket-server",
    "username": "yourusername",
    "password": "yourbearertoken",
    "endpoint": "yourendpoint",
    "repositories": "yourrepos",
    "enabled": true,
    "onboarding": false,
    "requireConfig": false,
    "logLevel": "debug",
    "includeForks": true,
    "enabledManagers": ["maven"],
    "packageRules": [
      {
          "matchDatasources": ["maven"],
          "registryUrls": "yourregistryurls",
          "customRegistrySupport": true
      },
      {
        "matchPackageNames": "yourpackagenames",
        "allowedVersions": "!/99\\.1\\.147$/"
      }
      
    ],
    "ignorePaths": ["**/local-dev/**"],
  };
