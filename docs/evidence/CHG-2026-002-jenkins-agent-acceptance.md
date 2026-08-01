# CHG-2026-002 Jenkins Agent Acceptance

Date: 2026-08-01

## Source and control-plane evidence

- AWX inventory commit `827a5299606bf2033606e07fe2defa871746dac5`:
  branch pipeline 382/job 1026 and main pipeline 383/job 1027 passed.
- Jenkins agent commit `a2544ecb2dc05be16a70cd0606107165a5f62857`:
  branch pipeline 384 jobs 1028/1029 and main pipeline 385 jobs 1030/1031
  passed. Protected controller deployment job 1032 remained manual.
- AWX project update 532 selected exact revision `a2544ec`.
- AWX inventory update 533 retained exactly one enabled
  `jenkins_agents` host: `jenkins-agent01.example.com` at `192.168.1.138`.
- AWX jobs 536 and 541 each reported
  `ok=17 changed=0 unreachable=0 failed=0 skipped=1`.

## Jenkins runtime evidence

Jenkins reported:

- `jenkins-agent01`: online, one executor, exclusive mode, labels
  `jenkins-agent01` and `kubernetes-deployer`;
- built-in node: zero executors;
- inbound service: WebSocket connected.

The bounded temporary acceptance build ran as build 1 on
`jenkins-agent01` and returned:

```text
node=jenkins-agent01
v4.1.0+g4553a0a
Client Version: v1.34.10
openjdk version "21.0.12" 2026-07-21 LTS
git version 2.52.0
gitlab.example.com -> 192.168.1.101
jenkins.example.com -> 192.168.1.102
k8s-control.example.com -> 192.168.1.107
Finished: SUCCESS
```

The temporary acceptance job was removed after this sanitized evidence was
captured. No credential, agent secret, or kubeconfig content was recorded.

## Incidents and boundary

- AWX sync 522 failed until the existing read-only AWX deploy key was enabled
  for `ansible-jenkins`; see INC-2026-065.
- AWX job 527 installed the runtime but failed the initial Helm version check
  because the non-login PATH omitted `/usr/local/bin`; see INC-2026-066.
- The Kubernetes ingress component, kubeconfig credential, Helm release,
  deployment, and rollback were not started as part of agent acceptance.
