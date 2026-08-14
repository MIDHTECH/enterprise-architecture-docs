#!/usr/bin/env python3
"""Add a capability-specific, human-readable walkthrough to each use-case page."""

from collections import Counter
from pathlib import Path
import argparse
import re
import textwrap


ROOT = Path(__file__).resolve().parents[1]
USE_CASE_ROOT = ROOT / "docs/use-cases"

DOMAIN_LENSES = {
    "devsecops": "follow one reviewed change from commit to an identifiable release decision",
    "infrastructure": "follow declared intent through plan, state ownership and post-change verification",
    "kubernetes": "trace one workload contract across namespace, image, policy, service path and recovery",
    "observability": "start with the operator decision the signal must support, then work backward to trustworthy telemetry",
    "governance": "separate what is observed, what policy decides, who authorizes action and what evidence survives",
    "linux": "treat the host or fleet change as a canary-led operating procedure rather than a collection of commands",
    "database": "protect client compatibility and data correctness while the database state changes underneath them",
    "resilience": "begin with user impact and decision authority, then connect diagnosis, mitigation and verified recovery",
    "data": "follow a named producer record through validation, transformation and an accountable consumer",
    "network": "trace the actual packet or request path and make every ownership boundary observable",
    "healthcare-ai": "follow an approved question and evidence source through retrieval, review and a bounded answer",
    "mlops": "keep dataset, code, parameters, model artifact, evaluation and serving decision tied together",
}

ARCHETYPE_READS = {
    "delivery-pipeline": "Read the diagram from left to right as a sequence of gates; a later stage cannot repair missing identity or evidence from an earlier one.",
    "data-flow": "Follow the information rather than the products: ownership and classification travel with it, including on rejected and replayed paths.",
    "feedback-loop": "Begin with the observation, then follow the decision and action back to a new observation; the loop is incomplete until the owner sees the effect.",
    "lifecycle": "Follow the object from creation through change, operation and retirement; every transition needs an owner and a recoverable prior state.",
    "service-path": "Trace one user or system request from source to destination and back; DNS, identity, policy and dependency failures are part of that same path.",
    "decision-map": "Start at the decision rather than the tool, then ask which facts justify allow, block, defer or escalate and who can override it.",
    "response": "Read the design as an operating timeline: detect, establish scope, choose a reversible action, verify recovery and preserve what the team learned.",
}

OPENERS = (
    "A useful way for a new engineer to understand {title} is to {lens}.",
    "In practice, {title} makes sense when you {lens}.",
    "The architecture conversation for {title} should {lens}.",
    "Rather than beginning with a product, explain {title} by asking an engineer to {lens}.",
    "For design review, walk through {title} by trying to {lens}.",
)


def markdown_plain(value: str) -> str:
    value = re.sub(r"\[([^]]+)\]\([^)]+\)", r"\1", value)
    value = value.replace("**", "").replace("`", "")
    return re.sub(r"\s+", " ", value).strip().rstrip(".")


def field(text: str, name: str, fallback: str) -> str:
    match = re.search(rf"^\| {re.escape(name)} \| (.+) \|$", text, re.M)
    return markdown_plain(match.group(1)) if match else fallback


def dependencies(text: str) -> list[tuple[str, str]]:
    section = text.split("## Dependencies and handoffs", 1)[1].split("\n## ", 1)[0]
    results = []
    pattern = re.compile(
        r"^\| [^|]+ \| \[(UC-[A-Z0-9]+-\d{3}): ([^]]+)\]\([^)]+\) \| ([^|]+) \|",
        re.M,
    )
    for use_case_id, name, artifact in pattern.findall(section):
        results.append((f"{use_case_id}: {name}", markdown_plain(artifact)))
    return results[:2]


def failure_and_recovery(text: str) -> tuple[str, str]:
    heading = re.search(r"^## [^\n]*(?:failure|recovery)[^\n]*$", text, re.I | re.M)
    if heading:
        section = text[heading.end():].split("\n## ", 1)[0]
        for line in section.splitlines():
            if not line.startswith("| ") or line.startswith("| ---"):
                continue
            cells = [markdown_plain(cell) for cell in line.strip("|").split("|")]
            if len(cells) >= 3 and cells[0].lower() not in {
                "failure condition",
                "failure mode",
                "condition",
            }:
                return cells[0], cells[-1]
    return (
        "a required dependency or verification result is unavailable",
        "stop before mutation, preserve the evidence and return the decision to the accountable owner",
    )


def wrap(paragraph: str) -> str:
    return textwrap.fill(paragraph, width=96, break_long_words=False, break_on_hyphens=False)


def build_walkthrough(document: Path, text: str, index: int) -> tuple[str, str]:
    title_match = re.fullmatch(
        r"# (UC-[A-Z0-9]+-\d{3}): (.+)", text.splitlines()[0]
    )
    if not title_match:
        raise SystemExit(f"{document}: invalid title")
    use_case_id, title = title_match.groups()
    domain = document.parent.name
    lens = DOMAIN_LENSES[domain]
    outcome = field(text, "Enterprise outcome", f"deliver the documented outcome for {title}")
    target = field(text, "Target", "the accepted existing lab boundary named by the page")
    boundary = field(
        text,
        "Infrastructure boundary",
        "reuse accepted capacity and stop when a required product or target is unavailable",
    )
    owner = field(text, "Owner", f"the {domain} platform owner")
    handoffs = dependencies(text)
    failure, recovery = failure_and_recovery(text)
    threat_match = re.search(r"primary threat is\s+\*\*(.+?)\*\*", text, re.I | re.S)
    threat = markdown_plain(threat_match.group(1)) if threat_match else "an unsafe false-positive result"

    svg = ROOT / "docs/assets/use-cases" / use_case_id / f"{use_case_id}-architecture.svg"
    svg_text = svg.read_text()
    archetype_match = re.search(r'data-archetype="([^"]+)"', svg_text)
    if not archetype_match or archetype_match.group(1) not in ARCHETYPE_READS:
        raise SystemExit(f"{svg}: missing supported architecture archetype")
    archetype = archetype_match.group(1)

    opener = OPENERS[index % len(OPENERS)].format(title=title, lens=lens)
    first = (
        f"{opener} The result MidhHealth needs is to {outcome}. "
        f"{owner} owns the platform decision, while the consuming service or business owner still "
        "accepts the effect on its workflow."
    )

    if handoffs:
        dependency_text = "; ".join(
            f"**{name}** contributes {artifact}" for name, artifact in handoffs
        )
    else:
        dependency_text = "the dependency table supplies the immutable inputs and assurance results"
    second = (
        f"{ARCHETYPE_READS[archetype]} In this page, {dependency_text}. "
        f"The first buildable boundary is {target}. The design stops at this rule: {boundary}."
    )

    third = (
        f"The walkthrough becomes useful when the happy path breaks. If {failure.lower()}, the "
        f"expected response is to {recovery}. The leading design threat is {threat}; therefore a "
        "green source job, screenshot or reachable endpoint is supporting evidence, not acceptance "
        "by itself."
    )

    block = "\n".join(
        [
            "## Design walkthrough",
            "",
            wrap(first),
            "",
            wrap(second),
            "",
            wrap(third),
            "",
        ]
    )
    return block, archetype


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--apply", action="store_true", help="write missing walkthroughs")
    parser.add_argument(
        "--refresh",
        action="store_true",
        help="replace existing walkthroughs from the current page contracts",
    )
    args = parser.parse_args()

    documents = sorted(USE_CASE_ROOT.glob("*/UC-*.md"))
    archetypes = Counter()
    pending = []
    for index, document in enumerate(documents):
        text = document.read_text()
        block, archetype = build_walkthrough(document, text, index)
        archetypes[archetype] += 1
        marker = "## Architecture context"
        if text.count(marker) != 1:
            raise SystemExit(f"{document}: expected exactly one {marker!r}")
        walkthrough_count = text.count("## Design walkthrough")
        if walkthrough_count == 0:
            new_text = text.replace(marker, f"{block}\n{marker}", 1)
        elif walkthrough_count == 1 and args.refresh:
            start = text.index("## Design walkthrough")
            end = text.index(marker, start)
            new_text = text[:start] + block + "\n" + text[end:]
        elif walkthrough_count == 1:
            continue
        else:
            raise SystemExit(f"{document}: expected at most one design walkthrough")
        if new_text != text:
            pending.append((document, new_text))

    print(f"Walkthrough coverage: {len(documents) - len(pending)}/{len(documents)}; pending={len(pending)}")
    print("Architecture archetypes: " + ", ".join(f"{key}={value}" for key, value in sorted(archetypes.items())))
    if args.apply:
        for document, new_text in pending:
            document.write_text(new_text)
        verb = "Refreshed" if args.refresh else "Added"
        print(f"{verb} {len(pending)} design walkthroughs.")
    elif pending:
        print("Dry run only; use --apply to write the walkthroughs.")


if __name__ == "__main__":
    main()
