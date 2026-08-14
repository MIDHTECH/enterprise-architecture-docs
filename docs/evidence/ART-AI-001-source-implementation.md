# ART-AI-001: UC-AI-001 Source Implementation Evidence

Date recorded: 2026-08-14  
Use case: [UC-AI-001 Retrieval-Augmented Generation](../use-cases/healthcare-ai/UC-AI-001-retrieval-augmented-generation.md)  
Status: Source implemented and validated locally; GitLab publication and runtime acceptance pending

## What was built

Commit `175a39c` (a reviewed descendant of the initial `03e9d1f` commit)
implements the deterministic, source-only RAG performance and reliability
slice in the existing
`midhhealth/ai-and-ml-platform/healthcare-ai-platform` project layout. The
persistent local checkout is
`/Users/krishna/workspace.codex/healthcare-ai-platform`.

The source contains the UC-AI-001 contract and result schema, deterministic
fixture corpus and cases, stable structure-aware chunking, access and metadata
filtering before ranking, parallel lexical and vector retrieval,
reciprocal-rank fusion, bounded reranking and context selection, citation
validation, cache isolation and expiry, stage-level latency measurement,
structured refusals, enforceable case-quality, p95 latency, TTFT, refusal-leak,
and stage-evidence gates, an offline benchmark, and an operator runbook. The
result maps retrieved chunks to their immutable source revisions.

The default evaluator uses a deterministic extractive provider so CI does not
download a model or depend on outbound network access. An optional
OpenAI-compatible adapter is source code only: it denies non-loopback endpoints
by default and supports embeddings plus streamed chat for a separately
approved future local provider such as `llama.cpp`. That adapter is not runtime
acceptance for any model provider.

## Local validation

The following checks passed from the committed checkout:

```text
python3 scripts/validate_source.py
PYTHONPATH=src python3 -m unittest discover -s tests -v
PYTHONPATH=src python3 -m healthcare_ai.rag.benchmark \
  --corpus tests/fixtures/uc-ai-001/corpus.json \
  --cases tests/fixtures/uc-ai-001/cases.json \
  --output build/uc-ai-001-result.json
```

Observed source evidence:

- contract validation passed for three fixture documents and five cases;
- all 14 tests passed from both the working repository and a fresh local clone;
- all five benchmark cases passed;
- negative coverage includes duplicate document IDs, unauthorized metadata
  partitions, cache-scope isolation, provider outage, invented citations, and
  denial of remote model endpoints, prohibited corpus classifications, and a
  deliberately impossible latency gate that fails the decision closed;
- the passing report contains all required stage names, zero refusal leaks,
  the fixture corpus/retrieval/provider revisions, and three source revisions;
- no source-validation step requires package installation or outbound network
  access; commit `175a39c` removes the editable-install instruction from the
  operator runbook so the documented path matches CI.

The benchmark latency values are deterministic local-fixture measurements.
They are not production capacity, service-level, model-quality, or cost
evidence.

## Boundary and non-claims

This work did not install or start Ollama, `llama.cpp`, a model, a vector
database, an API service, a Kubernetes workload, a VM, a cloud resource, or a
new storage service. It did not register the Mac Studio as runtime capacity and
did not ingest PHI, credentials, production records, or an approved enterprise
corpus. No lab deployment or application release occurred.

The local commit is not yet authoritative GitLab evidence. On 2026-08-14,
`gitlab.example.com` resolved to `192.168.1.101`, but SSH port 2222 and HTTP
connections timed out from the administration workstation. The branch has no
upstream and no remote ref is claimed. The failure is recorded as
[INC-2026-086](../sre-incident-register.md#inc-2026-086-gitlab-endpoint-unreachable-during-healthcare-ai-source-publication).

## Promotion gate

When GitLab is reachable, publication must use the exact preserved commit or a
reviewable descendant. The next evidence update must record the authoritative
remote commit, protected pipeline ID, immutable result artifact, and reviewed
failures. Only then may UC-AI-001 advance to `implemented in code`. Runtime
verification still requires separate corpus approval, provider/model decision,
performance thresholds, privacy review, observability, and a deployment change
record.
