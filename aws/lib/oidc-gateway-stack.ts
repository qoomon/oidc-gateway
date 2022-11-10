import {Construct} from 'constructs';
import {Cluster, ContainerImage, FargateTaskDefinition, LogDrivers,} from "aws-cdk-lib/aws-ecs";
import {Fn, Stack, StackProps} from "aws-cdk-lib";
import {ApplicationLoadBalancedFargateService} from "aws-cdk-lib/aws-ecs-patterns";
import {Vpc} from "aws-cdk-lib/aws-ec2";
import {RetentionDays} from "aws-cdk-lib/aws-logs";
import {HostedZone} from "aws-cdk-lib/aws-route53";
import {ApplicationProtocol} from "aws-cdk-lib/aws-elasticloadbalancingv2";
import {DockerImageAsset, Platform} from "aws-cdk-lib/aws-ecr-assets";

import {join} from "path";

export class OIDCGatewayStack extends Stack {
    constructor(scope: Construct, id: string, props?: StackProps) {
        super(scope, id, props);

        const vpc = Vpc.fromLookup(this, 'vpc', {
            vpcName: 'YOUR_VPC_NAME', // TODO replace with your VPC name
        })

        const ecsCluster = Cluster.fromClusterAttributes(this, 'cluster', {
            vpc: vpc,
            clusterName: Fn.importValue(`YOUR_ECS_CLUSTER_NAME`),
            securityGroups: [], // securityGroups are not needed, therefore it can be just empty,
        })

        const image = new DockerImageAsset(this, "oidc-gateway-image", {
            directory: join(__dirname, "..", ".."),
            platform: Platform.LINUX_AMD64
        });

        const taskDefinition = new FargateTaskDefinition(this, 'github-actions-gateway-task-definition');
        taskDefinition.addContainer('github-actions-gateway-container', {
            image: ContainerImage.fromDockerImageAsset(image),
            readonlyRootFilesystem: true,
            portMappings: [{hostPort: 443, containerPort: 443}],
            logging: LogDrivers.awsLogs({
                streamPrefix: id,
                logRetention: RetentionDays.ONE_DAY,
            }),
        })

        const domainZone = HostedZone.fromLookup(this, 'hosted-zone', {
            domainName: 'example.com', // TODO replace with your domain name
        })
        const service = new ApplicationLoadBalancedFargateService(this, 'oidc-gateway-service', {
            publicLoadBalancer: true,
            openListener: true,
            protocol: ApplicationProtocol.HTTPS,
            domainZone,
            domainName: `app.${domainZone.zoneName}`, // TODO replace with your subdomain name
            redirectHTTP: true,

            cluster: ecsCluster,
            serviceName: 'oidc-gateway',
            memoryLimitMiB: 1024,
            cpu: 512,
            targetProtocol: ApplicationProtocol.HTTPS,
            taskDefinition,
        });
        service.targetGroup.configureHealthCheck({
            healthyHttpCodes: "401",
        });
    }
}
