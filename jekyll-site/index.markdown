---
layout: page
permalink: /index.html
title: Phenotype List String (PL-String) & PL-String Code (PLSC)
---

<p style="color:darkgrey;">Draft status: This content reflects the current working spec and may be revised.</p>

## Overview

**Phenotype List String (PL-String)** is a compact, machine-readable grammar for
representing antigen- and protein-level information used in antibody assays and
clinical interpretation (e.g., unacceptable/acceptable antigens). It complements
GL-String—used for genotyping—by focusing on **phenotypes** observed or asserted
in assays and interpretations.

**PL-String Code (PLSC)** binds a PL-String to a **namespace** (e.g., IPD-IMGT/HLA,
OPTN, Eurotransplant, NMDP) and a **version (or date)** so that each expression is
fully traceable and interoperable across labs, registries, and allocation systems.

Together, PL-String and PLSC enable:

- Structured representation of **reagent composition** (e.g., SAB bead contents,
  class II heterodimers).
- Structured representation of **test results** (positive/negative/equivocal or
  specificity lists).
- Structured representation of **clinical interpretation** (e.g., antibody
  specificities; acceptable/unacceptable antigens).

This project defines **the grammar and its operators**; it does **not** alter or
renormalize the vocabularies in any namespace (e.g., WHO/IMGT names, OPTN/ET
antigen codes, NMDP MACs). Provenance and naming policies remain governed by the
respective authorities.

## When to use PL-String

Use PL-String when you need a lossless, computable representation of:

[PLSC 1.0 Syntax]({{ '/syntax-1.0.html/' | relative_url }})
1. **Reagents**: The phenotypic composition of materials used in an assay  
   (e.g., “proteins present on a bead” or “heterodimer pairs used in class II
   reagents”).
2. **Results**: The phenotypic reactivities detected in a sample with a given
   reagent set (including ambiguity).
3. **Interpretations**: Curated lists of antibody specificities that drive
   downstream decisions (e.g., screening donors by unacceptable antigens).

> **Scenario (end-to-end):** A patient is typed by NGS and reported as a
> GL-String. SAB reagents are described with PL-Strings. The patient’s antibody
> specificities (interpretation) are encoded as PL-Strings. Donor candidates
> carrying any **unacceptable antigens** are auto-filtered in match reports.

## Core ideas

- **Namespaces**: Every atom (protein/antigen/epitope) comes from one declared,
  versioned namespace (e.g., IPD-IMGT/HLA release; OPTN/ET mapping). You **may
  not** mix namespaces inside a single PL-String.
- **Delimiters with precedence**: Operators encode composition, ambiguity, and
  heterodimeric pairing (see Syntax page for full details).
- **Phenotype-first**: PL-Strings describe **what is present/observed/claimed** at
  the protein/antigen level; they do not assert genotype, chromosomal phase, or
  locus order.

## Namespaces (examples)

- **IPD-IMGT/HLA** — protein-level (2-field) HLA designations and associated
  antigens (per WHO).  
- **OPTN** — allocation codes/mappings used in U.S. solid organ transplant.  
- **Eurotransplant (ET)** — ET codes and match determinants.  
- **NMDP** — registry codes, including MACs for protein ambiguity.  

A namespace must have clear governance, public documentation, versioning, and
stable identifiers.

## PL-String Code (PLSC)

A PLSC binds a PL-String to its vocabulary context:

```
<namespace>#<version or date>#<pl-string>
```

- `<namespace>`: e.g., `hla`, `optn`, `et`, `nmdp`
- `<version or date>`: a release like `3.61.0`, or an ISO date `2025-11-02`
  (when a release tag is not applicable)
- `<pl-string>`: the actual PL-String expression

**Example:**  
`hla#3.61.0#HLA-DQA1*05:01~HLA-DQB1*02:01+HLA-DPB1*04:01`

See the **Syntax** page for complete operator rules, constraints, and examples.

## Interoperability notes

- Within a single PL-String, **do not mix** identifiers from different
  namespaces. If multiple namespaces are needed in one report, use **separate
  PLSCs**, each with its own namespace+version (or date).
- If a release version is unavailable, use the **date** the reagent/result/
  interpretation was created—**not** the collection/export date.
- PLSC is designed to embed cleanly in exchange formats (e.g., HAML / HL7 FHIR)
  as a code with system + version + value.

## Links

- **Syntax (PLSC 1.0)**: [PLSC Syntax & Operators]({{/syntax-1.0.html | relative_url }})
- GL-String background: Milius et al., 2013; Mack et al., 2023
- IMGT/HLA database: Barker et al., 2023

---

<small>
This page updates and consolidates earlier drafts to reflect the PL-String + PLSC
scope (reagents, results, interpretations) and namespace/version requirements, replacing prior placeholder text in earlier pages.
</small>
