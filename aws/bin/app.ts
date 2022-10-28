#!/usr/bin/env node
import 'source-map-support/register';
import * as cdk from 'aws-cdk-lib';
import {OIDCGatewayStack} from "../lib/oidc-gateway-stack";
import {CliCredentialsStackSynthesizer} from "aws-cdk-lib";

const app = new cdk.App();

new OIDCGatewayStack(app, 'oidc-gateway', {
    synthesizer: new CliCredentialsStackSynthesizer(),
    env: {
        account: process.env.CDK_DEFAULT_ACCOUNT,
        region: process.env.CDK_DEFAULT_REGION,
    }
});
