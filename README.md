![GitHub Actions status](https://github.com/git-qfzhang/Serverless-Devs-Initialization-Actinos/workflows/Check/badge.svg)
[![License](https://img.shields.io/github/license/git-qfzhang/Serverless-Devs-Initialization-Actinos.svg)](https://github.com/git-qfzhang/Serverless-Devs-Initialization-Actinos/blob/master/LICENSE)

# Alibaba Function Computer Deploy Action For Github Actions

Github action for deploying service/function to alibaba function computer.

<!-- toc -->

- [Usage](#usage)
- [Input variables](#credentials)
- [License Summary](#license-summary)

<!-- tocstop -->

## Usage

Deploy all the services and functions in your template.yml to FC.

```yaml
name: deploy to FC

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]
jobs:
  deploy:
    name: deploy service and function
    runs-on: ubuntu-latest
    outputs:
      deploy-logs: ${{ steps.Deploying.outputs.deploy-logs }}
    steps:
    - id: Checkout
      name: Checkout
      uses: actions/checkout@v2

    - id: Initializing-Serverless-Devs
      name: Initializing Serverless-Devs
      uses: git-qfzhang/Serverless-Devs-Initialization-Action@main
      with:
        provider: alibaba
        access_key_id: ${{ secrets.ALIYUN_ACCESS_KEY_ID }}
        access_key_secret: ${{ secrets.ALIYUN_ACCESS_KEY_SECRET }}
        account_id: ${{ secrets.ALIYUN_ACCOUNT_ID }}

    - id: Deploying
      name: Deploying
      uses: git-qfzhang/alibaba-fc-deploy-action@main
      with:
        working_directory: ${{ env.WORKING_DIRECTORY }}
        projects: "*"
```

Deploy the specific function in your template.yml to FC.

```yaml
name: deploy to FC

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]
jobs:
  deploy:
    name: deploy service and function
    runs-on: ubuntu-latest
    outputs:
      deploy-logs: ${{ steps.Deploying.outputs.deploy-logs }}
    steps:
    - id: Checkout
      name: Checkout
      uses: actions/checkout@v2

    - id: Initializing-Serverless-Devs
      name: Initializing Serverless-Devs
      uses: git-qfzhang/Serverless-Devs-Initialization-Action@main
      with:
        provider: alibaba
        access_key_id: ${{ secrets.ALIYUN_ACCESS_KEY_ID }}
        access_key_secret: ${{ secrets.ALIYUN_ACCESS_KEY_SECRET }}
        account_id: ${{ secrets.ALIYUN_ACCOUNT_ID }}

    - id: Deploying
      name: Deploying
      uses: git-qfzhang/alibaba-fc-deploy-action@main
      with:
        working_directory: ${{ env.WORKING_DIRECTORY }}
        projects: myproject
        commands: function
```

Every single porject contains only one function in the template.yml, more infomation can refer to [here](https://github.com/Serverless-Devs-Awesome/fc-alibaba-component).

## Input variables

See [action.yml](action.yml) for the full documentation for this action's inputs.

* working_directory - the directory containing template.yml/template.yaml which could refer to [here](https://github.com/Serverless-Devs-Awesome/fc-alibaba-component/).

* projects - target projects which are delimited by space. The default * represents all projects.

* commands - subcommand of the deployment command, contains:

    * service - only deploy service.
    * function - only deploy function.
    * function --config - only deploy function config.
    * function --code - only deploy function code.
    * tags - only deploy service tags.
    * tags -k/--key <name> - only the specified service tag are deploy.
    * domain - only deploy domain.
    * domain -d/--domain <name> - only deploy the specified domain name.
    * trigger - only deploy trigger.
    * trigger -n/--name <name> - only deploy the specified trigger name.

* args - args of the deployment command, contains:

    * --config - only deploy config.
    * --skip-sync - skip sync auto generated configuration back to template file.

## License Summary

This code is made available under the MIT license.